import { Component, signal, computed, inject, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { OnboardingService, QuizQuestion } from '../onboarding.service';

const QUESTIONS: QuizQuestion[] = [
  {
    questionText: "Quel équipement est obligatoire pour accéder à la zone de production principale ?",
    options: [
      "Lunettes de protection seulement",
      "Casque + chaussures de sécurité + lunettes",
      "Gants de protection thermique",
      "Aucun équipement requis"
    ],
    correctOptionIndex: 1,
    explanation: "Les Équipements de Protection Individuelle (EPI) de base (casque, chaussures renforcées, lunettes) sont obligatoires dans toute zone industrielle.",
    aiHint: "Le casque protège la tête, les chaussures protègent les pieds et les lunettes protègent les yeux. Cherchez la combinaison complète."
  },
  {
    questionText: "En cas d'alarme incendie dans l'usine, quelle est la première action à effectuer ?",
    options: [
      "Finir sa tâche en cours rapidement",
      "Appeler immédiatement son manager",
      "Prendre ses effets personnels",
      "Se diriger calmement vers le point de rassemblement"
    ],
    correctOptionIndex: 3,
    explanation: "La sécurité avant tout : évacuez immédiatement par l'issue de secours la plus proche sans paniquer ni vous arrêter pour récupérer des affaires.",
    aiHint: "Ne perdez pas de temps à rassembler des affaires ou appeler. La priorité absolue est de quitter la zone vers le point de rassemblement."
  },
  {
    questionText: "Que signifie le marquage au sol rouge et blanc zébré ?",
    options: [
      "Emplacement dédié aux machines",
      "Zone piétonne autorisée",
      "Zone d'accès libre (extincteurs, issues de secours)",
      "Zone de chargement temporaire"
    ],
    correctOptionIndex: 2,
    explanation: "Les zones rayées rouge et blanc indiquent l'obligation de laisser l'accès libre (issues de secours, extincteurs).",
    aiHint: "Ce marquage indique des zones de sécurité critique (extincteurs, issues) qui doivent rester libres de tout obstacle en permanence."
  },
  {
    questionText: "Quelle est la durée maximale de validité d'une autorisation de travail à chaud (permis de feu) ?",
    options: [
      "1 journée de travail",
      "1 semaine entière",
      "1 mois d'activité",
      "Durée illimitée"
    ],
    correctOptionIndex: 0,
    explanation: "Le permis de feu est délivré pour une tâche spécifique et une durée limitée, généralement une seule journée de travail.",
    aiHint: "Les risques d'incendie varient chaque jour. L'autorisation doit être renouvelée quotidiennement pour chaque poste."
  },
  {
    questionText: "En cas de déversement chimique accidentel, que devez-vous faire en premier ?",
    options: [
      "Ignorer le déversement et le laisser sécher",
      "Sécuriser la zone et utiliser le kit antipollution adapté",
      "Jeter de l'eau claire dessus",
      "Nettoyer avec vos vêtements de rechange"
    ],
    correctOptionIndex: 1,
    explanation: "Sécurisez d'abord la zone pour éviter tout contact direct, puis appliquez l'absorbant du kit antipollution.",
    aiHint: "Ne diluez jamais le produit chimique avec de l'eau. Sécurisez la zone et utilisez un kit absorbant."
  },
  {
    questionText: "Qui devez-vous contacter en priorité pour signaler un presque-accident ?",
    options: [
      "Le responsable HSE ou votre superviseur direct",
      "Le service informatique",
      "Le PDG du groupe",
      "Les ressources humaines"
    ],
    correctOptionIndex: 0,
    explanation: "Votre superviseur direct et l'équipe HSE sont formés pour enregistrer et corriger immédiatement les risques potentiels.",
    aiHint: "Le superviseur direct et le responsable HSE sont les plus aptes à corriger immédiatement les risques opérationnels."
  },
  {
    questionText: "Quel type d'extincteur doit être utilisé sur un feu électrique ?",
    options: [
      "Un seau d'eau",
      "Extincteur à eau pure",
      "Extincteur à CO2 ou à poudre",
      "Extincteur à eau avec additif"
    ],
    correctOptionIndex: 2,
    explanation: "L'eau conduit l'électricité. Il faut utiliser un agent non conducteur comme le CO2 ou la poudre chimique sèche.",
    aiHint: "L'eau conduit l'électricité et aggrave le risque d'électrocution. Utilisez un extincteur à CO2."
  },
  {
    questionText: "Quelle est la règle d'or pour le levage manuel d'une charge lourde ?",
    options: [
      "Porter la charge à bout de bras",
      "Fléchir les genoux et garder le dos droit",
      "Plier le dos en gardant les jambes tendues",
      "Soulever d'un coup sec"
    ],
    correctOptionIndex: 1,
    explanation: "Garder le dos droit et utiliser la force des jambes prévient les risques de blessures lombaires graves.",
    aiHint: "Pour préserver votre colonne vertébrale, pliez toujours vos jambes et gardez le dos bien droit durant l'effort."
  },
  {
    questionText: "Quel comportement est proscrit lors d'une visite de l'usine ?",
    options: [
      "Poser des questions au guide",
      "Suivre les allées piétonnes vertes",
      "Prendre des photos et s'écarter du tracé",
      "Porter les EPI requis"
    ],
    correctOptionIndex: 2,
    explanation: "Pour des raisons de sécurité et de confidentialité, les photos sont interdites et les visiteurs doivent suivre le guide.",
    aiHint: "Les photos non autorisées compromettent le secret industriel et s'écarter du tracé piéton est extrêmement dangereux."
  },
  {
    questionText: "Quelle est la signification du pictogramme Point d'Exclamation Rouge ?",
    options: [
      "Produit inflammable",
      "Danger de mort immédiat",
      "Produit irritant, nocif ou sensibilisant",
      "Substance corrosive"
    ],
    correctOptionIndex: 2,
    explanation: "Ce pictogramme signale des produits chimiques qui présentent des risques d'irritation cutanée ou de toxicité moyenne.",
    aiHint: "Ce symbole est utilisé pour les produits nocifs, irritants ou sensibilisants qui nécessitent des précautions standards."
  }
];

@Component({
  selector: 'app-quiz',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="min-h-[calc(100vh-140px)] max-w-6xl mx-auto px-4 py-8 flex flex-col items-center justify-center">
      
      @if (viewState() === 'play') {
        <!-- PLAY VIEW -->
        <div class="w-full max-w-xl bg-white/95 backdrop-blur-md rounded-[32px] shadow-2xl border border-white/50 overflow-hidden animate-fade-in flex flex-col relative">
          
          <!-- Top Beige Banner -->
          <div class="bg-[#F8F5F0] border-b border-slate-100 px-8 py-5 flex items-center justify-between">
            <div class="flex items-center gap-3">
              <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=120" alt="Avatar" class="w-9 h-9 rounded-full border border-white shadow-md">
              <div>
                <div class="text-slate-800 font-bold text-xs">Meryem FATHI</div>
                <div class="text-slate-400 text-[10px] font-semibold uppercase tracking-wider">Leçon 2.3 • Quiz HSE</div>
              </div>
            </div>

            <div class="flex items-center gap-4">
              <!-- Points -->
              <div class="bg-amber-50 border border-amber-200 rounded-full px-3.5 py-1 flex items-center gap-1">
                <span class="material-icons-round text-amber-500 text-sm">stars</span>
                <span class="text-amber-800 font-extrabold text-xs tracking-tight">{{ points() }} Pts</span>
              </div>

              <!-- 20s Circular Timer -->
              <div class="flex items-center gap-1.5 bg-slate-50 border border-slate-100 rounded-full pl-2 pr-3.5 py-1">
                <div class="relative w-6 h-6 flex items-center justify-center">
                  <svg class="w-6 h-6 transform -rotate-90">
                    <circle cx="12" cy="12" r="10" stroke="#E2E8F0" stroke-width="2" fill="transparent" />
                    <circle cx="12" cy="12" r="10" 
                            [class.stroke-red-500]="secondsLeft() <= 5"
                            [class.stroke-primary-blue]="secondsLeft() > 5" 
                            stroke-width="2" fill="transparent"
                            stroke-dasharray="62.8"
                            [attr.stroke-dashoffset]="62.8 - (62.8 * secondsLeft() / 20)"
                            stroke-linecap="round" class="transition-all duration-1000 ease-linear" />
                  </svg>
                  <span class="absolute text-[10px] font-bold" [class.text-red-500]="secondsLeft() <= 5" [class.text-slate-700]="secondsLeft() > 5">
                    {{ secondsLeft() }}
                  </span>
                </div>
                <span class="text-[10px] font-bold tracking-tight text-slate-500">SEC</span>
              </div>
            </div>
          </div>

          <!-- Card Body -->
          <div class="p-8 flex-1 flex flex-col">
            <!-- Progress Bar -->
            <div class="mb-6">
              <div class="flex items-center justify-between text-xs font-semibold text-slate-500 mb-2">
                <span>QUESTION {{ currentQuestionIndex() + 1 }} SUR {{ questions.length }}</span>
                <span class="font-bold text-primary-blue">{{ ((currentQuestionIndex() + 1) / questions.length * 100) | number:'1.0-0' }}%</span>
              </div>
              <div class="w-full bg-slate-100 h-2 rounded-full overflow-hidden">
                <div class="bg-gradient-to-r from-primary-blue to-primary-blue-dark h-full rounded-full transition-all duration-300" 
                     [style.width.%]="(currentQuestionIndex() + 1) / questions.length * 100">
                </div>
              </div>
            </div>

            <!-- Question Text -->
            <h2 class="text-slate-800 font-extrabold text-xl leading-snug tracking-tight mb-6 font-display">
              {{ currentQuestion().questionText }}
            </h2>

            <!-- Options (StadiumBorder capsule shapes) -->
            <div class="flex flex-col gap-3.5 mb-6">
              @for (option of currentQuestion().options; track $index) {
                <button 
                  (click)="selectOption($index)"
                  [class.border-primary-blue]="selectedOptionIndex() === $index"
                  [class.bg-primary-blue]="selectedOptionIndex() === $index"
                  [class.text-white]="selectedOptionIndex() === $index"
                  [class.shadow-lg]="selectedOptionIndex() === $index"
                  [class.shadow-primary-blue/20]="selectedOptionIndex() === $index"
                  [class.border-slate-200]="selectedOptionIndex() !== $index"
                  [class.bg-white]="selectedOptionIndex() !== $index"
                  [class.text-slate-600]="selectedOptionIndex() !== $index"
                  [class.hover:border-primary-blue-dark]="selectedOptionIndex() !== $index"
                  [class.hover:bg-primary-blue/5]="selectedOptionIndex() !== $index"
                  class="group w-full rounded-full border-2 py-3.5 px-6 text-left font-semibold text-sm transition-all duration-200 active:scale-99 flex items-center justify-between cursor-pointer"
                >
                  <div class="flex items-center gap-4">
                    <div 
                      [class.bg-white]="selectedOptionIndex() === $index"
                      [class.text-primary-blue]="selectedOptionIndex() === $index"
                      [class.bg-slate-100]="selectedOptionIndex() !== $index"
                      [class.text-slate-500]="selectedOptionIndex() !== $index"
                      class="w-7 h-7 rounded-full flex items-center justify-center font-bold text-xs transition-colors"
                    >
                      {{ ['A', 'B', 'C', 'D'][$index] }}
                    </div>
                    <span>{{ option }}</span>
                  </div>
                  @if (selectedOptionIndex() === $index) {
                    <span class="material-icons-round text-white text-lg">check_circle</span>
                  }
                </button>
              }
            </div>

            <!-- ChatGPT Floating Button for AI Hints (Bottom) -->
            <div class="mt-auto flex flex-col gap-3">
              <button 
                (click)="toggleAiHint()" 
                class="self-start flex items-center gap-2 text-xs font-bold text-amber-600 hover:text-amber-700 transition-colors uppercase tracking-wider cursor-pointer"
              >
                <span class="material-icons-round text-base animate-bounce">auto_awesome</span>
                <span>ChatGPT Helper Index</span>
              </button>

              @if (showAiHint()) {
                <div class="bg-gradient-to-r from-amber-50 to-amber-100/50 border border-amber-200/60 rounded-2xl p-4 text-xs text-amber-900 leading-relaxed shadow-sm animate-fade-in">
                  <div class="font-bold flex items-center gap-1.5 mb-1.5 text-amber-800">
                    <span class="material-icons-round text-sm">psychology</span>
                    CONSEIL DE L'IA (CHATGPT)
                  </div>
                  <p>{{ selectedOptionIndex() !== null ? currentQuestion().aiHint : 'Veuillez d\\'abord sélectionner une option pour recevoir un indice contextualisé de l\\'IA.' }}</p>
                </div>
              }
            </div>

            <!-- Validate & Next Button (StadiumBorder) -->
            <button 
              (click)="nextQuestion()" 
              class="w-full rounded-full py-4 bg-gradient-to-r from-primary-blue to-primary-blue-dark text-white font-extrabold text-sm uppercase tracking-wider shadow-lg shadow-primary-blue/20 hover:shadow-xl hover:shadow-primary-blue/30 transition-all duration-200 active:scale-[0.98] mt-6 flex items-center justify-center gap-2 cursor-pointer"
            >
              <span>{{ currentQuestionIndex() === questions.length - 1 ? 'Terminer le Quiz' : 'Valider & Continuer' }}</span>
              <span class="material-icons-round text-base">arrow_forward</span>
            </button>
          </div>
        </div>
      } 
      
      @else {
        <!-- RESULT VIEW -->
        <div class="w-full max-w-xl bg-white rounded-[32px] shadow-2xl border border-slate-100 overflow-hidden animate-fade-in flex flex-col">
          
          <!-- Banner Header -->
          <div 
            [class.bg-gradient-to-r]="isSuccess()"
            [class.from-gold]="isSuccess()"
            [class.to-gold-dark]="isSuccess()"
            [class.bg-slate-700]="!isSuccess()"
            class="py-6 px-8 flex items-center justify-center text-white shadow-md"
          >
            <h2 class="font-extrabold text-lg tracking-wide uppercase font-display">
              {{ isSuccess() ? 'Félicitations, Meryem !' : 'Désolé, Meryem !' }}
            </h2>
          </div>

          <!-- Result Content -->
          <div class="p-8 flex flex-col items-center">
            
            <!-- Circular Progress SVG with ping details -->
            <div class="relative w-40 h-40 flex items-center justify-center mb-8">
              @if (isSuccess()) {
                <div class="absolute inset-0 bg-radial-gradient from-amber-200/30 to-transparent scale-150 animate-ping opacity-45 rounded-full pointer-events-none"></div>
              }
              
              <svg class="w-36 h-36 transform -rotate-90">
                <circle cx="72" cy="72" r="64" stroke="#F1F5F9" stroke-width="8" fill="transparent" />
                <circle cx="72" cy="72" r="64" 
                        [class.stroke-gold]="isSuccess()" 
                        [class.stroke-red-500]="!isSuccess()" 
                        stroke-width="8" fill="transparent"
                        stroke-dasharray="402"
                        [attr.stroke-dashoffset]="402 - (402 * score() / questions.length)"
                        stroke-linecap="round" class="transition-all duration-1000 ease-out" />
              </svg>
              
              <div class="absolute flex flex-col items-center">
                <span class="text-slate-800 font-black text-4xl leading-none tracking-tight font-display">{{ score() * 10 }}%</span>
                <span class="text-slate-400 font-bold text-xs tracking-wider uppercase mt-1">{{ score() }}/{{ questions.length }} Correct</span>
              </div>
            </div>

            <!-- Text Description -->
            <p class="text-center text-sm font-semibold text-slate-500 max-w-sm mb-6 leading-relaxed">
              {{ isSuccess() 
                ? 'Vous avez réussi avec succès le quiz d\\'intégration HSE ! Vous avez déverrouillé votre premier badge.' 
                : 'Le score minimum de 80% n\\'a pas été atteint. Prenez le temps de revoir les leçons et réessayez.' 
              }}
            </p>

            <!-- Badge Unlocked Card -->
            <div class="w-full max-w-xs bg-slate-50/50 border border-slate-100 rounded-3xl p-5 flex flex-col items-center mb-6">
              <div 
                [class.border-gold]="isSuccess()"
                [class.bg-amber-50]="isSuccess()"
                [class.border-slate-300]="!isSuccess()"
                [class.bg-slate-100]="!isSuccess()"
                class="w-16 h-16 rounded-full border-4 flex items-center justify-center shadow-md mb-3"
              >
                <span 
                  [class.text-amber-600]="isSuccess()"
                  [class.text-slate-400]="!isSuccess()"
                  class="material-icons-round text-3xl"
                >
                  {{ isSuccess() ? 'engineering' : 'lock' }}
                </span>
              </div>
              <span class="text-slate-800 font-extrabold text-sm tracking-tight font-display">Expert en Sécurité</span>
              <span class="text-[10px] font-bold uppercase tracking-wider mt-0.5"
                    [class.text-amber-600]="isSuccess()"
                    [class.text-slate-400]="!isSuccess()">
                {{ isSuccess() ? 'Badge Déverrouillé' : 'Badge Verrouillé' }}
              </span>
            </div>

            <!-- Reusable Review Log Panel (Expandable Accordion) -->
            <div class="w-full mb-8">
              <button 
                (click)="toggleReviewPanel()" 
                class="w-full rounded-2xl bg-slate-50 hover:bg-slate-100 border border-slate-100 py-3 px-5 text-left font-bold text-xs uppercase tracking-wider text-slate-600 flex items-center justify-between cursor-pointer"
              >
                <span>Revoir les questions & explications</span>
                <span class="material-icons-round text-base transition-transform duration-200" [class.rotate-180]="showReviewPanel()">keyboard_arrow_down</span>
              </button>

              @if (showReviewPanel()) {
                <div class="mt-4 flex flex-col gap-4 max-h-[300px] overflow-y-auto pr-2">
                  @for (q of questions; track q.questionText; let qIdx = $index) {
                    <div class="border-b border-slate-100 pb-3 flex flex-col gap-2">
                      <h5 class="text-slate-800 font-bold text-xs leading-relaxed">
                        {{ qIdx + 1 }}. {{ q.questionText }}
                      </h5>
                      <!-- Options visual status -->
                      <div class="grid grid-cols-1 sm:grid-cols-2 gap-2 text-[10px] font-semibold">
                        @for (opt of q.options; track opt; let optIdx = $index) {
                          <div 
                            [class.bg-emerald-50]="optIdx === q.correctOptionIndex"
                            [class.text-emerald-700]="optIdx === q.correctOptionIndex"
                            [class.border-emerald-200]="optIdx === q.correctOptionIndex"
                            [class.bg-rose-50]="optIdx === userAnswers()[qIdx] && optIdx !== q.correctOptionIndex"
                            [class.text-rose-700]="optIdx === userAnswers()[qIdx] && optIdx !== q.correctOptionIndex"
                            [class.border-rose-200]="optIdx === userAnswers()[qIdx] && optIdx !== q.correctOptionIndex"
                            [class.bg-slate-50]="optIdx !== q.correctOptionIndex && optIdx !== userAnswers()[qIdx]"
                            [class.text-slate-400]="optIdx !== q.correctOptionIndex && optIdx !== userAnswers()[qIdx]"
                            [class.border-slate-100]="optIdx !== q.correctOptionIndex && optIdx !== userAnswers()[qIdx]"
                            class="border rounded-full py-1.5 px-3 flex items-center justify-between"
                          >
                            <span>{{ opt }}</span>
                            @if (optIdx === q.correctOptionIndex) {
                              <span class="material-icons-round text-emerald-500 text-xs">done</span>
                            } @else if (optIdx === userAnswers()[qIdx]) {
                              <span class="material-icons-round text-rose-500 text-xs">close</span>
                            }
                          </div>
                        }
                      </div>
                      <p class="text-[10px] text-slate-400 leading-relaxed font-semibold italic">
                        🎓 {{ q.explanation }}
                      </p>
                    </div>
                  }
                </div>
              }
            </div>

            <!-- Action Buttons (StadiumBorder capsule) -->
            <div class="w-full flex flex-col gap-3">
              @if (isSuccess()) {
                <button 
                  (click)="goToProfile()" 
                  class="w-full rounded-full py-4 bg-gradient-to-r from-primary-blue to-primary-blue-dark text-white font-extrabold text-sm uppercase tracking-wider shadow-lg shadow-primary-blue/20 hover:shadow-xl hover:shadow-primary-blue/30 transition-all duration-200 active:scale-[0.98] flex items-center justify-center gap-2 cursor-pointer"
                >
                  <span>Passer au Profil Personnel</span>
                  <span class="material-icons-round text-base">arrow_forward</span>
                </button>
              } @else {
                <button 
                  (click)="retryQuiz()" 
                  class="w-full rounded-full py-4 bg-slate-700 text-white font-extrabold text-sm uppercase tracking-wider shadow-lg shadow-slate-700/20 hover:shadow-xl hover:shadow-slate-700/30 transition-all duration-200 active:scale-[0.98] flex items-center justify-center gap-2 cursor-pointer"
                >
                  <span class="material-icons-round text-base">replay</span>
                  <span>Recommencer le Quiz</span>
                </button>
              }
              <button (click)="goToRoadmap()" class="w-full rounded-full py-4 border-2 border-slate-200 text-slate-500 font-extrabold text-sm uppercase tracking-wider hover:bg-slate-50 transition-colors duration-200 cursor-pointer">
                Retourner à la Feuille de Route
              </button>
            </div>

          </div>
        </div>
      }

    </div>
  `,
  styles: [`
    :host {
      display: block;
    }
  `]
})
export class QuizComponent implements OnInit, OnDestroy {
  private onboardingService = inject(OnboardingService);
  private router = inject(Router);

  // Read service states
  readonly points = this.onboardingService.points;
  
  // Local state
  readonly viewState = signal<'play' | 'result'>('play');
  readonly currentQuestionIndex = signal<number>(0);
  readonly selectedOptionIndex = signal<number | null>(null);
  readonly userAnswers = signal<number[]>([]);
  readonly showAiHint = signal<boolean>(false);
  readonly showReviewPanel = signal<boolean>(false);

  // Timer
  readonly secondsLeft = signal<number>(20); // 20s per question
  private timerInterval: any = null;

  // Final Results
  readonly score = signal<number>(0);
  readonly isSuccess = signal<boolean>(false);

  readonly questions = QUESTIONS;

  readonly currentQuestion = computed(() => this.questions[this.currentQuestionIndex()]);

  ngOnInit() {
    this.startTimer();
  }

  ngOnDestroy() {
    this.clearTimer();
  }

  // Timer
  startTimer() {
    this.clearTimer();
    this.secondsLeft.set(20);
    this.timerInterval = setInterval(() => {
      if (this.secondsLeft() > 0) {
        this.secondsLeft.update(s => s - 1);
      } else {
        this.clearTimer();
      }
    }, 1000);
  }

  clearTimer() {
    if (this.timerInterval) {
      clearInterval(this.timerInterval);
      this.timerInterval = null;
    }
  }

  selectOption(index: number) {
    this.selectedOptionIndex.set(index);
  }

  toggleAiHint() {
    this.showAiHint.update(v => !v);
  }

  toggleReviewPanel() {
    this.showReviewPanel.update(v => !v);
  }

  nextQuestion() {
    const selected = this.selectedOptionIndex();
    if (selected === null) {
      alert("Veuillez sélectionner une option avant de continuer !");
      return;
    }

    const currentQ = this.currentQuestion();
    const isCorrect = selected === currentQ.correctOptionIndex;

    if (isCorrect) {
      this.score.update(s => s + 1);
    }

    this.userAnswers.update(answers => [...answers, selected]);

    if (this.currentQuestionIndex() < this.questions.length - 1) {
      this.currentQuestionIndex.update(idx => idx + 1);
      this.selectedOptionIndex.set(null);
      this.showAiHint.set(false);
      this.startTimer();
    } else {
      this.clearTimer();
      const finalScore = this.score();
      const passed = finalScore >= 8;
      
      this.isSuccess.set(passed);
      
      // Update state in onboarding service (persists points, unlocks badges/modules)
      this.onboardingService.updateQuizResult(finalScore, this.userAnswers(), passed);
      
      this.viewState.set('result');
    }
  }

  retryQuiz() {
    this.onboardingService.resetQuizState();
    this.currentQuestionIndex.set(0);
    this.selectedOptionIndex.set(null);
    this.userAnswers.set([]);
    this.score.set(0);
    this.showAiHint.set(false);
    this.showReviewPanel.set(false);
    this.viewState.set('play');
    this.startTimer();
  }

  goToProfile() {
    this.router.navigate(['/profile']);
  }

  goToRoadmap() {
    this.router.navigate(['/roadmap']);
  }
}
