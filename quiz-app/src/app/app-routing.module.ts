import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { LoginComponent } from './login/login.component';
import { RegisterComponent } from './register/register.component';
import { MyQuestionsComponent } from './my-questions/my-questions.component';

const routes: Routes = [
    {path : '', redirectTo : '/login', pathMatch : 'full'},
    {path : 'home', component : HomeComponent},
    {path : 'register', component: RegisterComponent},
    {path : 'login', component : LoginComponent},
    {path : 'myquestions', component : MyQuestionsComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
