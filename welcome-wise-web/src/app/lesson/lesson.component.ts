import { Component, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { OnboardingService } from '../onboarding.service';

@Component({
  selector: 'app-lesson',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="min-h-[calc(100vh-140px)] max-w-6xl mx-auto px-4 py-8">
      
      <!-- Breadcrumbs / Header -->
      <div class="flex items-center gap-3 mb-6">
        <button (click)="goBack()" class="w-9 h-9 rounded-full bg-white border border-slate-100 flex items-center justify-center text-slate-800 hover:bg-slate-50 transition-colors shadow-sm cursor-pointer">
          <span class="material-icons-round text-base">arrow_back</span>
        </button>
        <div>
          <span class="text-slate-400 font-bold text-[10px] uppercase tracking-wider">Module 2 • Leçon 2.3</span>
          <h2 class="text-slate-800 font-extrabold text-lg font-display leading-none mt-0.5">Équipements de Protection Individuelle (EPI)</h2>
        </div>
      </div>

      <!-- Layout Grid -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        <!-- Left Column: Video player & Notes/Documents (65% width) -->
        <div class="lg:col-span-2 flex flex-col gap-6">
          
          <!-- Video Player Widget -->
          <div class="bg-black rounded-3xl overflow-hidden aspect-video shadow-2xl relative group border border-slate-900">
            <!-- Simulated Video Frame (Image) -->
            <img 
              src="https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&q=80&w=800" 
              alt="HSE Video Training" 
              class="w-full h-full object-cover opacity-60"
            />

            <!-- Play Overlay (Centered) -->
            <div class="absolute inset-0 flex items-center justify-center z-10">
              <button 
                (click)="togglePlay()" 
                class="w-20 h-20 rounded-full bg-primary-blue/95 border-2 border-white text-white flex items-center justify-center shadow-2xl hover:scale-110 active:scale-95 transition-all duration-300 cursor-pointer"
              >
                <span class="material-icons-round text-4xl ml-1">{{ isPlaying() ? 'pause' : 'play_arrow' }}</span>
              </button>
            </div>

            <!-- Custom Controls Overlay (Bottom) -->
            <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/90 via-black/40 to-transparent p-6 flex flex-col gap-3 opacity-90 group-hover:opacity-100 transition-opacity">
              <!-- Video Progress Bar -->
              <div class="flex items-center gap-3">
                <span class="text-white text-xs font-bold font-display">09:12</span>
                <div class="flex-1 bg-white/20 h-1.5 rounded-full overflow-hidden relative cursor-pointer">
                  <div class="bg-primary-blue h-full rounded-full w-[60%]"></div>
                  <!-- Handle -->
                  <div class="absolute w-3 h-3 rounded-full bg-white shadow top-1/2 -translate-y-1/2 left-[60%]"></div>
                </div>
                <span class="text-white/60 text-xs font-bold font-display">15:00</span>
              </div>

              <!-- Controls Row -->
              <div class="flex items-center justify-between">
                <div class="flex items-center gap-4 text-white">
                  <button (click)="togglePlay()" class="hover:text-primary-blue transition-colors focus:outline-none cursor-pointer">
                    <span class="material-icons-round text-xl">{{ isPlaying() ? 'pause' : 'play_arrow' }}</span>
                  </button>
                  <button class="hover:text-primary-blue transition-colors focus:outline-none cursor-pointer">
                    <span class="material-icons-round text-xl">volume_up</span>
                  </button>
                </div>
                
                <span class="text-white/80 text-xs font-bold tracking-wide uppercase">Sécurité et Règlements de Base</span>
              </div>
            </div>
          </div>

          <!-- Bottom Grid for Notes, Resources & Photo Set (3 columns on larger viewports) -->
          <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <!-- Note Pad Card -->
            <div class="bg-white rounded-3xl border border-slate-100 p-5 shadow-xl flex flex-col gap-4 h-full">
              <div class="flex items-center justify-between border-b border-slate-100 pb-3">
                <h4 class="text-slate-800 font-extrabold text-xs tracking-tight flex items-center gap-2">
                  <span class="material-icons-round text-amber-500 text-base">edit_note</span>
                  Mon Bloc-Notes
                </h4>
                @if (notesSaved()) {
                  <span class="text-[9px] text-emerald-500 font-bold uppercase tracking-wider flex items-center gap-0.5">
                    <span class="material-icons-round text-[10px]">done</span> Sauvé
                  </span>
                }
              </div>
              
              <textarea 
                [(ngModel)]="notes"
                (input)="onNotesChange()"
                placeholder="Saisissez vos notes importantes..." 
                class="w-full flex-grow min-h-[100px] bg-slate-50 border border-slate-100 rounded-2xl p-3 text-[11px] font-semibold focus:outline-none focus:border-primary-blue focus:ring-4 focus:ring-primary-blue/5 transition-all duration-300 placeholder-slate-400 leading-relaxed"
              ></textarea>

              <button 
                (click)="saveNotes()" 
                class="w-full rounded-full py-2.5 border-2 border-primary-blue text-primary-blue hover:bg-primary-blue hover:text-white font-extrabold text-[10px] uppercase tracking-wider transition-all duration-200 active:scale-[0.98] cursor-pointer mt-auto"
              >
                Enregistrer
              </button>
            </div>

            <!-- Attachments Card -->
            <div class="bg-white rounded-3xl border border-slate-100 p-5 shadow-xl flex flex-col gap-4 h-full">
              <h4 class="text-slate-800 font-extrabold text-xs tracking-tight border-b border-slate-100 pb-3 flex items-center gap-2">
                <span class="material-icons-round text-indigo-500 text-base">attachment</span>
                Ressources (PDF)
              </h4>

              <div class="flex flex-col gap-2.5">
                @for (file of attachments; track file.name) {
                  <button 
                    (click)="downloadFile(file.name)" 
                    class="group w-full bg-slate-50 border border-slate-100 hover:border-gold hover:bg-white rounded-2xl p-2.5 flex items-center justify-between transition-all duration-200 cursor-pointer"
                  >
                    <div class="flex items-center gap-2">
                      <div class="w-8 h-8 rounded-lg bg-red-50 border border-red-100 flex items-center justify-center text-red-500">
                        <span class="material-icons-round text-base">picture_as_pdf</span>
                      </div>
                      <div class="text-left">
                        <div class="text-slate-800 font-bold text-[10px] group-hover:text-primary-blue transition-colors truncate w-24 sm:w-28">{{ file.name }}</div>
                        <div class="text-slate-400 text-[9px] font-semibold mt-0.5">{{ file.size }}</div>
                      </div>
                    </div>
                    <span class="material-icons-round text-slate-400 group-hover:text-gold text-base transition-colors group-hover:translate-y-0.5 duration-200">download</span>
                  </button>
                }
              </div>
            </div>

            <!-- Photo Gallery Card -->
            <div class="bg-white rounded-3xl border border-slate-100 p-5 shadow-xl flex flex-col gap-4 h-full">
              <h4 class="text-slate-800 font-extrabold text-xs tracking-tight border-b border-slate-100 pb-3 flex items-center gap-2">
                <span class="material-icons-round text-emerald-500 text-base">photo_library</span>
                Photos (Image Set)
              </h4>

              <div class="flex-grow flex items-center justify-center py-4">
                <!-- Download Button (Matching second image style with round green button) -->
                <div (click)="downloadImages()" class="w-full bg-[#FAF6F0] hover:bg-[#D4AF37]/10 border border-[#D4AF37]/35 rounded-2xl p-2.5 flex items-center justify-between cursor-pointer transition-all select-none">
                  <div class="flex items-center gap-2">
                    <div class="w-8 h-8 rounded-lg bg-amber-50 border border-amber-100 flex items-center justify-center text-[#8C7355]">
                      <span class="material-icons-round text-base">image</span>
                    </div>
                    <div class="text-left font-display">
                      <div class="text-slate-800 font-bold text-[10px]">HSE_Images.zip</div>
                      <div class="text-slate-400 text-[9px] font-semibold mt-0.5">8.4 Mo • 8 Photos</div>
                    </div>
                  </div>
                  <!-- Round Green Download Button -->
                  <div class="w-7 h-7 rounded-full bg-emerald-500 text-white flex items-center justify-center shadow hover:bg-emerald-600 transition-colors">
                    <span class="material-icons-round text-xs">download</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

        </div>

        <!-- Right Column: Course Explanation Zone (35% width) -->
        <div class="flex flex-col gap-6">
          
          <!-- Premium Lesson Content/Explanation Card -->
          <div class="bg-white rounded-3xl border border-slate-100 p-6 shadow-xl flex flex-col gap-4 relative overflow-hidden h-full min-h-[400px]">
            <div class="absolute top-0 left-0 w-1.5 h-full bg-[#D4AF37]"></div>
            
            <h4 class="text-slate-800 font-extrabold text-sm tracking-tight border-b border-slate-100 pb-3 flex items-center gap-2 pl-2">
              <span class="material-icons-round text-[#8C7355] text-base">menu_book</span>
              Explication de la Leçon
            </h4>

            <div class="prose prose-slate text-xs text-slate-600 font-semibold leading-relaxed pl-2 flex flex-col gap-4 h-full">
              <p>
                Cette leçon aborde l'importance vitale des <strong>Équipements de Protection Individuelle (EPI)</strong> au sein des usines et chantiers de Ménara Holding. 
              </p>
              
              <div class="bg-[#FAF6F0] p-4 rounded-2xl border border-[#D4AF37]/30 my-1">
                <h5 class="text-[10px] font-black text-[#8C7355] uppercase mb-1.5 flex items-center gap-1.5">
                  <span class="material-icons-round text-xs">warning</span>
                  Point Clé de Sécurité
                </h5>
                <p class="text-[10px] text-slate-500 font-bold leading-normal m-0">
                  Le non-port des EPI obligatoires fait l'objet d'un avertissement de sécurité immédiat. Assurez-vous que vos équipements sont ajustés et conformes avant d'entrer en zone de production.
                </p>
              </div>

              <p>
                Vous découvrirez les normes obligatoires concernant le port du casque de chantier, des chaussures renforcées et des lunettes de protection pour prévenir tout risque d'accident.
              </p>

              <p class="text-slate-400 font-bold text-[9px] uppercase tracking-wider mt-2">
                Publié par : Administrateur HSE
              </p>

              <!-- J'AI COMPRIS (Pill Button with Gradient and outline glow matching layout) -->
              <div class="mt-auto pt-4 flex justify-center">
                <button 
                  (click)="onLessonUnderstood()" 
                  class="w-full max-w-xs rounded-full py-3.5 bg-gradient-to-r from-[#D4AF37] via-[#475569] to-[#334155] border-2 border-sky-300 text-white font-extrabold text-xs uppercase tracking-wider shadow-[0_0_12px_rgba(56,189,248,0.45)] hover:shadow-[0_0_18px_rgba(56,189,248,0.65)] hover:scale-[1.01] hover:-translate-y-0.5 transition-all duration-200 active:translate-y-0 active:scale-99 flex items-center justify-center gap-2 cursor-pointer select-none"
                >
                  <span class="material-icons-round text-sm">check_circle</span>
                  <span>J'ai compris (J'ai compris)</span>
                </button>
              </div>
            </div>
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
export class LessonComponent {
  private onboardingService = inject(OnboardingService);
  private router = inject(Router);

  isPlaying = signal<boolean>(false);
  notes = this.onboardingService.savedNotes();
  notesSaved = signal<boolean>(false);

  readonly attachments = [
    { name: 'Guide des EPI obligatoire - Holding.pdf', size: '1.8 Mo' },
    { name: 'Consignes de sécurité chantiers BTP.pdf', size: '2.4 Mo' },
    { name: 'Plan d\'évacuation d\'urgence Bétonnière.pdf', size: '940 Ko' }
  ];

  togglePlay() {
    this.isPlaying.update(p => !p);
  }

  onNotesChange() {
    this.notesSaved.set(false);
  }

  saveNotes() {
    this.onboardingService.savedNotes.set(this.notes);
    this.notesSaved.set(true);
    this.onboardingService.addChatMessage('ai', 'Excellent Meryem, tes notes sur les Équipements de Protection Individuelle ont été sauvegardées !');
  }

  downloadFile(fileName: string) {
    this.onboardingService.addChatMessage('ai', `Tu as téléchargé le fichier "${fileName}". As-tu besoin de précisions sur ce document ?`);
    alert(`Téléchargement de "${fileName}" démarré...`);
  }

  startQuiz() {
    this.router.navigate(['/quiz']);
  }

  goBack() {
    this.router.navigate(['/module-intro']);
  }

  downloadImages() {
    this.onboardingService.addChatMessage('ai', `Tu as téléchargé le pack d'images HSE pour ta formation. N'hésite pas à le consulter !`);
    alert(`Téléchargement de "HSE_Images.zip" (8 photos, 8.4 Mo) démarré...`);
  }

  onLessonUnderstood() {
    this.onboardingService.addChatMessage('ai', 'Parfait Meryem ! Tu as validé cette leçon. Tu peux maintenant poursuivre ton parcours ou tester tes connaissances.');
    alert("Félicitations ! Vous avez validé l'apprentissage de cette leçon.");
    this.router.navigate(['/module-intro']);
  }
}
