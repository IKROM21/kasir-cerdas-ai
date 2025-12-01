<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\API\BaseController;
use App\Models\Product;
use App\Models\Transaction;
use App\Models\Customer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class DashboardController extends BaseController
{
    /**
     * Get dashboard statistics
     */
    public function index(Request $request)
    {
        $startDate = $request->has('start_date') ? Carbon::parse($request->start_date)->startOfDay() : Carbon::now()->startOfMonth();
        $endDate = $request->has('end_date') ? Carbon::parse($request->end_date)->endOfDay() : Carbon::now()->endOfDay();
        
        // Total sales
        $totalSales = Transaction::where('status', 'completed')
            ->whereBetween('created_at', [$startDate, $endDate])
            ->sum('total_amount');
            
        // Total transactions
        $totalTransactions = Transaction::where('status', 'completed')
            ->whereBetween('created_at', [$startDate, $endDate])
            ->count();
            
        // Total products
        $totalProducts = Product::count();
        
        // Low stock products
        $lowStockProducts = Product::where('stock', '<=', 10)->count();
        
        // Recent transactions
        $recentTransactions = Transaction::with(['customer', 'user'])
            ->where('status', 'completed')
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get();
            
        // Daily sales chart data
        $dailySales = Transaction::select(
            DB::raw('DATE(created_at) as date'),
            DB::raw('SUM(total_amount) as total_sales'),
            DB::raw('COUNT(*) as transaction_count')
        )
        ->where('status', 'completed')
        ->whereBetween('created_at', [$startDate, $endDate])
        ->groupBy(DB::raw('DATE(created_at)'))
        ->orderBy('date')
        ->get();
        
        $dashboardData = [
            'total_sales' => $totalSales,
            'total_transactions' => $totalTransactions,
            'total_products' => $totalProducts,
            'low_stock_products' => $lowStockProducts,
            'recent_transactions' => $recentTransactions,
            'daily_sales' => $dailySales
        ];
        
        return $this->sendResponse($dashboardData, 'Dashboard data retrieved successfully.');
    }
}
