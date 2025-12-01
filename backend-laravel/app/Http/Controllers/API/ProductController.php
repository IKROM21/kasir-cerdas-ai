<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\API\BaseController;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ProductController extends BaseController
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Product::with('category');
        
        // Search functionality
        if ($request->has('search')) {
            $query->where('name', 'like', '%' . $request->search . '%');
        }
        
        // Filter by category
        if ($request->has('category_id')) {
            $query->where('category_id', $request->category_id);
        }
        
        // Stock filter
        if ($request->has('low_stock')) {
            $query->where('stock', '<=', 10);
        }
        
        $products = $query->get();
        return $this->sendResponse($products, 'Products retrieved successfully.');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|unique:products,name',
            'description' => 'nullable',
            'price' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
            'sku' => 'required|unique:products,sku',
            'category_id' => 'required|exists:categories,id'
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation Error', $validator->errors(), 422);
        }

        $product = Product::create($request->all());
        return $this->sendResponse($product, 'Product created successfully.', 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Product $product)
    {
        $product->load('category');
        return $this->sendResponse($product, 'Product retrieved successfully.');
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Product $product)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|unique:products,name,'.$product->id,
            'description' => 'nullable',
            'price' => 'sometimes|numeric|min:0',
            'stock' => 'sometimes|integer|min:0',
            'sku' => 'sometimes|unique:products,sku,'.$product->id,
            'category_id' => 'sometimes|exists:categories,id'
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation Error', $validator->errors(), 422);
        }

        $product->update($request->all());
        return $this->sendResponse($product, 'Product updated successfully.');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Product $product)
    {
        $product->delete();
        return $this->sendResponse([], 'Product deleted successfully.');
    }
    
    /**
     * Update product stock.
     */
    public function updateStock(Request $request, Product $product)
    {
        $validator = Validator::make($request->all(), [
            'stock' => 'required|integer|min:0'
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation Error', $validator->errors(), 422);
        }

        $product->update(['stock' => $request->stock]);
        return $this->sendResponse($product, 'Product stock updated successfully.');
    }
}
