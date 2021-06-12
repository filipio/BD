import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse } from "@angular/common/http";
import {HttpParams} from "@angular/common/http";
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class DbService {

    currUserDataFlow : any;
    currUser : any;

    url = "http://localhost:3000/users";
    urlClasses = "http://localhost:3000/classes";
    urlQuestions = "http://localhost:3000/questions";
    urlQuestionsSet = "http://localhost:3000/questionsSet";
    urlQuizes = "http://localhost:3000/quizes";
    urlCategories = "http://localhost:3000/categories";
    urlQuizParticipants = "http://localhost:3000/quizParticipants"
    
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
    this.currUserDataFlow.subscribe(data => {
        console.log(data);
        console.log("getting user data properly.\n");
         this.currUser = data;}, (err : HttpErrorResponse) => {
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

   getQuiz(quizID)
   {
      console.log("Trying to get quiz ", quizID);
      console.log(`${this.urlQuizes}/${quizID}`);
      return this.http.get(`${this.urlQuizes}/${quizID}`);
   }

   addQuizParticipant(quizID, score)
   {
      this.http.post(this.urlQuizParticipants, {quizID: quizID, userID: this.getUser().UserID, score: score}).subscribe(data => console.log(data), (error : HttpErrorResponse) => {console.log(error)});
   }
   getCategories(classID)
   {
     console.log("Trying to get categories for "+ classID);
     return this.http.get(`${this.urlCategories}/${classID}`);
   }

   createQuiz(categoryID,quiz_name, start_date, end_date, num_of_questions){
      console.log("Posting Quiz")
       return this.http.post(this.urlQuizes, {categoryID: categoryID, title: quiz_name, start: start_date, end: end_date, n_of_questions: num_of_questions});
   }

   getQuizes(classID, count){
       return this.http.get(`${this.urlQuizes}/?id=${classID}&count=${count}`);
   }

   postQuestionInCategory(questionID,categoryID){
      console.log("Posting Question In Category")
      return this.http.post(this.urlQuestionsSet, {questionID: questionID,categoryID: categoryID});
   }
   getQuizParticipants(quizID)
   {
     console.log("Trying to get quizParticipants for "+ quizID);
     return this.http.get(`${this.urlQuizParticipants}/${quizID}`);
   }

}
