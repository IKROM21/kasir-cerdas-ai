<?php

namespace App\Http\Controllers\API;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;

class AuthController extends BaseController
{
    /**
     * Register a new user.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function register(Request $request)
    {
        Log::info('Registration attempt', ['request_data' => $request->all()]);
        
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8',
        ]);

        if ($validator->fails()) {
            Log::warning('Registration validation failed', ['errors' => $validator->errors()]);
            return $this->sendError('Validation Error', $validator->errors(), 422);
        }

        try {
            $input = $request->all();
            $input['password'] = bcrypt($input['password']);
            
            // Check if email already exists
            $existingUser = User::where('email', $input['email'])->first();
            if ($existingUser) {
                Log::warning('Email already registered', ['email' => $input['email']]);
                return $this->sendError('Registration failed', ['email' => 'Email already registered'], 422);
            }
            
            $user = User::create($input);
            
            if (!$user) {
                Log::error('Failed to create user');
                return $this->sendError('Registration failed', ['error' => 'Could not create user'], 500);
            }
            
            // Create token only if user was created successfully
            $success['token'] = $user->createToken('MyApp')->plainTextToken;
            $success['name'] = $user->name;

            Log::info('User registered successfully', ['user_id' => $user->id]);
            return $this->sendResponse($success, 'User registered successfully.');
        } catch (\Exception $e) {
            Log::error('Registration error', ['exception' => $e->getMessage(), 'trace' => $e->getTraceAsString()]);
            return $this->sendError('Registration failed', ['error' => 'Internal server error occurred'], 500);
        }
    }

    /**
     * Login to the application.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function login(Request $request)
    {
        Log::info('Login attempt', ['email' => $request->email]);
        
        if (Auth::attempt(['email' => $request->email, 'password' => $request->password])) {
            $user = Auth::user();
            $success['token'] = $user->createToken('MyApp')->plainTextToken;
            $success['name'] = $user->name;

            Log::info('User logged in successfully', ['user_id' => $user->id]);
            return $this->sendResponse($success, 'User logged in successfully.');
        } else {
            Log::warning('Invalid login credentials', ['email' => $request->email]);
            return $this->sendError('Unauthorized', ['error' => 'Invalid credentials'], 401);
        }
    }

    /**
     * Logout from the application.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function logout(Request $request)
    {
        try {
            auth()->user()->tokens()->delete();
            Log::info('User logged out successfully', ['user_id' => auth()->id()]);
            return $this->sendResponse([], 'User logged out successfully.');
        } catch (\Exception $e) {
            Log::error('Logout error', ['exception' => $e->getMessage()]);
            return $this->sendError('Logout failed', ['error' => $e->getMessage()], 500);
        }
    }
}