import { Injectable } from '@angular/core';
import { HttpClient } from "@angular/common/http";
import {HttpParams} from "@angular/common/http";

@Injectable({
  providedIn: 'root'
})
export class DbServiceService {

    url = "http://localhost:3000/users";

  constructor(private http : HttpClient) {

   }

   getUsers(){
       return this.http.get(this.url);
   }

   user_doLogin(email, password){
    return this.http.get(this.url + '/' + email + '/' + password);

   }

   register_user(email, password, name, lastname){
       console.log("user register")
    
    this.http.post(this.url, {email : email, password : password, firstname : name , lastname : lastname}).subscribe(data => console.log(data));
   }
}
