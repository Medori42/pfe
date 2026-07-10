import { Injectable, signal, computed } from '@angular/core';

export interface QuizQuestion {
  questionText: string;
  options: string[];
  correctOptionIndex: number;
  explanation: string;
  aiHint: string;
}

export interface OnboardingItem {
  icon: string;
  labelKey: string;
  videoUrl?: string;
  videoDuration?: string;
  explanation?: string;
  keyPoint?: string;
  resources?: Array<{ name: string; size: string }>;
  photos?: Array<{ name: string; size: string; count: number }>;
}

export interface Interlocutor {
  name: string;
  role: string;
  avatarUrl: string;
}

export interface OnboardingModule {
  id: number;
  titleKey: string;
  subtitleKey: string;
  status: 'completed' | 'current' | 'locked';
  items: OnboardingItem[];
  interlocutorsList?: Interlocutor[];
  documents?: Array<{ name: string; fileName: string }>;
}

export interface Badge {
  title: string;
  subtitle: string;
  icon: string;
  isGold: boolean;
  isLocked: boolean;
}

export interface ChatMessage {
  sender: 'user' | 'ai';
  text: string;
  time: Date;
}

@Injectable({
  providedIn: 'root'
})
export class OnboardingService {
  // User Profile State
  readonly user = signal({
    firstName: 'Meryem',
    lastName: 'Fathi',
    email: 'meryem.fathi@menara.ma',
    department: 'HSE / Béton',
    role: 'Nouvelle employée (BTP)'
  });

  // Sector Selection State
  readonly selectedSector = signal<string | null>(null);

  // Selected Module State
  readonly selectedModule = signal<OnboardingModule | null>(null);

  // Points State
  readonly points = signal<number>(35);

  // Modules State
  readonly modules = signal<OnboardingModule[]>([
    {
      id: 1,
      titleKey: "Découverte du Groupe",
      subtitleKey: "Module 1",
      status: 'completed',
      items: [
        { icon: 'history', labelKey: "Histoire du Groupe" },
        { icon: 'handshake', labelKey: "Nos Valeurs" },
        { icon: 'business', labelKey: "Filiales du Groupe" },
      ],
      interlocutorsList: [
        {
          name: 'Sarah KABBAJ',
          role: 'DIRECTRICE HSE',
          avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=60'
        }
      ]
    },
    {
      id: 2,
      titleKey: "Sécurité & Règlements",
      subtitleKey: "Module 2",
      status: 'current',
      items: [
        { 
          icon: 'engineering', 
          labelKey: "Équipements de protection",
          videoUrl: "https://www.w3schools.com/html/mov_bbb.mp4",
          videoDuration: "15:00",
          explanation: "Cette leçon aborne l'importance vitale des Équipements de Protection Individuelle (EPI) au sein des usines et chantiers de Ménara Holding.",
          keyPoint: "Le non-port des EPI obligatoires fait l'objet d'un avertissement de sécurité immédiat. Assurez-vous que vos équipements sont ajustés et conformes avant d'entrer en zone de production.",
          resources: [
            { name: "Guide des EPI obligatoires.pdf", size: "1.8 Mo" },
            { name: "Consignes de sécurité.pdf", size: "2.4 Mo" },
            { name: "Plan d'évacuation d'usine.pdf", size: "940 Ko" }
          ],
          photos: [
            { name: "HSE_Images.zip", size: "8.4 Mo", count: 8 }
          ]
        },
        { icon: 'domain', labelKey: "Visite du site / Usine" },
        { icon: 'assignment', labelKey: "Règles et consignes" },
      ],
      interlocutorsList: [
        {
          name: 'Karim BENJELLOUN',
          role: "CHARGÉ D'INTÉGRATION RH",
          avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=60'
        }
      ]
    },
    {
      id: 3,
      titleKey: "Métier",
      subtitleKey: "Module 3",
      status: 'locked',
      items: [
        { icon: 'build', labelKey: "Outils de travail" },
        { icon: 'person', labelKey: "Missions du poste" },
        { icon: 'play_circle_outline', labelKey: "Vidéo de présentation" },
      ]
    },
    {
      id: 4,
      titleKey: "Missions & Objectifs",
      subtitleKey: "Module 4",
      status: 'locked',
      items: [
        { icon: 'flag', labelKey: "Objectifs du trimestre" },
        { icon: 'groups', labelKey: "Présentation de l'équipe" },
        { icon: 'feedback', labelKey: "Session d'alignement" },
      ]
    },
    {
      id: 5,
      titleKey: "Évaluation Finale",
      subtitleKey: "Module 5",
      status: 'locked',
      items: [
        { icon: 'assignment_turned_in', labelKey: "Rapport d'intégration" },
        { icon: 'rate_review', labelKey: "Feedback Manager & RH" },
        { icon: 'stars', labelKey: "Certification de réussite" },
      ]
    }
  ]);

  // Badges State
  readonly badges = signal<Badge[]>([
    {
      title: 'Expert en Sécurité',
      subtitle: 'HSE Expert - Module 2',
      icon: 'engineering',
      isGold: true,
      isLocked: true // Will unlock dynamically when score >= 8/10
    },
    {
      title: 'Ambassadeur des Valeurs',
      subtitle: 'Ambassadeur - Intégration',
      icon: 'favorite',
      isGold: true,
      isLocked: false
    },
    {
      title: 'Explorateur Actif',
      subtitle: 'Explorateur - Module 1',
      icon: 'search',
      isGold: false,
      isLocked: false
    },
    {
      title: 'Héros de la Vitesse',
      subtitle: 'Quiz - Record de temps',
      icon: 'flash_on',
      isGold: false,
      isLocked: false
    },
    {
      title: 'Badge Verrouillé',
      subtitle: 'Module 4 requis',
      icon: 'lock_open',
      isGold: false,
      isLocked: true
    },
    {
      title: 'Badge Verrouillé',
      subtitle: 'Module 5 requis',
      icon: 'lock_open',
      isGold: false,
      isLocked: true
    }
  ]);

  // Chat History State
  readonly chatHistory = signal<ChatMessage[]>([
    {
      sender: 'ai',
      text: 'Marhaban bik Meryem ! Je suis ton assistant d\'intégration WelcomeWise. Tu as des questions sur Ménara Holding ou ton parcours HSE ?',
      time: new Date()
    }
  ]);

  // Quiz Performance Tracking
  readonly lastScore = signal<number | null>(null);
  readonly isQuizPassed = signal<boolean>(false);
  readonly lastQuizAnswers = signal<number[]>([]);

  // Employee Saved Notes State
  readonly savedNotes = signal<string>("• Les EPI (casque, lunettes, chaussures de sécurité) sont obligatoires sur tous les chantiers.\n• En cas d'incident, contacter Sarah Kabbaj (HSE) ou Karim Benjelloun (RH) immédiatement.");

  // Computed Properties
  readonly unlockedBadgesCount = computed(() => {
    return this.badges().filter(b => !b.isLocked).length;
  });

  readonly globalProgressPercentage = computed(() => {
    // 75% progress if HSE quiz is completed/unlocked, else 65%
    return this.isQuizPassed() ? 75 : 65;
  });

  // Action Methods
  setSector(sector: string) {
    this.selectedSector.set(sector);
  }

  updateQuizResult(score: number, answers: number[], passed: boolean) {
    this.lastScore.set(score);
    this.lastQuizAnswers.set(answers);
    this.isQuizPassed.set(passed);

    if (passed) {
      // Add points
      this.points.update(p => p + (score * 10));

      // Unlock Module 2, set Module 3 to current
      this.modules.update(mods => {
        return mods.map(m => {
          if (m.id === 2) return { ...m, status: 'completed' as const };
          if (m.id === 3) return { ...m, status: 'current' as const };
          return m;
        });
      });

      // Unlock HSE badge
      this.badges.update(list => {
        return list.map((b, idx) => {
          if (idx === 0) return { ...b, isLocked: false };
          return b;
        });
      });
    }
  }

  addChatMessage(sender: 'user' | 'ai', text: string) {
    this.chatHistory.update(history => [
      ...history,
      { sender, text, time: new Date() }
    ]);
  }

  resetQuizState() {
    this.lastScore.set(null);
    this.lastQuizAnswers.set([]);
  }
}
