import { Component, OnInit } from '@angular/core';
import { DbServiceService } from '../services/db-service.service';

@Component({
  selector: 'app-class',
  templateUrl: './class.component.html',
  styleUrls: ['./class.component.css']
})
export class ClassComponent implements OnInit {

  user: any;
  classID: any;
  categories: any;

  constructor(private service : DbServiceService) { }

  ngOnInit(): void {
    this.classID =2; 
    this.user = this.service.getUser();
    this.service.getCategories(this.classID).subscribe(data => this.categories = data);

  }

}
