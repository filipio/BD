import { HttpErrorResponse } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { DataService } from '../services/data.service';
import { DbServiceService } from '../services/db-service.service';

@Component({
  selector: 'app-class',
  templateUrl: './class.component.html',
  styleUrls: ['./class.component.css']
})
export class ClassComponent {

  user: any;
  classID: any;
  categories: any;
  cat_checked: number = 0;

  constructor(private service : DbServiceService, private dataService : DataService) {
    dataService.currentItem.subscribe(item => {this.classID = item; this.setup()});
   }

   setup(){
    if(this.classID && this.classID > 0){
        this.user = this.service.getUser();
        this.service.getCategories(this.classID)
        .subscribe(data => this.categories = data,
        (error : HttpErrorResponse) => {console.log(error)});
    }

   }
   moveToClass(index : number){
    this.cat_checked = this.categories[index].CategoryID;
    console.log("index is : ", index);
  }

}
