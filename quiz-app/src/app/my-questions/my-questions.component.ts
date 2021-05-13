import { Component, OnInit } from '@angular/core';
import { DbServiceService } from '../services/db-service.service';
import {FormControl, FormGroup} from "@angular/forms";
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-my-questions',
  templateUrl: './my-questions.component.html',
  styleUrls: ['./my-questions.component.css']
})
export class MyQuestionsComponent implements OnInit {

  questions: any
  user: any
  questionForm: FormGroup;

  constructor(private service : DbServiceService, private route: ActivatedRoute, private router: Router) 
  {
    this.router.routeReuseStrategy.shouldReuseRoute = () => false;
    this.questionForm = new FormGroup({
      sentence: new FormControl('Question'),
      correct: new FormControl('Correct answer'),
      answer1 : new FormControl("Incorrect answer"),
      answer2 : new FormControl("Incorrect answer"),
      answer3 : new FormControl("Incorrect answer"),

    });
  }


  ngOnInit(): void {
    this.user = this.service.getUser();
    this.service.getQuestions().subscribe(data => this.questions = data);
  }

  submit(): void {
    const form = this.questionForm.value;
    console.log(form.sentence);
    this.service.createQuestion(form.sentence, form.correct, form.answer1, form.answer2, form.answer3);
    this.router.navigate(['home']);
    //this.router.navigate(['myquestions']);
  }
}
