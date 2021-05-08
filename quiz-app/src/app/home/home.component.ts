import { Component, OnInit } from '@angular/core';
import { DbServiceService } from '../services/db-service.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

  constructor(private service : DbServiceService) { }

  classes: any
  ngOnInit(): void {
    this.service.getClasses().subscribe(data => this.classes = data);
  }

  
}
