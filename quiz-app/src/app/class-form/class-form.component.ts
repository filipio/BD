import { Component, Input, OnInit } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { DbService } from '../services/db.service';
import {Alert} from '../model/Alert';
import { Pipe, PipeTransform } from '@angular/core';
import { DatePipe } from '@angular/common';
import { Output, EventEmitter } from '@angular/core';


@Component({
  selector: 'app-class-form',
  templateUrl: './class-form.component.html',
  styleUrls: ['./class-form.component.css'],
  providers: [DatePipe]
})


export class ClassFormComponent implements OnInit {

  quiz_alert: Alert;
  question_alert: Alert;
  questions: any;
  selectedQuestion: number;

  @Input() currCategory : number;
  @Input() categoryName : string;
  @Output() resetCategory = new EventEmitter<number>();
  resetCategoryChecked(){
    this.resetCategory.emit(0);
  }

  createQuizForm: FormGroup;

  constructor(private service : DbService, private router: Router,private datePipe: DatePipe) {
    this.createQuizForm = new FormGroup({
      quiz_name: new FormControl('Question'),
      start_date: new FormControl('Correct answer'),
      end_date : new FormControl("Incorrect answer"),
      num_of_questions : new FormControl("Incorrect answer"),

    });

   }

  ngOnInit(): void {
    this.service.getQuestions().subscribe(data => this.questions = data);
  }

  addQuestionToCategory(){
    console.log(this.selectedQuestion);
    this.service.postQuestionInCategory(this.selectedQuestion, this.currCategory).subscribe(data => this.confirmQuestionPosting("ok"), err => this.confirmQuestionPosting("err"));
  }

  confirmQuestionPosting(status){
    if(status == "ok"){
      this.question_alert = new Alert;
      this.question_alert.type="success";
      this.question_alert.message ="Question has been published successfully!";
      console.log(this.question_alert);
    }
    else{
      this.question_alert = new Alert;
      this.question_alert.type="danger";
      this.question_alert.message ="Question could not been published!";
      console.log(this.question_alert);
    }
  }

  addQuiz(): void {
    const form = this.createQuizForm.value;
    let s: Date = new Date(form.start_date);
    let e: Date = new Date(form.end_date);
    this.service.createQuiz(this.currCategory ,form.quiz_name, this.datePipe.transform(s,'yyyy-MM-dd HH:mm:ss'), this.datePipe.transform(e,'yyyy-MM-dd HH:mm:ss'), form.num_of_questions).subscribe(data => {
    }, err => this.confirmQuizPosting("err"));
  }

  confirmQuizPosting(status){
    if(status == "ok"){
      this.quiz_alert = new Alert;
      this.quiz_alert.type="success";
      this.quiz_alert.message ="Quiz has been published successfully!";
      console.log(this.quiz_alert);
    }
    else{
      this.quiz_alert = new Alert;
      this.quiz_alert.type="danger";
      this.quiz_alert.message ="Quiz could not be published !";
      console.log(this.quiz_alert);
    }
  }

  close() {
    this.quiz_alert = undefined;
    this.question_alert = undefined;
  }

}
