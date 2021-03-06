import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HttpClientModule } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import {LoginComponent} from '../app/login/login.component';
import { RegisterComponent } from './register/register.component';
import { HomeComponent } from './home/home.component';
import { HeaderComponent } from './header/header.component';
import { MyQuestionsComponent } from './my-questions/my-questions.component';
import { DbService } from './services/db.service';
import { TimelineComponent } from './timeline/timeline.component';
import { NgxVerticalTimelineModule } from 'ngx-vertical-timeline';
import { QuizComponent } from './quiz/quiz.component';

import { ClassComponent } from './class/class.component';
import { ClassFormComponent } from './class-form/class-form.component';
import { DatePipe } from '@angular/common';
import { HighscoreComponent } from './highscore/highscore.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    RegisterComponent,
    HomeComponent,
    HeaderComponent,
    MyQuestionsComponent,
    TimelineComponent,
    QuizComponent,
    ClassComponent,
    ClassFormComponent,
    HighscoreComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    ReactiveFormsModule,
    FormsModule,
    NgxVerticalTimelineModule
  ],
  providers: [DbService, DatePipe],
  bootstrap: [AppComponent]
})
export class AppModule { }
