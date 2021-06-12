import { Component, OnInit } from '@angular/core';
import { DbService } from 'src/app/services/db.service';
import {NgForm} from '@angular/forms';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css']
})
export class HeaderComponent implements OnInit {

  constructor(private service: DbService) { }

  userInfo: any;
  classCode: any;

  ngOnInit(): void {

  }

  public isLoggedIn(): boolean {
    if(this.service.currUser!==undefined){
      this.userInfo = this.service.getUser();
    } 
    return Boolean(this.userInfo);
  }
  public logOut(){
    this.userInfo=undefined;
    this.service.currUser=undefined;
  }

  joinClass(){
    console.log("joining " +this.classCode);
    this.service.joinClassByCode(this.classCode);
  }

}