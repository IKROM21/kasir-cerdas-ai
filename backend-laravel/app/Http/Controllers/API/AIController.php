<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\API\BaseController;
use App\Models\Product;
use App\Models\Transaction;
use App\Models\TransactionItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class AIController extends BaseController
{
    /**
     * Get product recommendations based on sales
     */
    public function getProductRecommendations(Request $request)
    {
        $limit = $request->get('limit', 10);
        
        // Get best selling products
        $recommendations = TransactionItem::select('product_id', DB::raw('SUM(quantity) as total_sold'))
            ->groupBy('product_id')
            ->orderBy('total_sold', 'desc')
            ->limit($limit)
            ->with('product')
            ->get()
            ->map(function ($item) {
                return [
                    'product' => $item->product,
                    'total_sold' => $item->total_sold
                ];
            });
            
        return $this->sendResponse($recommendations, 'Product recommendations retrieved successfully.');
    }
    
    /**
     * Detect slow-moving products
     */
    public function getSlowMovingProducts(Request $request)
    {
        $days = $request->get('days', 30);
        $limit = $request->get('limit', 10);
        
        $cutoffDate = Carbon::now()->subDays($days);
        
        // Get products that haven't been sold in the last N days
        $slowMovingProducts = Product::whereDoesntHave('transactionItems', function ($query) use ($cutoffDate) {
            $query->where('created_at', '>', $cutoffDate);
        })
        ->withCount(['transactionItems as sales_count' => function ($query) use ($cutoffDate) {
            $query->where('created_at', '>', $cutoffDate);
        }])
        ->orderBy('sales_count', 'asc')
        ->limit($limit)
        ->get();
        
        return $this->sendResponse($slowMovingProducts, 'Slow moving products retrieved successfully.');
    }
    
    /**
     * Get automatic restock suggestions
     */
    public function getRestockSuggestions(Request $request)
    {
        $threshold = $request->get('threshold', 10); // Minimum stock threshold
        
        // Get products with low stock
        $lowStockProducts = Product::where('stock', '<=', $threshold)
            ->orderBy('stock', 'asc')
            ->get();
            
        $suggestions = $lowStockProducts->map(function ($product) {
            // Simple suggestion: double the current stock
            return [
                'product' => $product,
                'current_stock' => $product->stock,
                'suggested_quantity' => max(10, $product->stock * 2),
                'priority' => $product->stock == 0 ? 'high' : ($product->stock < 5 ? 'medium' : 'low')
            ];
        });
        
        return $this->sendResponse($suggestions, 'Restock suggestions retrieved successfully.');
    }
    
    /**
     * Predict sales
     */
    public function predictSales(Request $request)
    {
        $days = $request->get('days', 7);
        
        // Simple prediction based on average daily sales
        $startDate = Carbon::now()->subDays(30);
        $endDate = Carbon::now();
        
        $dailySales = Transaction::select(
            DB::raw('DATE(created_at) as date'),
            DB::raw('COUNT(*) as transaction_count'),
            DB::raw('SUM(total_amount) as total_sales')
        )
        ->whereBetween('created_at', [$startDate, $endDate])
        ->groupBy(DB::raw('DATE(created_at)'))
        ->orderBy('date')
        ->get();
        
        if ($dailySales->isEmpty()) {
            return $this->sendResponse([], 'Not enough data for sales prediction.');
        }
        
        // Calculate averages
        $avgDailyTransactions = $dailySales->avg('transaction_count');
        $avgDailyRevenue = $dailySales->avg('total_sales');
        
        // Predictions
        $predictions = [];
        $currentDate = Carbon::now();
        
        for ($i = 1; $i <= $days; $i++) {
            $predictionDate = $currentDate->copy()->addDays($i);
            $predictions[] = [
                'date' => $predictionDate->format('Y-m-d'),
                'predicted_transactions' => round($avgDailyTransactions),
                'predicted_revenue' => round($avgDailyRevenue, 2)
            ];
        }
        
        $result = [
            'period' => $days . ' days',
            'average_daily_transactions' => round($avgDailyTransactions, 2),
            'average_daily_revenue' => round($avgDailyRevenue, 2),
            'predictions' => $predictions
        ];
        
        return $this->sendResponse($result, 'Sales predictions generated successfully.');
    }
    
    /**
     * Get automatic promo suggestions
     */
    public function getPromoSuggestions(Request $request)
    {
        $limit = $request->get('limit', 5);
        
        // Suggest promotions for slow-moving products
        $slowProducts = $this->getSlowMovingProductsInternal(30, $limit);
        
        $promotions = $slowProducts->map(function ($product) {
            return [
                'product' => $product,
                'promo_type' => 'discount',
                'discount_percentage' => 15, // 15% discount
                'reason' => 'Low sales in the last 30 days'
            ];
        });
        
        return $this->sendResponse($promotions, 'Promo suggestions retrieved successfully.');
    }
    
    /**
     * Internal method to get slow moving products
     */
    private function getSlowMovingProductsInternal($days = 30, $limit = 10)
    {
        $cutoffDate = Carbon::now()->subDays($days);
        
        return Product::whereDoesntHave('transactionItems', function ($query) use ($cutoffDate) {
            $query->where('created_at', '>', $cutoffDate);
        })
        ->limit($limit)
        ->get();
    }
}
