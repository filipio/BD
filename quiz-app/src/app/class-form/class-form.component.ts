import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { DbServiceService } from '../services/db-service.service';

@Component({
  selector: 'app-class-form',
  templateUrl: './class-form.component.html',
  styleUrls: ['./class-form.component.css']
})
export class ClassFormComponent implements OnInit {

  createQuizForm: FormGroup;
  categoryID: any;

  constructor(private service : DbServiceService, private router: Router) {
    this.createQuizForm = new FormGroup({
      quiz_name: new FormControl('Question'),
      start_date: new FormControl('Correct answer'),
      end_date : new FormControl("Incorrect answer"),
      num_of_questions : new FormControl("Incorrect answer"),

    });
   }

  ngOnInit(): void {
    this.categoryID=1;
  }

  addQuestionToCategory(){
    
  }

  addQuiz(): void {
    const form = this.createQuizForm.value;
    console.log(form.sentence);
    this.service.createQuiz(this.categoryID ,form.quiz_name, form.start_date, form.end_date, form.num_of_questions);
  }

}
