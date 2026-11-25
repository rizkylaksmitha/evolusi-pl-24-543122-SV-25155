<?php

use Illuminate\Support\Facades\Route;

Route::get('/bmi', function () {
    return response()->json([
        ['id' => 1, 'nama' => 'Andi', 'tinggi' => 170, 'berat' => 65, 'bmi' => 22.49, 'kategori' => 'Normal'],
        ['id' => 2, 'nama' => 'Budi', 'tinggi' => 165, 'berat' => 75, 'bmi' => 27.55, 'kategori' => 'Overweight'],
        ['id' => 3, 'nama' => 'Citra', 'tinggi' => 160, 'berat' => 50, 'bmi' => 19.53, 'kategori' => 'Normal'],
    ]);
});