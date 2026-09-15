<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class HandleCorsOptions
{
    public function handle(Request $request, Closure $next)
    {
        if ($request->isMethod('OPTIONS')) {
            return response('', 200)
                ->header('Access-Control-Allow-Origin', $request->header('Origin'))
                ->header('Access-Control-Allow-Methods', 'GET, POST, PUT, PATCH, DELETE, OPTIONS')
                ->header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With')
                ->header('Access-Control-Max-Age', '86400');
        }

        return $next($request);
    }
}