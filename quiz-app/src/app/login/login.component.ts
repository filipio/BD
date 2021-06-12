import { HttpErrorResponse, HttpResponse } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import {FormControl, FormGroup} from "@angular/forms";
import { DbService } from '../services/db.service';
import {Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  addForm: FormGroup;
  loginFailed : boolean;

  constructor(private service : DbService, private router : Router) {
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

    this.service.currUserDataFlow.subscribe(data => {
            if(data.length != 0){
              this.loginFailed = false;
              this.router.navigate(['home']);
            }
            else this.loginFailed = true;
    }, (err : HttpErrorResponse) => {
        console.log("error with user ", err);
    })
  }
}
