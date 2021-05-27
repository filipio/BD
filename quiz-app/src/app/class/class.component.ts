import { HttpErrorResponse } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Class } from '../model/Class';
import { DataService } from '../services/data.service';
import { DbService } from '../services/db.service';

@Component({
  selector: 'app-class',
  templateUrl: './class.component.html',
  styleUrls: ['./class.component.css']
})
export class ClassComponent {

  user: any;
  classItem: Class;
  categories: any;
  cat_checked: number = 0;
  curr_index:number;
  receiveResetFromChild(){
    this.cat_checked=0;
  }

  constructor(private service : DbService, private dataService : DataService) {
    dataService.currentClass.subscribe(item => {this.classItem = item; this.setup()});
   }
   
   setup(){
    if(this.classItem && this.classItem.classID > 0){
        console.log(this.classItem);
        this.user = this.service.getUser();
        this.service.getCategories(this.classItem.classID)
        .subscribe(data => this.categories = data,
        (error : HttpErrorResponse) => {console.log(error)});
    }

   }
   moveToCategory(index : number){
    this.cat_checked = this.categories[index].CategoryID;
    this.curr_index=index;
    console.log("index is : ", index);
  }

}
