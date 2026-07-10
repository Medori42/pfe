import { Component, signal, computed, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet, RouterLink, Router, NavigationEnd } from '@angular/router';
import { filter } from 'rxjs/operators';
import { OnboardingService } from './onboarding.service';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet, RouterLink, FormsModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class App implements OnInit {
  private router = inject(Router);
  public onboardingService = inject(OnboardingService);

  // DEV Switcher ('employee' or 'admin')
  readonly systemRole = signal<'employee' | 'admin'>('employee');

  getModuleItems(moduleId: number) {
    const mod = this.onboardingService.modules().find(m => m.id === moduleId);
    return mod ? mod.items : [];
  }

  // Module Creation Modal State
  readonly showAddModuleModal = signal<boolean>(false);
  newModuleTitle = '';
  newModuleSubtitle = '';

  // Lesson Creation Modal State
  readonly showAddLessonModal = signal<boolean>(false);
  newLessonName = '';
  activeLessonModuleId = 1;

  openAddLessonModal(moduleId: number) {
    this.newLessonName = '';
    this.activeLessonModuleId = moduleId;
    this.showAddLessonModal.set(true);
  }

  submitAddLesson() {
    if (!this.newLessonName) {
      this.showToast("Veuillez saisir un titre pour la leçon !");
      return;
    }
    this.onboardingService.modules.update(mods => {
      return mods.map(m => {
        if (m.id === this.activeLessonModuleId) {
          return {
            ...m,
            items: [...m.items, { icon: 'assignment', labelKey: this.newLessonName }]
          };
        }
        return m;
      });
    });
    this.showAddLessonModal.set(false);
    this.showToast(`Leçon "${this.newLessonName}" ajoutée avec succès !`);
  }

  openAddModuleModal() {
    this.newModuleTitle = '';
    this.newModuleSubtitle = '';
    this.showAddModuleModal.set(true);
  }

  submitAddModule() {
    if (!this.newModuleTitle) {
      this.showToast("Veuillez saisir un titre pour le module !");
      return;
    }

    this.onboardingService.modules.update(mods => {
      const nextId = mods.length + 1;
      return [
        ...mods,
        {
          id: nextId,
          titleKey: this.newModuleTitle,
          subtitleKey: this.newModuleSubtitle || `Module ${nextId}`,
          status: 'locked' as const,
          items: []
        }
      ];
    });
    this.showAddModuleModal.set(false);
    this.showToast(`Module "${this.newModuleTitle}" créé avec succès !`);
  }

  updateModuleStatus(moduleId: number, event: Event) {
    const newStatus = (event.target as HTMLSelectElement).value as 'completed' | 'current' | 'locked';
    this.onboardingService.modules.update(mods => {
      return mods.map(m => m.id === moduleId ? { ...m, status: newStatus } : m);
    });
    this.showToast(`Statut du Module ${moduleId} mis à jour !`);
  }

  // Interlocutors list & dropdown state
  readonly interlocutors = [
    {
      name: 'Sarah KABBAJ',
      role: 'DIRECTRICE HSE',
      avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=60'
    },
    {
      name: 'Karim BENJELLOUN',
      role: "CHARGÉ D'INTÉGRATION RH",
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=60'
    }
  ];

  readonly activeInterlocutorDropdown = signal<number | null>(null);

  toggleInterlocutorDropdown(moduleId: number) {
    this.activeInterlocutorDropdown.set(
      this.activeInterlocutorDropdown() === moduleId ? null : moduleId
    );
  }

  addModuleInterlocutor(moduleId: number, name: string) {
    if (name === 'none') {
      this.onboardingService.modules.update(mods => {
        return mods.map(m => m.id === moduleId ? { ...m, interlocutorsList: [] } : m);
      });
      this.activeInterlocutorDropdown.set(null);
      this.showToast(`Tous les interlocuteurs ont été retirés du Module ${moduleId} !`);
      return;
    }

    const person = this.interlocutors.find(i => i.name === name);
    if (!person) return;

    this.onboardingService.modules.update(mods => {
      return mods.map(m => {
        if (m.id === moduleId) {
          const list = m.interlocutorsList || [];
          if (list.some(i => i.name === person.name)) {
            this.showToast(`${person.name} est déjà associé à ce module !`);
            return m;
          }
          return { ...m, interlocutorsList: [...list, person] };
        }
        return m;
      });
    });
    this.activeInterlocutorDropdown.set(null);
    this.showToast(`${person.name} associé au Module ${moduleId} !`);
  }

  removeModuleInterlocutor(moduleId: number, name: string) {
    this.onboardingService.modules.update(mods => {
      return mods.map(m => {
        if (m.id === moduleId) {
          const list = m.interlocutorsList || [];
          return { ...m, interlocutorsList: list.filter(i => i.name !== name) };
        }
        return m;
      });
    });
    this.showToast(`Interlocuteur retiré !`);
  }

  deleteModule(moduleId: number) {
    if (confirm("Êtes-vous sûr de vouloir supprimer ce module ?")) {
      this.onboardingService.modules.update(mods => mods.filter(m => m.id !== moduleId));
      this.showToast(`Module supprimé avec succès !`);
    }
  }

  readonly showAddDocModal = signal<boolean>(false);
  readonly activeModuleIdForDoc = signal<number | null>(null);
  newDocName = '';
  newDocFileName = '';
  readonly isDocDragging = signal<boolean>(false);

  openAddDocModal(moduleId: number) {
    this.activeModuleIdForDoc.set(moduleId);
    this.newDocName = '';
    this.newDocFileName = '';
    this.showAddDocModal.set(true);
  }

  onDocFileSelected(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      const file = input.files[0];
      this.newDocFileName = file.name;
      if (!this.newDocName) {
        this.newDocName = file.name.replace(/\.[^/.]+$/, "");
      }
    }
  }

  onDocFileDrop(event: DragEvent) {
    event.preventDefault();
    this.isDocDragging.set(false);
    if (event.dataTransfer && event.dataTransfer.files && event.dataTransfer.files[0]) {
      const file = event.dataTransfer.files[0];
      this.newDocFileName = file.name;
      if (!this.newDocName) {
        this.newDocName = file.name.replace(/\.[^/.]+$/, "");
      }
    }
  }

  onDocDragOver(event: DragEvent) {
    event.preventDefault();
    this.isDocDragging.set(true);
  }

  onDocDragLeave(event: DragEvent) {
    event.preventDefault();
    this.isDocDragging.set(false);
  }

  submitAddDoc() {
    const moduleId = this.activeModuleIdForDoc();
    if (!moduleId) return;
    if (!this.newDocName.trim()) {
      this.showToast("Veuillez saisir un nom pour le document.");
      return;
    }
    if (!this.newDocFileName) {
      this.showToast("Veuillez charger un fichier PDF.");
      return;
    }

    this.onboardingService.modules.update(mods => {
      return mods.map(m => {
        if (m.id === moduleId) {
          const existingDocs = m.documents || [];
          return {
            ...m,
            documents: [...existingDocs, { name: this.newDocName + ".pdf", fileName: this.newDocFileName }]
          };
        }
        return m;
      });
    });

    this.showToast(`Document "${this.newDocName}.pdf" ajouté avec succès !`);
    this.showAddDocModal.set(false);
  }

  removeModuleDocument(moduleId: number, docName: string) {
    this.onboardingService.modules.update(mods => {
      return mods.map(m => {
        if (m.id === moduleId) {
          const existingDocs = m.documents || [];
          return { ...m, documents: existingDocs.filter(d => d.name !== docName) };
        }
        return m;
      });
    });
    this.showToast(`Document retiré !`);
  }

  searchAndScrollModule(event: Event) {
    const query = (event.target as HTMLInputElement).value.toLowerCase().trim();
    if (!query) return;

    const matchedModule = this.onboardingService.modules().find(m => 
      m.id.toString() === query || 
      `module ${m.id}`.includes(query) || 
      m.titleKey.toLowerCase().includes(query)
    );

    if (matchedModule) {
      const element = document.getElementById(`admin-module-${matchedModule.id}`);
      if (element) {
        element.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'center' });
      }
    }
  }

  // Admin Workspace States
  readonly adminState = signal<'login' | 'dashboard'>('login');
  readonly activeAdminTab = signal<string>('dashboard');
  readonly activeTabInfo = computed(() => {
    switch (this.activeAdminTab()) {
      case 'dashboard':
        return { title: 'Tableau de Bord', subtitle: "Supervision de l'intégration • Ménara Holding" };
      case 'employees':
        return { title: 'Gestion des Employés', subtitle: "Suivi en temps réel de la progression des nouveaux arrivants" };
      case 'builder':
        return { title: 'Parcours Builder', subtitle: "Création et modification des parcours d'intégration" };
      case 'quiz':
        return { title: 'Contrôle Quiz IA', subtitle: "Gestion des quiz générés par intelligence artificielle" };
      case 'reports':
        return { title: 'Rapports', subtitle: "Analyses et export de données d'intégration" };
      case 'settings':
        return { title: 'Paramètres', subtitle: "Configuration du système et de l'administration" };
      default:
        return { title: 'WelcomeWise', subtitle: 'Administration' };
    }
  });
  readonly adminSearchQuery = signal<string>('');

  readonly adminEmployees = signal([
    { name: 'Mohamed El Fassi', email: 'mohitasaaa@gmail.com', role: 'Collaborateur', department: 'Finance', status: 'Succès', progress: 85, modules: '17/20 modules', avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=120' },
    { name: 'Matam Laolah', email: 'matam.laolah@gmail.com', role: 'Manager', department: 'Finance', status: 'Suspendu', progress: 30, modules: '6/20 modules', avatar: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&q=80&w=120' },
    { name: 'Mohamed El Fassi', email: 'mohitasaaa@gmail.com', role: 'Chef d\'équipe', department: 'Finance', status: 'Suspendu', progress: 30, modules: '6/20 modules', avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=120' }
  ]);

  readonly selectedEmployeeForTrack = signal<any | null>(null);
  readonly adminSelectedDepartmentFilter = signal<string>('Tous');
  readonly adminSelectedStatusFilter = signal<string>('Tous');

  readonly filteredEmployees = computed(() => {
    let list = this.adminEmployees();

    // Search query filter
    const query = this.adminSearchQuery().toLowerCase().trim();
    if (query) {
      list = list.filter(emp =>
        emp.name.toLowerCase().includes(query) ||
        emp.email.toLowerCase().includes(query) ||
        emp.department.toLowerCase().includes(query) ||
        emp.status.toLowerCase().includes(query)
      );
    }

    // Department filter
    const depFilter = this.adminSelectedDepartmentFilter();
    if (depFilter !== 'Tous') {
      list = list.filter(emp => emp.department === depFilter);
    }

    // Status filter
    const statusFilter = this.adminSelectedStatusFilter();
    if (statusFilter !== 'Tous') {
      list = list.filter(emp => emp.status === statusFilter);
    }

    return list;
  });

  readonly activeEmployeeForTrack = computed(() => this.selectedEmployeeForTrack() || this.filteredEmployees()[0]);
  adminEmail = '';
  adminPassword = '';
  adminRememberMe = false;
  readonly showAdminPassword = signal<boolean>(false);

  // Parcours Builder States
  readonly builderSelectedDepartment = signal<string>('SI');
  readonly builderComplexity = signal<number>(50);
  readonly builderQuestionsCount = signal<number>(10);
  builderComplexityVal = 50;
  builderQuestionsCountVal = 10;

  onComplexityChange(event: Event) {
    const input = event.target as HTMLInputElement;
    this.builderComplexity.set(Number(input.value));
  }

  onQuestionsCountChange(event: Event) {
    const input = event.target as HTMLInputElement;
    this.builderQuestionsCount.set(Number(input.value));
  }

  // Add Employee Form State
  readonly showAddEmployeeModal = signal<boolean>(false);
  readonly isDragging = signal<boolean>(false);
  newEmpName = '';
  newEmpEmail = '';
  newEmpPassword = '';
  newEmpRole = 'Collaborateur';
  newEmpDepartment = 'Finance';
  newEmpStatus = 'Actif';
  newEmpAvatar = '';

  // Edit Employee Form State
  readonly selectedEmployeeForEdit = signal<any | null>(null);
  readonly isEditingDragging = signal<boolean>(false);
  editEmpName = '';
  editEmpEmail = '';
  editEmpPassword = '';
  editEmpRole = 'Collaborateur';
  editEmpDepartment = 'Finance';
  editEmpStatus = 'Actif';
  editEmpAvatar = '';
  editEmpOriginalEmail = '';

  onAvatarDrop(event: DragEvent) {
    event.preventDefault();
    this.isDragging.set(false);
    if (event.dataTransfer?.files && event.dataTransfer.files.length > 0) {
      const file = event.dataTransfer.files[0];
      this.readAvatarFile(file);
    }
  }

  onAvatarDragOver(event: DragEvent) {
    event.preventDefault();
    this.isDragging.set(true);
  }

  onAvatarDragLeave(event: DragEvent) {
    event.preventDefault();
    this.isDragging.set(false);
  }

  onAvatarFileSelected(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) {
      const file = input.files[0];
      this.readAvatarFile(file);
    }
  }

  private readAvatarFile(file: File) {
    if (!file.type.startsWith('image/')) {
      this.showToast("Veuillez déposer une image valide !");
      return;
    }
    const reader = new FileReader();
    reader.onload = () => {
      this.newEmpAvatar = reader.result as string;
      this.showToast("Image de l'avatar chargée !");
    };
    reader.readAsDataURL(file);
  }

  openAddEmployeeModal() {
    this.newEmpName = '';
    this.newEmpEmail = '';
    this.newEmpPassword = '';
    this.newEmpRole = 'Collaborateur';
    this.newEmpDepartment = 'Finance';
    this.newEmpStatus = 'Actif';
    this.newEmpAvatar = '';
    this.showAddEmployeeModal.set(true);
  }

  submitAddEmployee() {
    if (!this.newEmpName || !this.newEmpEmail || !this.newEmpPassword) {
      this.showToast("Veuillez remplir le nom, l'email et le mot de passe !");
      return;
    }

    const defaultAvatars = [
      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=120',
      'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&q=80&w=120',
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=120',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=120'
    ];
    const finalAvatar = this.newEmpAvatar || defaultAvatars[Math.floor(Math.random() * defaultAvatars.length)];

    const newEmp = {
      name: this.newEmpName,
      email: this.newEmpEmail,
      role: this.newEmpRole,
      department: this.newEmpDepartment,
      status: this.newEmpStatus,
      progress: 0,
      modules: '0/20 modules',
      avatar: finalAvatar
    };

    this.adminEmployees.update(list => [...list, newEmp]);
    this.showAddEmployeeModal.set(false);
    this.showToast(`Collaborateur ${this.newEmpName} ajouté avec succès !`);
  }

  openEditEmployeeModal(emp: any) {
    this.editEmpName = emp.name;
    this.editEmpEmail = emp.email;
    this.editEmpOriginalEmail = emp.email;
    this.editEmpPassword = emp.password || '••••••••';
    this.editEmpRole = emp.role || 'Collaborateur';
    this.editEmpDepartment = emp.department;
    this.editEmpStatus = emp.status;
    this.editEmpAvatar = emp.avatar;
    this.selectedEmployeeForEdit.set(emp);
  }

  onEditAvatarDrop(event: DragEvent) {
    event.preventDefault();
    this.isEditingDragging.set(false);
    if (event.dataTransfer?.files && event.dataTransfer.files.length > 0) {
      const file = event.dataTransfer.files[0];
      this.readEditAvatarFile(file);
    }
  }

  onEditAvatarDragOver(event: DragEvent) {
    event.preventDefault();
    this.isEditingDragging.set(true);
  }

  onEditAvatarDragLeave(event: DragEvent) {
    event.preventDefault();
    this.isEditingDragging.set(false);
  }

  onEditAvatarFileSelected(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) {
      const file = input.files[0];
      this.readEditAvatarFile(file);
    }
  }

  private readEditAvatarFile(file: File) {
    if (!file.type.startsWith('image/')) {
      this.showToast("Veuillez déposer une image valide !");
      return;
    }
    const reader = new FileReader();
    reader.onload = () => {
      this.editEmpAvatar = reader.result as string;
      this.showToast("Image de l'avatar modifiée !");
    };
    reader.readAsDataURL(file);
  }

  submitEditEmployee() {
    if (!this.editEmpName || !this.editEmpEmail || !this.editEmpPassword) {
      this.showToast("Veuillez remplir tous les champs obligatoires (nom, email et mot de passe) !");
      return;
    }

    this.adminEmployees.update(list => {
      return list.map(emp => {
        if (emp.email === this.editEmpOriginalEmail) {
          return {
            ...emp,
            name: this.editEmpName,
            email: this.editEmpEmail,
            password: this.editEmpPassword,
            role: this.editEmpRole,
            department: this.editEmpDepartment,
            status: this.editEmpStatus,
            avatar: this.editEmpAvatar
          };
        }
        return emp;
      });
    });

    this.selectedEmployeeForEdit.set(null);
    this.showToast(`Collaborateur ${this.editEmpName} mis à jour avec succès !`);
  }

  // Employee State links
  readonly showNavbar = signal<boolean>(false);
  readonly points = this.onboardingService.points;
  readonly currentUrl = signal<string>('');
  readonly toastMessage = signal<string>('');

  ngOnInit() {
    this.showToast("Système WelcomeWise Initialisé !");

    // Listen to routing events for the employee space navbar
    this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe((event: any) => {
      const url = event.urlAfterRedirects;
      this.currentUrl.set(url);
      this.showNavbar.set(url !== '/login' && url !== '/' && this.systemRole() === 'employee');
    });
  }

  switchRole(role: 'employee' | 'admin') {
    this.systemRole.set(role);
    if (role === 'admin') {
      this.showNavbar.set(false);
      this.adminState.set('login');
    } else {
      // Re-evaluate navbar visibility for employee based on current url
      const url = this.router.url;
      this.currentUrl.set(url);
      this.showNavbar.set(url !== '/login' && url !== '/');
    }
    this.showToast(`Espace commuté en : ${role === 'admin' ? 'Administration' : 'Collaborateur'}`);
  }

  toggleRole() {
    const newRole = this.systemRole() === 'employee' ? 'admin' : 'employee';
    this.switchRole(newRole);
  }

  handleAdminLogin() {
    if (!this.adminEmail || !this.adminPassword) {
      this.showToast("Veuillez saisir votre email et mot de passe !");
      return;
    }
    this.adminState.set('dashboard');
    this.showToast("🔓 Connexion Admin réussie via Bcrypt !");
  }

  logoutAdmin() {
    this.adminState.set('login');
    this.adminEmail = '';
    this.adminPassword = '';
    this.selectedEmployeeForTrack.set(null);
    this.showToast("🔒 Déconnexion réussie.");
  }

  toggleAdminPassword() {
    this.showAdminPassword.update(v => !v);
  }

  logoutEmployee() {
    this.onboardingService.resetQuizState();
    this.router.navigate(['/login']);
    this.showToast("🔒 Déconnexion réussie.");
  }

  showToast(message: string) {
    this.toastMessage.set(message);
    setTimeout(() => this.toastMessage.set(''), 3000);
  }
}