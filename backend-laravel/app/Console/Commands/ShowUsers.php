<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\User;

class ShowUsers extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:show-users';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Show all users in the database';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $users = User::all();
        
        if ($users->isEmpty()) {
            $this->info('No users found in the database.');
            return;
        }
        
        $this->table(
            ['ID', 'Name', 'Email'],
            $users->map(function ($user) {
                return [
                    $user->id,
                    $user->name,
                    $user->email,
                ];
            })
        );
    }
}