import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { DbServiceService } from '../services/db-service.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

  constructor(private service : DbServiceService, private router : Router) { }

  classes: any
  ngOnInit(): void {
    this.service.getClasses().subscribe(data => this.classes = data);
  }

  openClass(){
    this.router.navigate(['class']);
  }
  
}
