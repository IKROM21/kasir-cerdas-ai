<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\API\BaseController;
use App\Models\Transaction;
use App\Models\TransactionItem;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class TransactionController extends BaseController
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Transaction::with(['customer', 'user']);
        
        // Filter by date range
        if ($request->has('start_date') && $request->has('end_date')) {
            $query->whereBetween('created_at', [
                Carbon::parse($request->start_date)->startOfDay(),
                Carbon::parse($request->end_date)->endOfDay()
            ]);
        }
        
        // Filter by status
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }
        
        // Filter by user
        if ($request->has('user_id')) {
            $query->where('user_id', $request->user_id);
        }
        
        $transactions = $query->latest()->get();
        return $this->sendResponse($transactions, 'Transactions retrieved successfully.');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'customer_id' => 'nullable|exists:customers,id',
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'required|exists:products,id',
            'items.*.quantity' => 'required|integer|min:1',
            'paid_amount' => 'required|numeric|min:0',
            'notes' => 'nullable'
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation Error', $validator->errors(), 422);
        }

        try {
            DB::beginTransaction();
            
            // Calculate total amount
            $totalAmount = 0;
            foreach ($request->items as $item) {
                $product = Product::find($item['product_id']);
                $totalAmount += $product->price * $item['quantity'];
                
                // Check stock
                if ($product->stock < $item['quantity']) {
                    DB::rollBack();
                    return $this->sendError('Insufficient stock for product: ' . $product->name);
                }
            }
            
            // Calculate change
            $changeAmount = $request->paid_amount - $totalAmount;
            if ($changeAmount < 0) {
                DB::rollBack();
                return $this->sendError('Insufficient payment amount');
            }
            
            // Create transaction
            $transaction = Transaction::create([
                'invoice_number' => 'INV-' . now()->format('YmdHis') . rand(100, 999),
                'customer_id' => $request->customer_id,
                'user_id' => auth()->id(),
                'total_amount' => $totalAmount,
                'paid_amount' => $request->paid_amount,
                'change_amount' => $changeAmount,
                'status' => 'completed',
                'notes' => $request->notes
            ]);
            
            // Create transaction items and update stock
            foreach ($request->items as $item) {
                $product = Product::find($item['product_id']);
                $unitPrice = $product->price;
                $totalPrice = $unitPrice * $item['quantity'];
                
                TransactionItem::create([
                    'transaction_id' => $transaction->id,
                    'product_id' => $item['product_id'],
                    'quantity' => $item['quantity'],
                    'unit_price' => $unitPrice,
                    'total_price' => $totalPrice
                ]);
                
                // Update product stock
                $product->decrement('stock', $item['quantity']);
            }
            
            DB::commit();
            
            // Load relationships
            $transaction->load(['customer', 'user', 'transactionItems.product']);
            
            return $this->sendResponse($transaction, 'Transaction created successfully.', 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return $this->sendError('Transaction failed: ' . $e->getMessage(), [], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Transaction $transaction)
    {
        $transaction->load(['customer', 'user', 'transactionItems.product']);
        return $this->sendResponse($transaction, 'Transaction retrieved successfully.');
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Transaction $transaction)
    {
        $validator = Validator::make($request->all(), [
            'customer_id' => 'nullable|exists:customers,id',
            'status' => 'sometimes|in:pending,completed,cancelled',
            'notes' => 'nullable'
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation Error', $validator->errors(), 422);
        }

        $transaction->update($request->all());
        return $this->sendResponse($transaction, 'Transaction updated successfully.');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Transaction $transaction)
    {
        $transaction->delete();
        return $this->sendResponse([], 'Transaction deleted successfully.');
    }
    
    /**
     * Complete a transaction.
     */
    public function complete(Transaction $transaction)
    {
        if ($transaction->status === 'completed') {
            return $this->sendError('Transaction is already completed');
        }
        
        $transaction->update(['status' => 'completed']);
        return $this->sendResponse($transaction, 'Transaction completed successfully.');
    }
    
    /**
     * Get sales report.
     */
    public function salesReport(Request $request)
    {
        $query = Transaction::where('status', 'completed');
        
        // Filter by date range
        if ($request->has('start_date') && $request->has('end_date')) {
            $query->whereBetween('created_at', [
                Carbon::parse($request->start_date)->startOfDay(),
                Carbon::parse($request->end_date)->endOfDay()
            ]);
        }
        
        $transactions = $query->get();
        
        $report = [
            'total_transactions' => $transactions->count(),
            'total_revenue' => $transactions->sum('total_amount'),
            'total_items_sold' => $transactions->flatMap->transactionItems->sum('quantity'),
            'average_transaction_value' => $transactions->count() > 0 ? $transactions->avg('total_amount') : 0
        ];
        
        return $this->sendResponse($report, 'Sales report retrieved successfully.');
    }
}
