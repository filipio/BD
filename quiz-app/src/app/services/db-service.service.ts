import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse } from "@angular/common/http";
import {HttpParams} from "@angular/common/http";
import { Observable } from 'rxjs';
import {User} from "../model/user";

@Injectable({
  providedIn: 'root'
})
export class DbServiceService {

    currUserDataFlow : any;
    currUser : any;

    url = "http://localhost:3000/users";
    urlClasses = "http://localhost:3000/classes";
    urlQuestions = "http://localhost:3000/questions";

  constructor(private http : HttpClient) {

   }

   getUser(){
       return this.currUser[0];
   }

   getClasses()
   {
      console.log(this.getUser().UserID);
      return this.http.get(`${this.urlClasses}/${this.getUser().UserID}`);
   }

   user_doLogin(email, password){

    this.currUserDataFlow = this.http.get(`${this.url}/${email}/${password}`);
    this.currUserDataFlow.subscribe(data => {console.log(data); this.currUser = data;}, (err : HttpErrorResponse) => {
        console.log(err);
        this.currUser = undefined;
    })
   }

   register_user(email, password, name, lastname){
       console.log("user register")
    
    this.http.post(this.url, {email : email, password : password, firstname : name , lastname : lastname}).subscribe(data => console.log(data));
   }

   getQuestions()
   {
     console.log("Trying to get question ", this.getUser());
    return this.http.get(`${this.urlQuestions}/${this.getUser().UserID}`);
   }

   createQuestion(sentence, correct, answer1, answer2, answer3)
   {
      return this.http.post(this.urlQuestions, {sentence: sentence, userID: this.getUser().UserID, correct: correct, answer1: answer1, answer2: answer2, answer3: answer3});
   };
   joinClassByCode(code)
   {
      console.log(this.getUser().UserID);
      this.http.post(this.urlClasses, {userID : this.getUser().UserID, classCode : code}).subscribe(data => console.log(data), (error : HttpErrorResponse) => {console.log(error)});
   }
}
