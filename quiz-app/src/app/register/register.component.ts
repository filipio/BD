import { Component, OnInit } from '@angular/core';
import {FormControl, FormGroup} from "@angular/forms";
import { Router } from '@angular/router';
import { DbService } from '../services/db.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {
    addForm: FormGroup;
    registered  = false;

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

  moveToLogin() : void{
      this.router.navigate(['login']);
  }

  onSubmit(): void {
    const form = this.addForm.value;
    this.service.register_user(form.email, form.password, form.name, form.lastname);
    this.registered = true;
  }
}
