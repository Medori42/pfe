import { Component, inject, computed, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { OnboardingService, OnboardingModule } from '../onboarding.service';

@Component({
  selector: 'app-module-intro',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="min-h-[calc(100vh-140px)] max-w-6xl mx-auto px-4 py-8 flex flex-col gap-8 animate-fade-in">
      
      <!-- Back button and Navigation Context -->
      <div class="flex items-center justify-between border-b border-slate-200/60 pb-4">
        <button routerLink="/roadmap" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-black transition-all cursor-pointer select-none">
          <span class="material-icons-round text-sm">arrow_back</span>
          Retour au Parcours
        </button>
        <span class="text-xs text-slate-400 font-extrabold uppercase tracking-wider">
          Espace Apprenant • {{ activeModule().subtitleKey }}
        </span>
      </div>

      <!-- Main Layout Grid -->
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
        
        <!-- ================= LEFT COLUMN (L'Éducation & Leçons) ================= -->
        <div class="lg:col-span-7 flex flex-col gap-6">
          
          <!-- Interactive Video Player Card -->
          <div class="bg-white rounded-3xl p-6 shadow-xl border border-slate-100 relative overflow-hidden group">
            <div class="absolute top-0 left-0 w-2 h-full bg-[#D4AF37]"></div>
            
            <h3 class="text-slate-800 font-black text-lg mb-4 pl-2 font-display">
              {{ activeModule().titleKey }} — Présentation Générale
            </h3>
            
            <!-- Real HTML5 Video Player -->
            <div class="relative w-full aspect-video rounded-2xl bg-black border border-slate-800 shadow-inner overflow-hidden flex items-center justify-center group/player">
              <video 
                #moduleVideo
                class="w-full h-full object-cover"
                [src]="videoUrl()"
                [poster]="posterUrl()"
                [controls]="isVideoPlaying()"
                (play)="onVideoPlay()"
                (pause)="onVideoPause()"
                (timeupdate)="onTimeUpdate($event)"
              ></video>
              
              <!-- Custom Play Overlay when video is not playing -->
              @if (!isVideoPlaying()) {
                <div class="absolute inset-0 bg-slate-900/40 backdrop-blur-[2px] flex items-center justify-center z-10 transition-opacity duration-300">
                  <!-- Centered Play Action -->
                  <div (click)="playVideo(moduleVideo)" class="w-16 h-16 rounded-full bg-[#D4AF37]/90 text-slate-950 hover:bg-[#D4AF37] hover:scale-110 flex items-center justify-center shadow-lg transition-all cursor-pointer">
                    <span class="material-icons-round text-3xl pl-1">play_arrow</span>
                  </div>
                </div>
              }

              <!-- Overlay info text inside video -->
              <div class="absolute bottom-4 left-4 right-4 flex items-center justify-between text-white/80 text-[10px] font-bold z-10 pointer-events-none" *ngIf="!isVideoPlaying()">
                <span class="flex items-center gap-1">
                  <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
                  Présentation du module
                </span>
                <span>Visionné : {{ videoProgress() }}%</span>
              </div>
            </div>

            <!-- Player Progress Bar -->
            <div class="mt-4">
              <div class="flex items-center justify-between text-[10px] text-slate-400 font-extrabold mb-1">
                <span>Lecture de la présentation</span>
                <span>{{ videoProgress() }}%</span>
              </div>
              <div class="w-full bg-slate-100 h-2 rounded-full overflow-hidden">
                <div class="bg-gradient-to-r from-[#D4AF37] to-amber-300 h-full rounded-full transition-all duration-300" [style.width.%]="videoProgress()"></div>
              </div>
            </div>
          </div>

          <!-- Module Progress Statistics Card -->
          <div class="bg-white rounded-3xl p-6 shadow-xl border border-slate-100 relative">
            <h4 class="text-xs text-slate-400 font-black uppercase tracking-wider mb-3">Progression du Module</h4>
            <div class="flex items-center justify-between mb-2">
              <span class="text-slate-800 font-extrabold text-sm">2/3 Leçons Complétées</span>
              <span class="text-[#D4AF37] font-black text-sm">66%</span>
            </div>
            <div class="w-full bg-slate-100 h-3 rounded-full overflow-hidden">
              <div class="bg-gradient-to-r from-emerald-400 to-emerald-600 h-full rounded-full w-[66%] transition-all duration-300"></div>
            </div>
          </div>

          <!-- Lessons List Card -->
          <div class="bg-white rounded-3xl p-6 shadow-xl border border-slate-100">
            <div class="flex items-center justify-between mb-6 pb-2 border-b border-slate-100">
              <h3 class="text-slate-800 font-black text-base font-display">Contenu du Module</h3>
              <span class="bg-slate-100 text-slate-600 px-3 py-1 rounded-full text-[10px] font-bold">3 Leçons</span>
            </div>

            <div class="flex flex-col gap-4">
              @for (item of activeModule().items; track item.labelKey; let idx = $index) {
                <div 
                  (click)="startLessons()" 
                  [class.border-emerald-200]="idx === 0 && activeModule().status === 'completed'"
                  [class.bg-emerald-50/20]="idx === 0 && activeModule().status === 'completed'"
                  [class.border-[#D4AF37]]="idx === 1 && activeModule().status === 'current'"
                  [class.bg-[#FAF6F0]]="idx === 1 && activeModule().status === 'current'"
                  [class.opacity-60]="activeModule().status === 'locked' || (idx > 1 && activeModule().status === 'current')"
                  [class.bg-slate-50]="activeModule().status === 'locked' || (idx > 1 && activeModule().status === 'current')"
                  [class.border-slate-100]="activeModule().status === 'locked' || (idx > 1 && activeModule().status === 'current')"
                  [class.cursor-not-allowed]="activeModule().status === 'locked' || (idx > 1 && activeModule().status === 'current')"
                  [class.cursor-pointer]="activeModule().status !== 'locked' && !(idx > 1 && activeModule().status === 'current')"
                  class="group border-2 rounded-2xl p-4 flex items-center justify-between transition-all duration-300 hover:scale-[1.01] hover:-translate-y-0.5 hover:shadow-md hover:border-[#D4AF37]/50 select-none w-full"
                >
                  <div class="flex items-center gap-4">
                    <!-- Lesson Number Icon -->
                    <div 
                      [class.bg-emerald-100]="idx === 0 && activeModule().status === 'completed'"
                      [class.text-emerald-700]="idx === 0 && activeModule().status === 'completed'"
                      [class.bg-[#D4AF37]/20]="idx === 1 && activeModule().status === 'current'"
                      [class.text-[#8C7355]]="idx === 1 && activeModule().status === 'current'"
                      [class.bg-slate-100]="activeModule().status === 'locked' || (idx > 1 && activeModule().status === 'current')"
                      [class.text-slate-400]="activeModule().status === 'locked' || (idx > 1 && activeModule().status === 'current')"
                      class="w-9 h-9 rounded-xl flex items-center justify-center font-black text-xs transition-colors"
                    >
                      {{ idx + 1 }}
                    </div>

                    <div>
                      <h4 class="text-xs font-black text-slate-800 tracking-tight">{{ item.labelKey }}</h4>
                      <span class="text-[9px] text-slate-400 font-bold uppercase tracking-wider">
                        {{ idx === 0 && activeModule().status === 'completed' ? 'Complété' : (idx === 1 && activeModule().status === 'current' ? 'Leçon active' : 'À venir') }}
                      </span>
                    </div>
                  </div>

                  <!-- Right Action State / Chevron -->
                  <div class="flex items-center gap-2">
                    @if (idx === 0 && activeModule().status === 'completed') {
                      <span class="px-2 py-0.5 rounded-md bg-emerald-100 text-emerald-800 text-[8px] font-black uppercase">Terminé</span>
                      <span class="material-icons-round text-emerald-500 text-sm">check_circle</span>
                    } @else if (idx === 1 && activeModule().status === 'current') {
                      <span class="px-2 py-0.5 rounded-md bg-amber-100 text-amber-800 text-[8px] font-black uppercase">Actif</span>
                      <span class="material-icons-round text-[#D4AF37] text-sm animate-pulse">play_circle</span>
                    } @else {
                      <span class="material-icons-round text-slate-400 text-sm">lock</span>
                    }
                    <!-- Smooth chevron slide-in on hover for active items -->
                    <span 
                      *ngIf="activeModule().status !== 'locked' && !(idx > 1 && activeModule().status === 'current')" 
                      class="material-icons-round text-[#D4AF37] text-sm opacity-0 group-hover:opacity-100 group-hover:translate-x-1 transition-all duration-300"
                    >
                      chevron_right
                    </span>
                  </div>
                </div>
              }

            </div>
          </div>

        </div>

        <!-- ================= RIGHT COLUMN (Pièces Jointes & Contacts) ================= -->
        <div class="lg:col-span-5 flex flex-col gap-6">
          
          <!-- Attachments Card -->
          <div class="bg-white rounded-3xl p-6 shadow-xl border border-slate-100">
            <h3 class="text-slate-800 font-black text-base mb-4 font-display">Documents Utiles</h3>
            <div class="grid grid-cols-2 gap-4">
              
              <!-- Doc 1 -->
              <div (click)="openDoc('Guide Sécurité')" class="p-4 bg-[#FAF6F0] rounded-2xl border border-[#D4AF37]/35 flex flex-col items-center text-center cursor-pointer hover:scale-[1.02] transition-transform select-none">
                <span class="material-icons-round text-[#8C7355] text-3xl mb-2">description</span>
                <span class="text-[10px] font-black text-[#0f172a] uppercase leading-tight">Guide Sécurité</span>
                <span class="text-[9px] text-slate-400 font-semibold mt-1">PDF • 5.2 Mo</span>
              </div>

              <!-- Doc 2 -->
              <div (click)="openDoc('Contacts d Urgence')" class="p-4 bg-[#FAF6F0] rounded-2xl border border-[#D4AF37]/35 flex flex-col items-center text-center cursor-pointer hover:scale-[1.02] transition-transform select-none">
                <span class="material-icons-round text-[#8C7355] text-3xl mb-2">contacts</span>
                <span class="text-[10px] font-black text-[#0f172a] uppercase leading-tight">Liste d'Urgence</span>
                <span class="text-[9px] text-slate-400 font-semibold mt-1">Numéros utiles</span>
              </div>

            </div>
          </div>

          <!-- Contacts (Adapted) Card -->
          <div class="bg-white rounded-3xl p-6 shadow-xl border border-slate-100">
            <h3 class="text-slate-800 font-black text-base mb-4 font-display">Interlocuteurs HSE & RH</h3>
            
            <div class="flex flex-col gap-4">
              
              <!-- Contact 1 -->
              <div class="flex items-center justify-between">
                <div class="flex items-center gap-3">
                  <img src="https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=120" alt="HSE Director" class="w-10 h-10 rounded-full object-cover">
                  <div>
                    <h4 class="text-xs font-black text-slate-800">Sarah KABBAJ</h4>
                    <span class="text-[9px] text-slate-400 font-bold uppercase">Directrice HSE</span>
                  </div>
                </div>
                <button (click)="contactPerson('Sarah KABBAGE')" class="px-3 py-1.5 rounded-full bg-slate-100 hover:bg-[#D4AF37]/20 hover:text-[#8C7355] text-slate-700 text-[10px] font-extrabold cursor-pointer transition-colors select-none">
                  Contacter
                </button>
              </div>

              <!-- Contact 2 -->
              <div class="flex items-center justify-between">
                <div class="flex items-center gap-3">
                  <img src="https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&q=80&w=120" alt="HR Manager" class="w-10 h-10 rounded-full object-cover">
                  <div>
                    <h4 class="text-xs font-black text-slate-800">Karim BENJELLOUN</h4>
                    <span class="text-[9px] text-slate-400 font-bold uppercase">Chargé d'intégration RH</span>
                  </div>
                </div>
                <button (click)="contactPerson('Karim BENJELLOUN')" class="px-3 py-1.5 rounded-full bg-slate-100 hover:bg-[#D4AF37]/20 hover:text-[#8C7355] text-slate-700 text-[10px] font-extrabold cursor-pointer transition-colors select-none">
                  Contacter
                </button>
              </div>

            </div>
          </div>

          <!-- Quiz Access Card (Styled like Chatbot Card) -->
          <div class="p-5 bg-gradient-to-r from-[#1E3A8A] to-[#0F172A] rounded-3xl text-white shadow-xl relative overflow-hidden group">
            <div class="absolute inset-0 bg-radial-gradient from-white/10 to-transparent pointer-events-none"></div>
            
            <div class="flex items-center gap-3 mb-3">
              <div class="w-8 h-8 rounded-full bg-white/10 flex items-center justify-center text-amber-300">
                <span class="material-icons-round text-sm">psychology</span>
              </div>
              <h4 class="text-xs font-black font-display uppercase tracking-wider">Quiz d'Évaluation (Quiz Thaki)</h4>
            </div>
            
            <p class="text-[10px] text-slate-300 font-semibold mb-4 leading-normal">
              Prêt à évaluer vos connaissances ? Lancez le quiz d'évaluation généré par l'IA de WelcomeWise pour ce module.
            </p>

            <button routerLink="/quiz" class="w-full py-2.5 bg-white hover:bg-amber-300 text-slate-900 font-black text-xs rounded-xl shadow-md transition-colors cursor-pointer select-none uppercase tracking-wider">
              Tester mes connaissances
            </button>
          </div>

          <!-- IA Chatbot Access Card -->
          <div class="p-5 bg-gradient-to-r from-[#1E3A8A] to-[#0F172A] rounded-3xl text-white shadow-xl relative overflow-hidden group">
            <div class="absolute inset-0 bg-radial-gradient from-white/10 to-transparent pointer-events-none"></div>
            
            <div class="flex items-center gap-3 mb-3">
              <div class="w-8 h-8 rounded-full bg-white/10 flex items-center justify-center text-amber-300">
                <span class="material-icons-round text-sm">chat_bubble</span>
              </div>
              <h4 class="text-xs font-black font-display uppercase tracking-wider">Assistant IA WelcomeWise</h4>
            </div>
            
            <p class="text-[10px] text-slate-300 font-semibold mb-4 leading-normal">
              Besoin d'éclaircissements ? Notre chatbot intelligent peut répondre instantanément à vos questions sur le module.
            </p>

            <button routerLink="/chatbot" class="w-full py-2.5 bg-white hover:bg-amber-300 text-slate-900 font-black text-xs rounded-xl shadow-md transition-colors cursor-pointer select-none uppercase tracking-wider">
              Discuter avec l'IA
            </button>
          </div>

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
export class ModuleIntroComponent {
  private onboardingService = inject(OnboardingService);
  private router = inject(Router);

  // Video Player state management
  readonly isVideoPlaying = signal<boolean>(false);
  readonly videoUrl = signal<string>('https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4');
  readonly posterUrl = signal<string>('https://images.unsplash.com/photo-1541888946425-d81bb19240f5?auto=format&fit=crop&q=80&w=600');
  readonly videoProgress = signal<number>(0);

  // Fallback to Module 2 if selectedModule is null
  readonly activeModule = computed(() => {
    return this.onboardingService.selectedModule() || this.onboardingService.modules()[1];
  });

  playVideo(videoEl: HTMLVideoElement) {
    videoEl.play();
    this.isVideoPlaying.set(true);
  }

  onVideoPlay() {
    this.isVideoPlaying.set(true);
  }

  onVideoPause() {
    this.isVideoPlaying.set(false);
  }

  onTimeUpdate(event: any) {
    const video = event.target as HTMLVideoElement;
    if (video.duration) {
      const pct = Math.round((video.currentTime / video.duration) * 100);
      this.videoProgress.set(pct);
    }
  }

  startLessons() {
    this.router.navigate(['/lesson']);
  }

  openManual() {
    alert(`Ouverture du manuel de formation pour le module : ${this.activeModule().titleKey}`);
  }

  listenAudio() {
    alert(`Démarrage de l'audio-guide pour : ${this.activeModule().titleKey}`);
  }

  openDoc(docName: string) {
    alert(`Téléchargement de la pièce jointe : ${docName}`);
  }

  contactPerson(name: string) {
    alert(`Ouverture de la messagerie instantanée avec ${name}`);
  }

  sendHRQuestion() {
    alert('Votre question a bien été transmise à l\'équipe RH de Ménara Holding !');
  }
}
