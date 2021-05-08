import { Component, OnInit } from '@angular/core';
import { DbServiceService } from 'src/app/services/db-service.service';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css']
})
export class HeaderComponent implements OnInit {

  constructor(private service: DbServiceService) { }

  userInfo: any;
  ngOnInit(): void {

  }

  public isLoggedIn(): boolean {
    if(this.service.currUser!==undefined){
      this.userInfo = this.service.getUser();
      //console.log(this.userInfo);
      return true;
    } 
    else return false;
  }
  public logOut(){
    this.userInfo=undefined;
    this.service.currUser=undefined;
  }
}