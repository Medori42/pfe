import { Routes } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { SectorSelectionComponent } from './sector-selection/sector-selection.component';
import { RoadmapComponent } from './roadmap/roadmap.component';
import { ModuleIntroComponent } from './module-intro/module-intro.component';
import { LessonComponent } from './lesson/lesson.component';
import { QuizComponent } from './quiz/quiz.component';
import { ProfileComponent } from './profile/profile.component';
import { ChatbotComponent } from './chatbot/chatbot.component';

export const routes: Routes = [
  { path: 'login', component: LoginComponent },
  { path: 'sector', component: SectorSelectionComponent },
  { path: 'roadmap', component: RoadmapComponent },
  { path: 'module-intro', component: ModuleIntroComponent },
  { path: 'lesson', component: LessonComponent },
  { path: 'quiz', component: QuizComponent },
  { path: 'profile', component: ProfileComponent },
  { path: 'chatbot', component: ChatbotComponent },
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: '**', redirectTo: 'login' }
];
