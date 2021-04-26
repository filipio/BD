import { Injectable } from '@angular/core';
import { HttpClient } from "@angular/common/http";

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
}
