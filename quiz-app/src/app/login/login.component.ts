import { Component, OnInit } from '@angular/core';
import {FormControl, FormGroup} from "@angular/forms";
import { DbServiceService } from '../services/db-service.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  addForm: FormGroup;
//   info : any = undefined;

  constructor(public service : DbServiceService) {
    this.addForm = new FormGroup({
      email: new FormControl('Adres email'),
      password: new FormControl('Twoje hasło'),
      name : new FormControl("Twoje imie"),
      lastname : new FormControl("Twoje nazwisko")
    });
  }

  ngOnInit(): void {
  }

  onSubmit(): void {
    const form = this.addForm.value;
    this.service.register_user(form.email, form.password, form.name, form.lastname);
    // this.service.user_doLogin(form.email, form.password).subscribe(data => {this.info = data;
        // console.log(this.info);
    // });
  }



}
