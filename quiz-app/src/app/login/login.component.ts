import { HttpErrorResponse, HttpResponse } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import {FormControl, FormGroup} from "@angular/forms";
import { DbServiceService } from '../services/db-service.service';
import {Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  addForm: FormGroup;

  constructor(private service : DbServiceService, private router : Router) {
    this.addForm = new FormGroup({
      email: new FormControl('Adres email'),
      password: new FormControl('Twoje hasło'),
      name : new FormControl("Twoje imie"),
      lastname : new FormControl("Twoje nazwisko")
    });
  }

  ngOnInit(): void {
  }

  moveToRegister() : void{
      this.router.navigate(['register']);
  }

  userSubmit(): void {
    const form = this.addForm.value;
    this.service.user_doLogin(form.email, form.password);
    // if(this.service.getUser() !== undefined){
    //     console.log("user is ok.")
    //     this.router.navigate(['home']);
    // }
    this.service.currUserDataFlow.subscribe(data => {
            this.router.navigate(['home']);
    }, (err : HttpErrorResponse) => {
        console.log("error with user ", err);
    })
    // this.service.currUser.subscribe(data => this.router.navigate(['/home']), (err)

  }



}
