<?php

namespace Database\Seeders;

use App\Models\HealthCenter;
use App\Models\Organization;
use App\Models\Unit;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    public function run(): void
    {
        $organizacion = Organization::create([
            'name'      => 'Servicio de Salud Metropolitano Sur',
            'is_active' => true,
        ]);

        $centro = HealthCenter::create([
            'organization_id' => $organizacion->id,
            'name'            => 'Hospital El Pino',
            'is_active'       => true,
        ]);

        $unidad = Unit::create([
            'health_center_id' => $centro->id,
            'name'             => 'Urgencias Adulto',
            'is_active'        => true,
        ]);

        $usuarios = [
            ['Super Administrador',         'super_admin@test.com',         'super_admin'],
            ['Administrador Institucional', 'admin_institucional@test.com', 'admin_institucional'],
            ['Funcionario de Admision',     'admision@test.com',            'admision'],
            ['TENS Categorizacion',         'categorizacion@test.com',      'categorizacion'],
            ['Medico de Urgencias',         'medico@test.com',              'medico'],
        ];

        foreach ($usuarios as [$nombre, $correo, $rol]) {
            User::create([
                'organization_id'  => $organizacion->id,
                'health_center_id' => $centro->id,
                'unit_id'          => $unidad->id,
                'name'             => $nombre,
                'email'            => $correo,
                'password'         => Hash::make('password123'),
                'role'             => $rol,
                'is_active'        => true,
            ]);
        }

        $this->call(PictogramSeeder::class);
    }
}