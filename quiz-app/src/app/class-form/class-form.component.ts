import { Component, Input, OnInit } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { DbServiceService } from '../services/db-service.service';

import { Pipe, PipeTransform } from '@angular/core';
import { DatePipe } from '@angular/common';



@Component({
  selector: 'app-class-form',
  templateUrl: './class-form.component.html',
  styleUrls: ['./class-form.component.css'],
  providers: [DatePipe]
})


export class ClassFormComponent implements OnInit {
  @Input() currCategory : number;

  createQuizForm: FormGroup;

  constructor(private service : DbServiceService, private router: Router,private datePipe: DatePipe) {
    this.createQuizForm = new FormGroup({
      quiz_name: new FormControl('Question'),
      start_date: new FormControl('Correct answer'),
      end_date : new FormControl("Incorrect answer"),
      num_of_questions : new FormControl("Incorrect answer"),

    });
   }

  ngOnInit(): void {
    
  }

  addQuestionToCategory(){

  }

  addQuiz(): void {
    const form = this.createQuizForm.value;
    let s: Date = new Date(form.start_date);
    let e: Date = new Date(form.end_date);
    this.service.createQuiz(this.currCategory ,form.quiz_name, this.datePipe.transform(s,'yyyy-MM-dd HH:mm:ss'), this.datePipe.transform(e,'yyyy-MM-dd HH:mm:ss'), form.num_of_questions);
  }

}
