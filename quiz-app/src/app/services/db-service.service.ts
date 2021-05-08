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

  constructor(private http : HttpClient) {

   }

   getUser(){
       return this.currUser;
   }

   getClasses()
   {
      return this.http.get(`${this.urlClasses}/${this.getUser()}`);
   }

   user_doLogin(email, password){
    this.currUserDataFlow = this.http.get(`${this.url}/${email}/${password}`);
    this.currUserDataFlow.subscribe(data => this.currUser = data, (err : HttpErrorResponse) => {
        console.log(err);
        this.currUser = undefined;
    })
   }

   register_user(email, password, name, lastname){
       console.log("user register")
    
    this.http.post(this.url, {email : email, password : password, firstname : name , lastname : lastname}).subscribe(data => console.log(data));
   }
}
