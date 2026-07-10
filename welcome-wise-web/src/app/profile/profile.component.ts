import { Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { OnboardingService, Badge } from '../onboarding.service';

@Component({
  selector: 'app-profile',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="min-h-[calc(100vh-140px)] max-w-5xl mx-auto px-4 py-8 flex flex-col items-center justify-center">
      
      <div class="w-full bg-white/95 backdrop-blur-md rounded-[32px] shadow-2xl border border-white/50 overflow-hidden animate-fade-in p-8 lg:p-10 flex flex-col relative">
        
        <!-- Profile Header -->
        <h3 class="text-slate-800 font-black text-2xl text-center mb-8 font-display">Mon Profil Personnel</h3>

        <!-- Main Desktop Split (Grid) -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
          
          <!-- LEFT SIDE: Info & Progress (5 cols) -->
          <div class="lg:col-span-5 flex flex-col">
            <!-- Employee Info Card -->
            <div class="flex items-center gap-5 mb-8 bg-[#FAF6F0]/60 p-5 rounded-3xl border border-[#D4AF37]/15">
              <div class="relative">
                <div class="w-24 h-24 rounded-full border-4 border-white shadow-xl overflow-hidden">
                  <img 
                    src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=120" 
                    alt="Meryem Fathi" 
                    class="w-full h-full object-cover"
                  />
                </div>
                <!-- Verified Icon -->
                <div class="absolute bottom-0 right-0 bg-primary-blue text-white w-6 h-6 rounded-full flex items-center justify-center border-2 border-white shadow-md">
                  <span class="material-icons-round text-xs font-bold">verified</span>
                </div>
              </div>
              
              <div>
                <h4 class="text-slate-800 font-extrabold text-xl tracking-tight leading-none mb-1.5 font-display">
                  {{ user().firstName }} {{ user().lastName }}
                </h4>
                <p class="text-slate-500 font-semibold text-xs mb-1 uppercase tracking-wider">{{ user().role }}</p>
                <span class="bg-slate-100 border border-slate-200/50 rounded-full px-3 py-0.5 text-[10px] font-bold text-slate-400">
                  {{ user().department }}
                </span>
              </div>
            </div>

            <!-- Global Progress Section -->
            <div class="bg-slate-50/50 border border-slate-100 rounded-3xl p-6 mb-6">
              <div class="flex items-center justify-between text-xs font-bold text-slate-600 mb-2.5">
                <span>PROGRESSION GLOBALE DE L'ONBOARDING</span>
                <span class="text-primary-blue font-black text-sm font-display">{{ progress() }}%</span>
              </div>
              
              <!-- Progress Bar -->
              <div class="w-full bg-slate-100 h-2.5 rounded-full overflow-hidden mb-4">
                <div 
                  class="bg-gradient-to-r from-gold to-gold-light h-full rounded-full transition-all duration-500" 
                  [style.width.%]="progress()"
                ></div>
              </div>

              <!-- Badges Count -->
              <div class="inline-flex items-center gap-1.5 bg-amber-50 border border-amber-200/60 rounded-full px-3 py-1 text-amber-800 font-extrabold text-xs">
                <span class="material-icons-round text-sm">workspace_premium</span>
                <span>Badges Obtenus : {{ unlockedCount() }} / {{ badges().length }}</span>
              </div>
            </div>

            <!-- Share Button (StadiumBorder) -->
            <button 
              (click)="shareRewards()" 
              class="w-full rounded-full py-4.5 bg-gradient-to-r from-primary-blue-dark to-primary-blue text-white font-extrabold text-xs tracking-wider uppercase shadow-xl shadow-primary-blue-dark/20 hover:shadow-2xl hover:shadow-primary-blue-dark/35 hover:-translate-y-0.5 transition-all duration-200 active:translate-y-0 active:scale-99 flex items-center justify-center gap-2 cursor-pointer"
            >
              <span class="material-icons-round text-base">share</span>
              <span>Partager Mes Récompenses</span>
            </button>

            <!-- Course Notes Button Under the Share Button -->
            <button 
              (click)="openNotesModal()" 
              class="w-full mt-4 rounded-full py-4 bg-white border-2 border-[#D4AF37]/50 text-[#8C7355] font-extrabold text-xs tracking-wider uppercase shadow-md hover:bg-[#FAF6F0] hover:border-[#D4AF37] hover:shadow-lg hover:-translate-y-0.5 transition-all duration-200 active:translate-y-0 active:scale-99 flex items-center justify-center gap-2 cursor-pointer"
            >
              <span class="material-icons-round text-base text-amber-600">sticky_note_2</span>
              <span>Mes Notes de Cours</span>
            </button>
          </div>

          <!-- RIGHT SIDE: Badges Grid (7 cols) -->
          <div class="lg:col-span-7">
            <h5 class="text-slate-800 font-black text-sm tracking-tight mb-4 uppercase">Badges & Récompenses</h5>
            
            <div class="grid grid-cols-2 gap-4">
              @for (badge of badges(); track badge.title) {
                <div 
                  [class.border-slate-100]="badge.isLocked"
                  [class.bg-white]="!badge.isLocked"
                  [class.border-gold]="!badge.isLocked && badge.isGold"
                  [class.border-blue-200]="!badge.isLocked && !badge.isGold"
                  [class.shadow-md]="!badge.isLocked"
                  [class.hover:-translate-y-1]="!badge.isLocked"
                  [class.hover:shadow-lg]="!badge.isLocked"
                  [class.hover:shadow-gold/15]="!badge.isLocked && badge.isGold"
                  [class.hover:shadow-primary-blue/15]="!badge.isLocked && !badge.isGold"
                  class="border border-slate-100 rounded-3xl p-4 flex flex-col items-center justify-center transition-all duration-300 text-center relative group min-h-[148px]"
                >
                  <!-- Shield Icon Circle -->
                  <div 
                    [class.border-slate-200]="badge.isLocked"
                    [class.bg-slate-50]="badge.isLocked"
                    [class.border-gold]="!badge.isLocked && badge.isGold"
                    [class.bg-amber-50]="!badge.isLocked && badge.isGold"
                    [class.border-primary-blue]="!badge.isLocked && !badge.isGold"
                    [class.bg-blue-50]="!badge.isLocked && !badge.isGold"
                    class="w-12 h-12 rounded-full border-2 flex items-center justify-center shadow-sm mb-3"
                  >
                    <span class="material-icons-round text-xl"
                          [class.text-slate-400]="badge.isLocked"
                          [class.text-amber-600]="!badge.isLocked && badge.isGold"
                          [class.text-primary-blue]="!badge.isLocked && !badge.isGold">
                      {{ badge.isLocked ? 'lock' : badge.icon }}
                    </span>
                  </div>

                  <!-- Title & Subtitle -->
                  <span class="text-slate-800 font-extrabold text-xs tracking-tight mb-1 truncate w-full px-2 font-display">
                    {{ badge.title }}
                  </span>
                  <span class="text-slate-400 font-medium text-[10px] truncate w-full px-2">
                    {{ badge.subtitle }}
                  </span>

                  <!-- Corner lock/check icon -->
                  <div class="absolute top-3 right-3 opacity-55">
                    <span class="material-icons-round text-sm" 
                          [class.text-slate-300]="badge.isLocked" 
                          [class.text-amber-500]="!badge.isLocked && badge.isGold"
                          [class.text-primary-blue]="!badge.isLocked && !badge.isGold">
                      {{ badge.isLocked ? 'lock' : 'check_circle' }}
                    </span>
                  </div>
                </div>
              }
            </div>
          </div>

        </div>

      </div>
    </div>

    <!-- Modal Popup for Notes -->
    <div *ngIf="showNotesModal()" class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-[100] flex items-center justify-center p-4">
      <div class="bg-white rounded-[32px] w-full max-w-lg p-6 shadow-2xl border border-white/50 relative animate-fade-in">
        <button (click)="showNotesModal.set(false)" class="absolute top-5 right-5 w-8 h-8 rounded-full bg-slate-100 flex items-center justify-center text-slate-500 hover:bg-slate-200 transition-colors cursor-pointer border-0">
          <span class="material-icons-round text-base">close</span>
        </button>
        
        <div class="flex items-center gap-2.5 mb-4 border-b border-slate-100 pb-3">
          <span class="material-icons-round text-xl text-amber-500">sticky_note_2</span>
          <h4 class="text-slate-800 font-extrabold text-lg font-display">Mes Notes de Formation</h4>
        </div>
        
        <p class="text-slate-500 font-semibold text-xs mb-3">Voici les notes que vous avez prises lors de vos leçons :</p>
        
        <textarea 
          [(ngModel)]="tempNotes"
          placeholder="Vous n'avez pas encore rédigé de notes..." 
          class="w-full min-h-[160px] bg-slate-50 border border-slate-100 rounded-2xl p-4 text-xs font-semibold focus:outline-none focus:border-primary-blue focus:ring-4 focus:ring-primary-blue/5 transition-all leading-relaxed"
        ></textarea>
        
        <div class="flex items-center gap-3 mt-5">
          <button 
            (click)="showNotesModal.set(false)" 
            class="flex-1 rounded-full py-3 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs uppercase cursor-pointer border-0 transition-colors"
          >
            Fermer
          </button>
          <button 
            (click)="saveNotesFromProfile()" 
            class="flex-1 rounded-full py-3 bg-primary-blue hover:bg-primary-blue-dark text-white font-extrabold text-xs uppercase cursor-pointer border-0 transition-colors shadow-md"
          >
            Enregistrer
          </button>
        </div>
      </div>
    </div>
  `,
  styles: [`
    :host {
      display: block;
    }
  `]
})
export class ProfileComponent {
  private onboardingService = inject(OnboardingService);

  readonly user = this.onboardingService.user;
  readonly progress = this.onboardingService.globalProgressPercentage;
  readonly unlockedCount = this.onboardingService.unlockedBadgesCount;
  readonly badges = this.onboardingService.badges;

  showNotesModal = signal<boolean>(false);
  tempNotes = '';

  openNotesModal() {
    this.tempNotes = this.onboardingService.savedNotes();
    this.showNotesModal.set(true);
  }

  saveNotesFromProfile() {
    this.onboardingService.savedNotes.set(this.tempNotes);
    this.showNotesModal.set(false);
    this.onboardingService.addChatMessage('ai', 'Meryem, tes notes de formation ont bien été mises à jour depuis ton profil !');
    alert("📝 Vos notes de cours ont été enregistrées avec succès !");
  }

  shareRewards() {
    this.onboardingService.addChatMessage('ai', 'Meryem, c\'est fantastique de partager tes réalisations ! Tes collègues de Ménara Holding seront ravis de voir ta progression.');
    alert("🏆 Vos récompenses d'onboarding ont été partagées sur le fil d'actualité interne de Ménara Holding !");
  }
}
