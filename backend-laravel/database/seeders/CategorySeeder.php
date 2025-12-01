<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Category;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            [
                'name' => 'Food & Beverages',
                'description' => 'Food and drink items'
            ],
            [
                'name' => 'Electronics',
                'description' => 'Electronic devices and accessories'
            ],
            [
                'name' => 'Clothing',
                'description' => 'Apparel and fashion items'
            ],
            [
                'name' => 'Home & Garden',
                'description' => 'Household and garden products'
            ],
            [
                'name' => 'Health & Beauty',
                'description' => 'Healthcare and beauty products'
            ]
        ];
        
        foreach ($categories as $category) {
            Category::firstOrCreate(
                ['name' => $category['name']],
                $category
            );
        }
    }
}
