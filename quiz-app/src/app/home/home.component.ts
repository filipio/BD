import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { DataService } from '../services/data.service';
import { DbService } from '../services/db.service';
import {Class} from '../model/Class';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

  constructor(private service : DbService, private router : Router, private dataService : DataService) { }

  classes: any
  ngOnInit(): void {
    this.service.getClasses().subscribe(data => this.classes = data);
  }

  moveToClass(index : number){
    const toLoadClass = this.classes[index];
    console.log("index is : ", index);
    this.router.navigate(['class', toLoadClass.Name]).then((fulfilled : boolean) => {
        console.log("navigating successfully.");
        this.dataService.changeClass(new Class(toLoadClass.ClassID, toLoadClass.Name, toLoadClass.ClassCode));
    })
  }
  
}
