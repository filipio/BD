import { Component, OnInit } from '@angular/core';
import { DbService } from '../services/db.service';
import {FormControl, FormGroup} from "@angular/forms";
import { DataService } from '../services/data.service';

@Component({
  selector: 'app-quiz',
  templateUrl: './quiz.component.html',
  styleUrls: ['./quiz.component.css']
})
export class QuizComponent {
  finished: any;
  quizID: any;
  quiz: any;
  idn: any;
  score: any;
  answer1: any;
  answer2: any;
  answer3: any;
  answer4: any;

  constructor(private db : DbService, private dataService : DataService ) 
  {
      this.dataService.currentQuiz.subscribe(quizID => this.trySetupQuiz(quizID)); 
    this.finished = false;
    this.idn = 0;
    this.score = 0;
  }

  trySetupQuiz(quizID : number){
    if(quizID > 0){
        this.quizID = quizID;
        this.setupQuiz();
    }
  }

  setupQuiz(){
    this.db.getQuiz(this.quizID).subscribe(data => 
        { this.quiz = data;
          this.answer1 = this.quiz[this.idn].answers[0];
          this.answer2 = this.quiz[this.idn].answers[1];
          this.answer3 = this.quiz[this.idn].answers[2];
          this.answer4 = this.quiz[this.idn].answers[3];
        });
  }

  getAnswer(num)
  {
    return this.quiz[this.idn].answers[num].Sentence;
  }

  submit(num)
  {
    if(this.quiz[this.idn].answers[num].IsCorrect)
    {
      this.score++;
    }
    this.idn++;

    if(this.idn == this.quiz.length)
    {
      this.finished = true;
      this.db.addQuizParticipant(this.quizID, this.score);
      return;
    }

    this.answer1 = this.quiz[this.idn].answers[0];
    this.answer2 = this.quiz[this.idn].answers[1];
    this.answer3 = this.quiz[this.idn].answers[2];
    this.answer4 = this.quiz[this.idn].answers[3];


  }

}
