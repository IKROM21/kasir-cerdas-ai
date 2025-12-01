<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Product;
use App\Models\Category;

class ProductSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = Category::all();
        
        if ($categories->isEmpty()) {
            $this->call(CategorySeeder::class);
            $categories = Category::all();
        }
        
        $products = [
            [
                'name' => 'Coffee Latte',
                'description' => 'Freshly brewed coffee with milk',
                'price' => 25000,
                'stock' => 50,
                'sku' => 'COFF-LAT-001',
                'category_id' => $categories->firstWhere('name', 'Food & Beverages')->id
            ],
            [
                'name' => 'Cappuccino',
                'description' => 'Espresso with steamed milk foam',
                'price' => 23000,
                'stock' => 40,
                'sku' => 'COFF-CAP-001',
                'category_id' => $categories->firstWhere('name', 'Food & Beverages')->id
            ],
            [
                'name' => 'Smartphone XYZ',
                'description' => 'Latest model smartphone with advanced features',
                'price' => 5000000,
                'stock' => 20,
                'sku' => 'PHN-XYZ-001',
                'category_id' => $categories->firstWhere('name', 'Electronics')->id
            ],
            [
                'name' => 'Bluetooth Headphones',
                'description' => 'Wireless headphones with noise cancellation',
                'price' => 750000,
                'stock' => 30,
                'sku' => 'AUD-BTH-001',
                'category_id' => $categories->firstWhere('name', 'Electronics')->id
            ],
            [
                'name' => 'T-Shirt Premium',
                'description' => 'Comfortable cotton t-shirt',
                'price' => 150000,
                'stock' => 100,
                'sku' => 'CLT-TSH-001',
                'category_id' => $categories->firstWhere('name', 'Clothing')->id
            ]
        ];
        
        foreach ($products as $product) {
            Product::firstOrCreate(
                ['sku' => $product['sku']],
                $product
            );
        }
    }
}
