<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\ProductController;
use App\Http\Controllers\API\CategoryController;
use App\Http\Controllers\API\CustomerController;
use App\Http\Controllers\API\TransactionController;
use App\Http\Controllers\API\AIController;
use App\Http\Controllers\API\DashboardController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and assigned to the "api" group.
|
*/

// Debug route
Route::get('/debug', function () {
    return response()->json([
        'message' => 'API is working',
        'time' => now()->toDateTimeString(),
    ]);
});

// Public routes
Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    
    // User profile
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
    
    // Dashboard
    Route::get('/dashboard', [DashboardController::class, 'index']);
    
    // Categories
    Route::apiResource('categories', CategoryController::class);
    
    // Products
    Route::apiResource('products', ProductController::class);
    Route::put('/products/{product}/stock', [ProductController::class, 'updateStock']);
    
    // Customers
    Route::apiResource('customers', CustomerController::class);
    
    // Transactions
    Route::apiResource('transactions', TransactionController::class);
    Route::post('/transactions/{transaction}/complete', [TransactionController::class, 'complete']);
    Route::get('/transactions/report/sales', [TransactionController::class, 'salesReport']);
    
    // AI Features
    Route::get('/ai/recommendations', [AIController::class, 'getProductRecommendations']);
    Route::get('/ai/slow-products', [AIController::class, 'getSlowMovingProducts']);
    Route::get('/ai/restock-suggestions', [AIController::class, 'getRestockSuggestions']);
    Route::get('/ai/sales-predictions', [AIController::class, 'predictSales']);
    Route::get('/ai/promo-suggestions', [AIController::class, 'getPromoSuggestions']);
});

Route::get('/cek', function () {
    return response()->json([
        'pesan' => 'Laravel menerima request!',
    ]);
});