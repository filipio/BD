import { Component, OnInit } from '@angular/core';
import { DbService } from '../services/db.service';
import {FormControl, FormGroup} from "@angular/forms";
import { ActivatedRoute, Router } from '@angular/router';
import {mergeMap} from 'rxjs/operators';
import {Alert} from '../model/Alert';
@Component({
  selector: 'app-my-questions',
  templateUrl: './my-questions.component.html',
  styleUrls: ['./my-questions.component.css']
})
export class MyQuestionsComponent implements OnInit {

  alert: Alert;
  questions: any
  user: any
  questionForm: FormGroup;

  constructor(private service : DbService, private route: ActivatedRoute, private router: Router) 
  {
    this.router.routeReuseStrategy.shouldReuseRoute = () => false;
    this.questionForm = new FormGroup({
      sentence: new FormControl(''),
      correct: new FormControl(''),
      answer1 : new FormControl(""),
      answer2 : new FormControl(""),
      answer3 : new FormControl(""),

    });
  }


  ngOnInit(): void {
    this.user = this.service.getUser();
    this.service.getQuestions().subscribe(data => this.questions = data);
  }

  submit(): void {
    const form = this.questionForm.value;
    console.log(form.sentence);
    this.service.createQuestion(form.sentence, form.correct, form.answer1, form.answer2, form.answer3)
    .pipe(mergeMap((response) => {
        console.log(response);
        return this.service.getQuestions();
    }))
    .subscribe((updatedQuestions)=> {this.questions = updatedQuestions; this.confirmCreatingQuestion("ok")}, err => this.confirmCreatingQuestion("err"));
  }

  confirmCreatingQuestion(status){
    if(status == "err"){
      this.alert = new Alert;
      this.alert.type="danger";
      this.alert.message ="Question could not be created !";
      console.log(this.alert);
    }
    else{
      this.alert = new Alert;
      this.alert.type="success";
      this.alert.message ="Question has been created and added to your questions!";
      console.log(this.alert);
    }
  }

  close(){
    this.alert = undefined;
  }
}
