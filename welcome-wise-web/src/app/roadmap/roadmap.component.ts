import { Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { OnboardingService, OnboardingModule } from '../onboarding.service';

@Component({
  selector: 'app-roadmap',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="min-h-[calc(100vh-140px)] max-w-6xl mx-auto px-4 py-8 flex flex-col items-center">
      
      <!-- Greeting and Current State Card -->
      <div class="w-full bg-white rounded-3xl p-6 shadow-xl border border-slate-100 mb-8 flex flex-col sm:flex-row items-center justify-between gap-6 animate-fade-in">
        <div class="flex items-center gap-4">
          <div class="w-14 h-14 rounded-2xl bg-primary-blue/5 border border-primary-blue/10 flex items-center justify-center text-primary-blue shadow-inner">
            <span class="material-icons-round text-3xl">handshake</span>
          </div>
          <div>
            <h2 class="text-slate-800 font-extrabold text-xl font-display leading-tight">Bonjour, Meryem !</h2>
            <p class="text-slate-400 text-xs font-semibold uppercase mt-0.5 tracking-wider">
              Secteur sélectionné : <span class="text-gold font-bold">{{ selectedSector() || 'BTP / Béton' }}</span>
            </p>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <div class="text-right">
            <div class="text-slate-400 text-[10px] font-bold uppercase tracking-wider">Progression d'Intégration</div>
            <div class="text-primary-blue font-black text-lg font-display">{{ globalProgressPercentage() }}%</div>
          </div>
          <div class="w-24 bg-slate-100 h-2.5 rounded-full overflow-hidden">
            <div class="bg-gradient-to-r from-gold to-gold-light h-full rounded-full transition-all duration-500" [style.width.%]="globalProgressPercentage()"></div>
          </div>
        </div>
      </div>

      <!-- Roadmap Timeline Card -->
      <div class="w-full bg-white border border-slate-100 rounded-3xl p-8 shadow-xl relative animate-fade-in">
        <h3 class="text-slate-800 font-black text-xl text-center mb-10 font-display">Mon Parcours d'Intégration</h3>

        <!-- Desktop Horizontal Timeline (Showing 3 modules + Voir Plus card) -->
        <div class="hidden md:block relative h-[380px] w-full">
          <!-- Connective Serpentine Path SVG connecting outer borders -->
          <svg class="absolute inset-0 w-full h-[380px] pointer-events-none" fill="none">
            <path 
              d="M 190,100 C 220,100 230,230 260,230 M 450,230 C 480,230 490,100 520,100 M 690,100 C 715,100 725,230 740,230" 
              stroke="#C9A84C" 
              stroke-width="3" 
              stroke-dasharray="8,8"
              class="opacity-70"
            />
          </svg>

          <!-- Module 1: Left Upper -->
          <div class="absolute top-[30px] left-[20px] w-[170px]">
            <ng-container *ngTemplateOutlet="moduleCard; context: { $implicit: modules()[0] }"></ng-container>
          </div>

          <!-- Module 2: Center-Left Lower (Active) -->
          <div class="absolute top-[160px] left-[260px] w-[190px]">
            <ng-container *ngTemplateOutlet="moduleCard; context: { $implicit: modules()[1] }"></ng-container>
          </div>

          <!-- Module 3: Center-Right Upper (Locked) -->
          <div class="absolute top-[30px] left-[520px] w-[170px]">
            <ng-container *ngTemplateOutlet="moduleCard; context: { $implicit: modules()[2] }"></ng-container>
          </div>

          <!-- Card 4: Voir Plus (+) Card in desktop layout -->
          <div 
            (click)="showAllModulesModal.set(true)"
            class="absolute top-[160px] left-[740px] w-[170px] border-2 border-dashed border-[#D4AF37]/45 bg-white hover:bg-[#FAF8F5] rounded-2xl p-4 flex flex-col items-center justify-center gap-2 transition-all duration-300 shadow-sm min-h-[140px] cursor-pointer hover:scale-[1.03] select-none text-center"
          >
            <div class="w-10 h-10 rounded-full bg-[#FAF6F0] flex items-center justify-center text-[#8C7355] border border-[#D4AF37]/30 shadow-inner">
              <span class="material-icons-round text-xl font-bold">add</span>
            </div>
            <h4 class="text-[#0F172A] font-black text-xs font-display">Voir Plus</h4>
            <span class="text-[9px] text-slate-400 font-bold">Afficher tous les modules</span>
          </div>
        </div>

        <!-- Mobile Vertical Timeline -->
        <div class="md:hidden relative w-full flex flex-col gap-8 pl-8">
          <!-- Left Line -->
          <div class="absolute left-[20px] top-4 bottom-4 w-0.5 bg-gradient-to-b from-gold via-gold/40 to-slate-200 border-dashed border-l border-gold shadow-[0_0_10px_rgba(201,168,76,0.2)]"></div>

          @for (mod of modules().slice(0, 3); track mod.id) {
            <div class="relative">
              <!-- Node Icon -->
              <div 
                [class.bg-emerald-500]="mod.status === 'completed'"
                [class.bg-primary-blue]="mod.status === 'current'"
                [class.bg-slate-300]="mod.status === 'locked'"
                [class.shadow-primary-blue/30]="mod.status === 'current'"
                [class.animate-pulse]="mod.status === 'current'"
                class="absolute left-[-26px] top-3 w-4 h-4 rounded-full border-2 border-white shadow-md z-10"
              ></div>
              <div class="w-full max-w-sm">
                <ng-container *ngTemplateOutlet="moduleCard; context: { $implicit: mod }"></ng-container>
              </div>
            </div>
          }

          <!-- Mobile Voir Plus Item -->
          <div class="relative">
            <!-- Node Icon -->
            <div class="absolute left-[-26px] top-3 w-4 h-4 rounded-full border-2 border-[#D4AF37] bg-white z-10"></div>
            <div 
              (click)="showAllModulesModal.set(true)"
              class="w-full max-w-sm border-2 border-dashed border-[#D4AF37]/45 bg-white hover:bg-[#FAF8F5] rounded-2xl p-4 flex flex-col items-center justify-center gap-2 transition-all duration-300 shadow-sm min-h-[110px] cursor-pointer hover:scale-[1.03] select-none text-center"
            >
              <div class="w-8 h-8 rounded-full bg-[#FAF6F0] flex items-center justify-center text-[#8C7355] border border-[#D4AF37]/30 shadow-inner">
                <span class="material-icons-round text-lg font-bold">add</span>
              </div>
              <h4 class="text-[#0F172A] font-black text-xs font-display">Voir Plus</h4>
              <span class="text-[9px] text-slate-400 font-bold">Afficher tous les modules</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Interaction & Quiz Card Container (Separated) -->
      <div class="w-full bg-white border border-slate-100 rounded-3xl p-8 shadow-xl relative animate-fade-in mt-8">
        
        <!-- Section Header -->
        <h3 class="text-slate-800 font-black text-xl text-center mb-8 font-display">
          Zone d'Interaction & Quiz IA de l'Employé
        </h3>

        <!-- Interaction cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 w-full max-w-4xl mx-auto">
          
          <!-- Card 1: Livret d'accueil -->
          <div (click)="openDoc('Guide de l Employe (PDF)')" class="bg-white border-2 border-slate-100 hover:border-[#D4AF37]/35 rounded-3xl p-6 shadow-sm hover:shadow-md transition-all duration-300 flex flex-col items-center text-center cursor-pointer select-none hover:scale-[1.02]">
            <div class="w-12 h-12 rounded-2xl bg-[#FAF6F0] flex items-center justify-center text-[#8C7355] mb-4 border border-[#D4AF37]/30">
              <span class="material-icons-round text-2xl">description</span>
            </div>
            <h4 class="text-xs font-black text-[#0F172A] tracking-tight uppercase">Guide de l'Employé (PDF)</h4>
            <span class="text-[10px] text-slate-500 font-bold mt-1">Livret d'accueil</span>
          </div>

          <!-- Card 2: Contacts -->
          <div (click)="openDoc('Contacts Importants')" class="bg-white border-2 border-slate-100 hover:border-[#D4AF37]/35 rounded-3xl p-6 shadow-sm hover:shadow-md transition-all duration-300 flex flex-col items-center text-center cursor-pointer select-none hover:scale-[1.02]">
            <div class="w-12 h-12 rounded-2xl bg-[#FAF6F0] flex items-center justify-center text-[#8C7355] mb-4 border border-[#D4AF37]/30">
              <span class="material-icons-round text-2xl">import_contacts</span>
            </div>
            <h4 class="text-xs font-black text-[#0F172A] tracking-tight uppercase">Contacts Importants</h4>
            <span class="text-[10px] text-slate-500 font-bold mt-1">Contacts</span>
          </div>

          <!-- Card 3: Headquarters -->
          <div (click)="openDoc('Plan des Locaux')" class="bg-white border-2 border-slate-100 hover:border-[#D4AF37]/35 rounded-3xl p-6 shadow-sm hover:shadow-md transition-all duration-300 flex flex-col items-center text-center cursor-pointer select-none hover:scale-[1.02]">
            <div class="w-12 h-12 rounded-2xl bg-[#FAF6F0] flex items-center justify-center text-[#8C7355] mb-4 border border-[#D4AF37]/30">
              <span class="material-icons-round text-2xl">map</span>
            </div>
            <h4 class="text-xs font-black text-[#0F172A] tracking-tight uppercase">Plan des Locaux</h4>
            <span class="text-[10px] text-slate-500 font-bold mt-1">Headquarters</span>
          </div>

        </div>

      </div>

      <!-- MODAL POPUP FOR ALL MODULES (Voir Plus) -->
      @if (showAllModulesModal()) {
        <div class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-50 flex items-center justify-center p-4 animate-fade-in">
          <div class="bg-white rounded-[32px] max-w-4xl w-full p-6 shadow-2xl border-[3px] border-[#D4AF37] relative animate-scale-up">
            
            <!-- Close button -->
            <button (click)="showAllModulesModal.set(false)" class="absolute top-4 right-4 text-slate-400 hover:text-[#0f172a] transition cursor-pointer flex items-center justify-center w-8 h-8 rounded-full bg-slate-100">
              <span class="material-icons-round">close</span>
            </button>

            <!-- Modal Header -->
            <div class="mb-6 border-b border-slate-100 pb-3 pr-8 text-center sm:text-left">
              <h3 class="text-xl font-black text-[#0F172A] font-display">Mon Parcours d'Intégration Complet</h3>
              <p class="text-xs text-slate-400 font-bold mt-0.5">Tous les modules d'intégration prévus pour votre parcours</p>
            </div>

            <!-- Modules Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 max-h-[400px] overflow-y-auto p-1">
              @for (mod of modules(); track mod.id) {
                <div 
                  (click)="onModuleClick(mod); showAllModulesModal.set(false)"
                  [class.border-emerald-200]="mod.status === 'completed'"
                  [class.bg-emerald-50/20]="mod.status === 'completed'"
                  [class.border-primary-blue]="mod.status === 'current'"
                  [class.bg-white]="mod.status === 'current'"
                  [class.shadow-[0_0_20px_rgba(21,101,192,0.12)]]="mod.status === 'current'"
                  [class.opacity-55]="mod.status === 'locked'"
                  [class.bg-slate-50]="mod.status === 'locked'"
                  [class.border-slate-100]="mod.status === 'locked'"
                  [class.cursor-pointer]="mod.status !== 'locked'"
                  [class.hover:scale-[1.03]]="mod.status !== 'locked'"
                  class="border-2 rounded-2xl p-4 flex flex-col gap-3 transition-all duration-300 shadow-sm min-h-[140px] relative select-none w-full"
                >
                  <!-- Pulse Indicator for Active -->
                  @if (mod.status === 'current') {
                    <span class="absolute -top-1.5 -right-1.5 flex h-3.5 w-3.5">
                      <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-primary-blue opacity-75"></span>
                      <span class="relative inline-flex rounded-full h-3.5 w-3.5 bg-primary-blue"></span>
                    </span>
                  }

                  <!-- Status Icon/Sub -->
                  <div class="flex items-center justify-between">
                    <span 
                      [class.text-emerald-600]="mod.status === 'completed'"
                      [class.text-primary-blue]="mod.status === 'current'"
                      [class.text-slate-400]="mod.status === 'locked'"
                      class="text-[10px] font-black uppercase tracking-wider"
                    >
                      {{ mod.subtitleKey }}
                    </span>

                    <span class="material-icons-round text-sm"
                          [class.text-emerald-500]="mod.status === 'completed'"
                          [class.text-primary-blue]="mod.status === 'current'"
                          [class.text-slate-400]="mod.status === 'locked'">
                      {{ mod.status === 'completed' ? 'check_circle' : mod.status === 'current' ? 'bolt' : 'lock' }}
                    </span>
                  </div>

                  <!-- Title -->
                  <h4 class="text-slate-800 font-extrabold text-sm leading-snug font-display">
                    {{ mod.titleKey }}
                  </h4>

                  <!-- Items list (lessons) -->
                  <div class="flex flex-col gap-1.5 border-t border-slate-100 pt-2.5">
                    @for (item of mod.items; track item.labelKey) {
                      <div class="flex items-center gap-1.5 text-slate-500 text-[10px] font-semibold truncate">
                        <span class="material-icons-round text-slate-400 text-xs">{{ item.icon }}</span>
                        <span>{{ item.labelKey }}</span>
                      </div>
                    }
                  </div>
                </div>
              }
            </div>

            <!-- Footer Buttons -->
            <div class="mt-6 flex items-center justify-end border-t border-slate-100 pt-4">
              <button (click)="showAllModulesModal.set(false)" class="px-5 py-2.5 rounded-full bg-[#0F172A] hover:bg-[#D4AF37] hover:text-[#0F172A] text-white text-xs font-extrabold cursor-pointer transition-colors shadow-md select-none">
                Fermer
              </button>
            </div>

          </div>
        </div>
      }

    </div>

    <!-- Reusable Module Card Template -->
    <ng-template #moduleCard let-mod>
      <div 
        (click)="onModuleClick(mod)"
        [class.border-emerald-200]="mod.status === 'completed'"
        [class.bg-emerald-50/20]="mod.status === 'completed'"
        [class.border-primary-blue]="mod.status === 'current'"
        [class.bg-white]="mod.status === 'current'"
        [class.shadow-[0_0_20px_rgba(21,101,192,0.12)]]="mod.status === 'current'"
        [class.opacity-55]="mod.status === 'locked'"
        [class.bg-slate-50]="mod.status === 'locked'"
        [class.border-slate-100]="mod.status === 'locked'"
        [class.cursor-pointer]="mod.status !== 'locked'"
        [class.hover:scale-[1.03]]="mod.status !== 'locked'"
        class="border-2 rounded-2xl p-4 flex flex-col gap-3 transition-all duration-300 shadow-sm min-h-[140px] relative select-none w-full"
      >
        <!-- Pulse Indicator for Active -->
        @if (mod.status === 'current') {
          <span class="absolute -top-1.5 -right-1.5 flex h-3.5 w-3.5">
            <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-primary-blue opacity-75"></span>
            <span class="relative inline-flex rounded-full h-3.5 w-3.5 bg-primary-blue"></span>
          </span>
        }

        <!-- Status Icon/Sub -->
        <div class="flex items-center justify-between">
          <span 
            [class.text-emerald-600]="mod.status === 'completed'"
            [class.text-primary-blue]="mod.status === 'current'"
            [class.text-slate-400]="mod.status === 'locked'"
            class="text-[10px] font-black uppercase tracking-wider"
          >
            {{ mod.subtitleKey }}
          </span>

          <span class="material-icons-round text-sm"
                [class.text-emerald-500]="mod.status === 'completed'"
                [class.text-primary-blue]="mod.status === 'current'"
                [class.text-slate-400]="mod.status === 'locked'">
            {{ mod.status === 'completed' ? 'check_circle' : mod.status === 'current' ? 'bolt' : 'lock' }}
          </span>
        </div>

        <!-- Title -->
        <h4 class="text-slate-800 font-extrabold text-sm leading-snug font-display">
          {{ mod.titleKey }}
        </h4>

        <!-- Items list (lessons) -->
        <div class="flex flex-col gap-1.5 border-t border-slate-100 pt-2.5">
          @for (item of mod.items; track item.labelKey) {
            <div class="flex items-center gap-1.5 text-slate-500 text-[10px] font-semibold truncate">
              <span class="material-icons-round text-slate-400 text-xs">{{ item.icon }}</span>
              <span>{{ item.labelKey }}</span>
            </div>
          }
        </div>
      </div>
    </ng-template>
  `,
  styles: [`
    :host {
      display: block;
    }
  `]
})
export class RoadmapComponent {
  private onboardingService = inject(OnboardingService);
  private router = inject(Router);

  readonly selectedSector = this.onboardingService.selectedSector;
  readonly modules = this.onboardingService.modules;
  readonly globalProgressPercentage = this.onboardingService.globalProgressPercentage;
  readonly showAllModulesModal = signal<boolean>(false);

  onModuleClick(module: OnboardingModule) {
    if (module.status === 'locked') return;
    this.onboardingService.selectedModule.set(module);
    this.router.navigate(['/module-intro']);
  }

  openDoc(name: string) {
    alert(`Ouverture du document : ${name}`);
  }
}
