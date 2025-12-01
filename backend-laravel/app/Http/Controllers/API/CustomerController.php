<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\API\BaseController;
use App\Models\Customer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CustomerController extends BaseController
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Customer::query();
        
        // Search functionality
        if ($request->has('search')) {
            $query->where('name', 'like', '%' . $request->search . '%')
                  ->orWhere('email', 'like', '%' . $request->search . '%')
                  ->orWhere('phone', 'like', '%' . $request->search . '%');
        }
        
        $customers = $query->get();
        return $this->sendResponse($customers, 'Customers retrieved successfully.');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required',
            'email' => 'nullable|email|unique:customers,email',
            'phone' => 'nullable|unique:customers,phone',
            'address' => 'nullable'
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation Error', $validator->errors(), 422);
        }

        $customer = Customer::create($request->all());
        return $this->sendResponse($customer, 'Customer created successfully.', 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Customer $customer)
    {
        return $this->sendResponse($customer, 'Customer retrieved successfully.');
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Customer $customer)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'sometimes',
            'email' => 'nullable|email|unique:customers,email,'.$customer->id,
            'phone' => 'nullable|unique:customers,phone,'.$customer->id,
            'address' => 'nullable'
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation Error', $validator->errors(), 422);
        }

        $customer->update($request->all());
        return $this->sendResponse($customer, 'Customer updated successfully.');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Customer $customer)
    {
        $customer->delete();
        return $this->sendResponse([], 'Customer deleted successfully.');
    }
}
