<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\User;

class CreateTestUser extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:create-test-user';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Create a test user for Flutter development';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        // Check if user already exists
        $existingUser = User::where('email', 'test@example.com')->first();
        
        if ($existingUser) {
            $this->info('User already exists:');
            $this->info('Email: test@example.com');
            $this->info('Password: password123');
            return;
        }

        // Create new user
        $user = User::create([
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => bcrypt('password123'),
        ]);

        $this->info('Test user created successfully!');
        $this->info('Email: test@example.com');
        $this->info('Password: password123');
    }
}