import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { LoginComponent } from './login/login.component';
import { RegisterComponent } from './register/register.component';
import { MyQuestionsComponent } from './my-questions/my-questions.component';
import { TimelineComponent } from './timeline/timeline.component';
import { QuizComponent } from './quiz/quiz.component';
import { ClassComponent } from './class/class.component';
import { HighscoreComponent } from './highscore/highscore.component';

const routes: Routes = [
    {path : '', redirectTo : '/login', pathMatch : 'full'},
    {path : 'home', component : HomeComponent},
    {path : 'register', component: RegisterComponent},
    {path : 'login', component : LoginComponent},
    {path : 'myquestions', component : MyQuestionsComponent},
    {path : 'timeline', component : TimelineComponent},
    {path : 'quiz/:quizName', component : QuizComponent},
    {path : 'quiz/:quizName/score', component : HighscoreComponent},
    {path : 'class', component: ClassComponent},
    {path : 'class/:className', component : ClassComponent},
    {path : 'highscore', component : HighscoreComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
