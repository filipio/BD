import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { LoginComponent } from './login/login.component';
import { RegisterComponent } from './register/register.component';
import { MyQuestionsComponent } from './my-questions/my-questions.component';
import { TimelineComponent } from './timeline/timeline.component';
<<<<<<< HEAD
import { QuizComponent } from './quiz/quiz.component';
=======
import { ClassComponent } from './class/class.component';
>>>>>>> a2c0f4b69ef04fe1f8e4cb1fac3a2a5d8a3c163f

const routes: Routes = [
    {path : '', redirectTo : '/login', pathMatch : 'full'},
    {path : 'home', component : HomeComponent},
    {path : 'register', component: RegisterComponent},
    {path : 'login', component : LoginComponent},
    {path : 'myquestions', component : MyQuestionsComponent},
    {path : 'timeline', component : TimelineComponent},
<<<<<<< HEAD
    {path : 'quiz', component : QuizComponent}
=======
    {path : 'class', component: ClassComponent},
    {path : 'class/:className', component : ClassComponent}
>>>>>>> a2c0f4b69ef04fe1f8e4cb1fac3a2a5d8a3c163f
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
