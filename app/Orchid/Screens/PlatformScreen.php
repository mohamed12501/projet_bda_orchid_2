<?php

declare(strict_types=1);

namespace App\Orchid\Screens;

use App\Models\Etudiant;
use App\Models\Professeur;
use App\Models\Module;
use App\Models\Salle;
use App\Models\PlanningRun;
use App\Models\PeriodeExamen;
use Orchid\Screen\Screen;
use Orchid\Support\Facades\Layout;

class PlatformScreen extends Screen
{
    /**
     * Fetch data to be displayed on the screen.
     *
     * @return array
     */
    public function query(): iterable
    {
        return [
            'total_etudiants' => Etudiant::count(),
            'total_professeurs' => Professeur::count(),
            'total_modules' => Module::count(),
            'total_salles' => Salle::count(),
            'total_runs' => PlanningRun::count(),
            'runs_published' => PlanningRun::where('published', true)->count(),
            'total_periodes' => PeriodeExamen::count(),
        ];
    }

    /**
     * The name of the screen displayed in the header.
     */
    public function name(): ?string
    {
        return 'Tableau de Bord';
    }

    /**
     * Display header description.
     */
    public function description(): ?string
    {
        return 'Vue d\'ensemble du système de gestion des examens';
    }

    /**
     * The screen's action buttons.
     *
     * @return \Orchid\Screen\Action[]
     */
    public function commandBar(): iterable
    {
        return [];
    }

    /**
     * The screen's layout elements.
     *
     * @return \Orchid\Screen\Layout[]
     */
    public function layout(): iterable
    {
        return [
            // First row: Key metrics in columns
            Layout::columns([
                Layout::metrics([
                    'Total Étudiants' => 'total_etudiants',
                    'Total Professeurs' => 'total_professeurs',
                ]),
                Layout::metrics([
                    'Total Modules' => 'total_modules',
                    'Total Salles' => 'total_salles',
                ]),
                Layout::metrics([
                    'Runs de Planning' => 'total_runs',
                    'Runs Publiés' => 'runs_published',
                ]),
            ]),

         
        ];
    }
}
