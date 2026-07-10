import { Component, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="min-h-screen bg-[#0F172A] relative flex flex-col items-center justify-center p-4 overflow-hidden">
      <!-- Background Decorative Lights -->
      <div class="absolute w-[500px] h-[500px] rounded-full bg-blue-500/10 blur-[120px] top-[-10%] left-[-10%] pointer-events-none"></div>
      <div class="absolute w-[400px] h-[400px] rounded-full bg-amber-500/5 blur-[100px] bottom-[-10%] right-[-10%] pointer-events-none"></div>

      <!-- Main Login Container -->
      <div class="w-full max-w-md z-10 animate-fade-in">
        <!-- Logo Header -->
        <div class="text-center mb-8 flex flex-col items-center">
          <div class="w-16 h-16 rounded-full bg-gradient-to-r from-primary-blue to-primary-blue-dark flex items-center justify-center shadow-lg border-2 border-white mb-3">
            <span class="text-white font-black text-3xl">W</span>
          </div>
          <h1 class="text-white text-3xl font-black tracking-tight font-display">WelcomeWise</h1>
          <p class="text-slate-400 text-xs font-semibold uppercase tracking-wider mt-1">Ménara Holding Integration Portal</p>
        </div>

        <!-- Login Card with Neon Gradient Border -->
        <div class="bg-slate-900/80 backdrop-blur-xl border border-white/10 rounded-[32px] p-8 shadow-2xl relative">
          <!-- Top Gold Neon bar -->
          <div class="absolute top-0 left-12 right-12 h-[2px] bg-gradient-to-r from-transparent via-gold to-transparent shadow-[0_0_15px_#C9A84C]"></div>

          <h2 class="text-white font-extrabold text-2xl mb-6 text-center font-display">Connexion</h2>

          <!-- Form -->
          <form (submit)="onSubmit()" class="flex flex-col gap-5">
            <!-- Email Labeled Field -->
            <div class="flex flex-col gap-1.5">
              <label class="text-slate-300 font-bold text-xs uppercase tracking-wider">Email Professionnel</label>
              <div class="relative">
                <input 
                  type="email" 
                  name="email"
                  [(ngModel)]="email"
                  placeholder="meryem.fathi@menara.ma" 
                  required
                  class="w-full bg-slate-950/60 border border-slate-800 text-white rounded-full py-3.5 pl-6 pr-12 text-sm focus:outline-none focus:border-primary-blue focus:ring-4 focus:ring-primary-blue/20 transition-all duration-300 shadow-inner font-semibold"
                />
                <span class="material-icons-round text-slate-500 absolute right-4 top-1/2 -translate-y-1/2">mail_outline</span>
              </div>
            </div>

            <!-- Password Labeled Field -->
            <div class="flex flex-col gap-1.5">
              <label class="text-slate-300 font-bold text-xs uppercase tracking-wider">Mot de Passe</label>
              <div class="relative">
                <input 
                  [type]="showPassword() ? 'text' : 'password'" 
                  name="password"
                  [(ngModel)]="password"
                  placeholder="••••••••" 
                  required
                  class="w-full bg-slate-950/60 border border-slate-800 text-white rounded-full py-3.5 pl-6 pr-12 text-sm focus:outline-none focus:border-gold focus:ring-4 focus:ring-gold/15 transition-all duration-300 shadow-inner font-semibold"
                />
                <button 
                  type="button"
                  (click)="togglePasswordVisibility()"
                  class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-500 hover:text-slate-300 transition-colors focus:outline-none cursor-pointer"
                >
                  <span class="material-icons-round">{{ showPassword() ? 'visibility_off' : 'visibility' }}</span>
                </button>
              </div>
            </div>

            <!-- Remember me & Forgot Password -->
            <div class="flex items-center justify-between text-xs font-semibold text-slate-400">
              <label class="flex items-center gap-2 cursor-pointer select-none">
                <input 
                  type="checkbox" 
                  name="rememberMe"
                  [(ngModel)]="rememberMe"
                  class="rounded border-slate-800 bg-slate-950 text-primary-blue focus:ring-primary-blue focus:ring-offset-slate-900"
                />
                <span>Se souvenir de moi</span>
              </label>
              <a href="javascript:void(0)" class="hover:text-gold transition-colors">Mot de passe oublié ?</a>
            </div>

            <!-- Login Button (StadiumBorder) -->
            <button 
              type="submit" 
              class="w-full rounded-full py-4 bg-gradient-to-r from-primary-blue via-primary-blue-dark to-indigo-700 text-white font-extrabold text-sm uppercase tracking-wider shadow-lg shadow-primary-blue/30 hover:shadow-xl hover:shadow-primary-blue/50 hover:scale-[1.01] transition-all duration-200 active:scale-[0.99] mt-2 flex items-center justify-center gap-2 cursor-pointer"
            >
              <span class="material-icons-round text-base">vpn_key</span>
              <span>Connexion</span>
            </button>
          </form>
        </div>
      </div>

      <!-- Language Selector (Bottom Left) -->
      <div class="absolute bottom-6 left-6 z-20">
        <button 
          (click)="toggleLangSelector()" 
          class="bg-slate-900 border border-slate-800 text-slate-300 hover:text-white rounded-full py-2 px-4 text-xs font-bold flex items-center gap-2 shadow-lg transition-colors cursor-pointer"
        >
          <span class="material-icons-round text-sm">language</span>
          <span>{{ selectedLanguage().native }}</span>
        </button>

        @if (showLangSelector()) {
          <div class="absolute bottom-10 left-0 bg-slate-900 border border-slate-800 rounded-2xl p-2 w-36 shadow-2xl flex flex-col gap-1 z-30 animate-fade-in">
            @for (lang of langOptions; track lang.code) {
              <button 
                (click)="selectLanguage(lang)" 
                class="w-full text-left rounded-xl py-2 px-3 hover:bg-slate-800 text-slate-400 hover:text-white font-bold text-xs transition-colors cursor-pointer flex items-center justify-between"
              >
                <span>{{ lang.native }}</span>
                <span class="text-[10px] text-slate-600 font-normal uppercase">{{ lang.code }}</span>
              </button>
            }
          </div>
        }
      </div>

      <!-- Security Badge (Bottom Right) -->
      <div class="absolute bottom-6 right-6 z-20 hidden sm:flex items-center gap-2 bg-slate-950/40 border border-white/5 rounded-full py-2 px-4 text-slate-500 text-[10px] font-bold uppercase tracking-wider">
        <span class="material-icons-round text-xs text-emerald-500 animate-pulse">verified_user</span>
        <span>Secure Session • AES 256</span>
      </div>
    </div>
  `,
  styles: [`
    :host {
      display: block;
    }
  `]
})
export class LoginComponent {
  private router = inject(Router);

  email = '';
  password = '';
  rememberMe = false;

  readonly showPassword = signal<boolean>(false);
  readonly showLangSelector = signal<boolean>(false);

  readonly langOptions = [
    { code: 'ar', native: 'عربية', latin: 'Arabic' },
    { code: 'fr', native: 'Français', latin: 'French' },
    { code: 'en', native: 'English', latin: 'English' }
  ];

  readonly selectedLanguage = signal(this.langOptions[1]); // French by default

  togglePasswordVisibility() {
    this.showPassword.update(v => !v);
  }

  toggleLangSelector() {
    this.showLangSelector.update(v => !v);
  }

  selectLanguage(lang: any) {
    this.selectedLanguage.set(lang);
    this.showLangSelector.set(false);
  }

  onSubmit() {
    // Navigate straight to SectorSelection Component
    this.router.navigate(['/sector']);
  }
}
