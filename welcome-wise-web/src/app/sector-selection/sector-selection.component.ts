import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { OnboardingService } from '../onboarding.service';

interface Sector {
  id: string;
  name: string;
  desc: string;
  icon: string;
  colorClass: string;
}

@Component({
  selector: 'app-sector-selection',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="min-h-[calc(100vh-140px)] flex flex-col items-center justify-center p-6 max-w-6xl mx-auto">
      <!-- Header -->
      <div class="text-center mb-10 max-w-xl animate-fade-in">
        <span class="bg-primary-blue/10 border border-primary-blue/20 text-primary-blue font-extrabold text-[10px] tracking-widest uppercase py-1.5 px-4 rounded-full"> Étape 2 • Profil d'Intégration </span>
        <h1 class="text-slate-800 font-black text-3xl sm:text-4xl mt-4 font-display leading-tight">Choisissez votre secteur d'activité</h1>
        <p class="text-slate-500 font-medium text-sm mt-3">Sélectionnez le département auquel vous êtes rattaché(e) pour débloquer votre feuille de route d'onboarding personnalisée.</p>
      </div>

      <!-- Sector Cards Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 w-full max-w-4xl animate-fade-in">
        @for (sector of sectors; track sector.id) {
          <button 
            (click)="selectSector(sector.id)" 
            class="group bg-white border border-slate-100 rounded-3xl p-6 text-left transition-all duration-300 hover:-translate-y-1 hover:border-gold hover:shadow-2xl hover:shadow-gold/10 relative overflow-hidden flex flex-col justify-between min-h-[200px] cursor-pointer"
          >
            <!-- Golden Glow Ring on hover -->
            <div class="absolute inset-0 border border-gold opacity-0 group-hover:opacity-100 transition-opacity duration-300 rounded-3xl pointer-events-none shadow-[inset_0_0_15px_rgba(201,168,76,0.15)]"></div>

            <div class="flex flex-col gap-4">
              <!-- Icon Container -->
              <div 
                [class]="sector.colorClass" 
                class="w-12 h-12 rounded-2xl flex items-center justify-center text-white shadow-md group-hover:scale-110 transition-transform duration-300"
              >
                <span class="material-icons-round text-2xl">{{ sector.icon }}</span>
              </div>

              <div>
                <h3 class="text-slate-800 font-extrabold text-lg tracking-tight font-display mb-1 group-hover:text-primary-blue transition-colors">
                  {{ sector.name }}
                </h3>
                <p class="text-slate-400 font-medium text-xs leading-relaxed">
                  {{ sector.desc }}
                </p>
              </div>
            </div>

            <!-- Bottom Action indicator -->
            <div class="flex items-center gap-1.5 text-slate-400 group-hover:text-gold transition-colors text-[10px] font-bold uppercase tracking-wider mt-4">
              <span>Choisir ce secteur</span>
              <span class="material-icons-round text-sm group-hover:translate-x-1 transition-transform">arrow_forward</span>
            </div>
          </button>
        }
      </div>
    </div>
  `,
  styles: [`
    :host {
      display: block;
    }
  `]
})
export class SectorSelectionComponent {
  private onboardingService = inject(OnboardingService);
  private router = inject(Router);

  readonly sectors: Sector[] = [
    {
      id: 'BTP',
      name: 'Bâtiment & Travaux Publics (BTP)',
      desc: 'Onboarding orienté chantiers de construction, infrastructures, gestion de projets civils et sécurité BTP.',
      icon: 'architecture',
      colorClass: 'bg-gradient-to-br from-amber-500 to-amber-600'
    },
    {
      id: 'Béton',
      name: 'Béton & Préfabriqué',
      desc: 'Feuille de route pour les centrales à béton, techniques de malaxage, logistique bétonnière et HSE usine.',
      icon: 'precision_manufacturing',
      colorClass: 'bg-gradient-to-br from-slate-500 to-slate-600'
    },
    {
      id: 'Carrières',
      name: 'Exploitation des Carrières',
      desc: 'Règles spécifiques d\'extraction, de concassage, de logistique de granulats et sécurité en milieu minier.',
      icon: 'terrain',
      colorClass: 'bg-gradient-to-br from-emerald-500 to-emerald-600'
    },
    {
      id: 'Transport',
      name: 'Logistique & Transport',
      desc: 'Intégration pour la flotte de livraison, la chaîne de distribution, la sécurité routière et la mécanique.',
      icon: 'local_shipping',
      colorClass: 'bg-gradient-to-br from-blue-500 to-blue-600'
    },
    {
      id: 'Holding',
      name: 'Ménara Holding Corp',
      desc: 'Parcours corporate : départements administratifs, RH, IT, Finance, communication et gouvernance du groupe.',
      icon: 'corporate_fare',
      colorClass: 'bg-gradient-to-br from-purple-500 to-purple-600'
    }
  ];

  selectSector(sectorId: string) {
    this.onboardingService.setSector(sectorId);
    this.router.navigate(['/roadmap']);
  }
}
