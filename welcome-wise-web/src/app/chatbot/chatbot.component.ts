import { Component, signal, inject, ViewChild, ElementRef, AfterViewChecked } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { OnboardingService, ChatMessage } from '../onboarding.service';

@Component({
  selector: 'app-chatbot',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="min-h-[calc(100vh-140px)] max-w-6xl mx-auto px-4 py-8 flex flex-col items-center justify-center">
      
      <!-- Chatbot Console Panel -->
      <div class="w-full max-w-2xl bg-white/95 backdrop-blur-md rounded-[32px] shadow-2xl border border-white/50 overflow-hidden animate-fade-in flex flex-col h-[580px]">
        
        <!-- Chat Header -->
        <div class="bg-[#F8F5F0] border-b border-slate-100 px-6 py-4 flex items-center justify-between">
          <div class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-full bg-gradient-to-tr from-amber-500 to-amber-600 flex items-center justify-center text-white shadow-md">
              <span class="material-icons-round">psychology</span>
            </div>
            <div>
              <h4 class="text-slate-800 font-extrabold text-sm font-display leading-tight">Assistant Onboarding IA</h4>
              <span class="text-[10px] text-emerald-500 font-bold uppercase tracking-wider flex items-center gap-1 mt-0.5">
                <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
                Bilingue: FR / Darija
              </span>
            </div>
          </div>
          <button (click)="clearChat()" class="text-slate-400 hover:text-slate-600 font-bold text-xs uppercase tracking-wider flex items-center gap-1 cursor-pointer">
            <span class="material-icons-round text-sm">clear_all</span>
            <span>Effacer</span>
          </button>
        </div>

        <!-- Message logs area -->
        <div #chatContainer class="flex-1 overflow-y-auto p-6 flex flex-col gap-4 bg-slate-50/50">
          @for (msg of chatHistory(); track msg.time) {
            <div 
              [class.self-end]="msg.sender === 'user'"
              [class.self-start]="msg.sender === 'ai'"
              class="max-w-[75%] flex flex-col gap-1"
            >
              <!-- Bubble Container -->
              <div 
                [class.bg-[#0F172A]]="msg.sender === 'user'"
                [class.text-white]="msg.sender === 'user'"
                [class.rounded-tr-none]="msg.sender === 'user'"
                [class.shadow-slate-900/10]="msg.sender === 'user'"
                [class.bg-[#F8F5F0]]="msg.sender === 'ai'"
                [class.text-slate-800]="msg.sender === 'ai'"
                [class.rounded-tl-none]="msg.sender === 'ai'"
                [class.shadow-slate-200/50]="msg.sender === 'ai'"
                class="rounded-2xl p-4 text-xs font-semibold leading-relaxed shadow shadow-slate-100"
              >
                {{ msg.text }}
              </div>
              <!-- Meta Time stamp -->
              <span 
                [class.text-right]="msg.sender === 'user'"
                class="text-[9px] font-bold text-slate-400 uppercase tracking-tight px-1"
              >
                {{ msg.time | date:'HH:mm' }}
              </span>
            </div>
          }
        </div>

        <!-- Input Bar (StadiumBorder) -->
        <form (submit)="sendMessage()" class="p-4 border-t border-slate-100 flex items-center gap-3 bg-white">
          <div class="relative flex-1">
            <input 
              type="text" 
              [(ngModel)]="userPrompt"
              name="prompt"
              placeholder="Posez votre question (ex: Kifach ndoz l quiz ?)..."
              class="w-full bg-slate-50 border border-slate-200 text-slate-800 rounded-full py-3.5 pl-6 pr-12 text-xs focus:outline-none focus:border-primary-blue focus:ring-4 focus:ring-primary-blue/5 transition-all duration-300 font-semibold"
            />
            <span class="material-icons-round text-slate-400 absolute right-4 top-1/2 -translate-y-1/2">chat_bubble_outline</span>
          </div>

          <button 
            type="submit" 
            class="w-12 h-12 rounded-full bg-primary-blue hover:bg-primary-blue-dark text-white flex items-center justify-center shadow-lg shadow-primary-blue/20 hover:scale-105 active:scale-95 transition-all cursor-pointer"
          >
            <span class="material-icons-round text-lg">send</span>
          </button>
        </form>

      </div>
    </div>
  `,
  styles: [`
    :host {
      display: block;
    }
  `]
})
export class ChatbotComponent implements AfterViewChecked {
  private onboardingService = inject(OnboardingService);

  @ViewChild('chatContainer') private myScrollContainer!: ElementRef;

  userPrompt = '';
  readonly chatHistory = this.onboardingService.chatHistory;

  ngAfterViewChecked() {
    this.scrollToBottom();
  }

  scrollToBottom(): void {
    try {
      this.myScrollContainer.nativeElement.scrollTop = this.myScrollContainer.nativeElement.scrollHeight;
    } catch(err) { }
  }

  sendMessage() {
    const text = this.userPrompt.trim();
    if (!text) return;

    // Send user message
    this.onboardingService.addChatMessage('user', text);
    this.userPrompt = '';

    // Simulate AI response delay
    setTimeout(() => {
      this.processAiResponse(text);
    }, 800);
  }

  processAiResponse(query: string) {
    const q = query.toLowerCase();
    let reply = '';

    if (q.includes('kifach') || q.includes('dakhli') || q.includes('quiz') || q.includes('ndoz')) {
      reply = 'Marhaban Meryem ! Pour passer le quiz HSE, va dans l\'onglet "Quiz HSE", lis la leçon sur les Équipements de Protection Individuelle, puis clique sur le bouton doré "Lancer le Quiz". Tu dois obtenir au moins 80% (8/10) pour débloquer ton badge !';
    } else if (q.includes('safety') || q.includes('hse') || q.includes('sécurité') || q.includes('salamat')) {
      reply = 'La sécurité (HSE) est au cœur des priorités chez Ménara Holding. N\'oublie pas de porter tes Équipements de Protection Individuelle (casque, lunettes, chaussures de sécurité) obligatoires dès l\'accès au site de production.';
    } else if (q.includes('holding') || q.includes('menara') || q.includes('ménara')) {
      reply = 'Ménara Holding est un fleuron industriel marocain fondé à Marrakech, présent dans le BTP, le Béton, les Carrières, le Transport et l\'Énergie. Nous accompagnons chaque nouveau collaborateur avec ce parcours interactif.';
    } else if (q.includes('badge') || q.includes('récompense')) {
      reply = 'Tu possèdes actuellement des badges comme "Ambassadeur des Valeurs" et "Explorateur Actif". En réussissant le Quiz HSE avec plus de 8/10, tu débloqueras ton badge "Expert en Sécurité" et grimperas à 75% d\'intégration !';
    } else if (q.includes('bonjour') || q.includes('salam') || q.includes('ahlan')) {
      reply = 'Ahlan Meryem ! Comment puis-je t\'aider dans ton parcours d\'intégration chez Ménara Holding aujourd\'hui ?';
    } else {
      reply = 'C\'est bien noté, Meryem. Je suis là pour t\'accompagner pas à pas dans ton intégration. N\'hésite pas à me poser d\'autres questions sur la sécurité, le groupe ou tes badges ! 🚀';
    }

    this.onboardingService.addChatMessage('ai', reply);
  }

  clearChat() {
    this.onboardingService.chatHistory.set([
      {
        sender: 'ai',
        text: 'Marhaban bik Meryem ! Les messages ont été effacés. De quoi souhaites-tu parler ?',
        time: new Date()
      }
    ]);
  }
}
