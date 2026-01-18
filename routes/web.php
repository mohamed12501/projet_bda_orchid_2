<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    if (auth()->check()) {
        return redirect()->route('platform.index');
    }
    return view('welcome');
});
