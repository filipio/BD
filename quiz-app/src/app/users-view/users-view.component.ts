import { Component, OnInit } from '@angular/core';
import {DbServiceService} from '../services/db-service.service';
@Component({
  selector: 'app-users-view',
  templateUrl: './users-view.component.html',
  styleUrls: ['./users-view.component.css']
})
export class UsersViewComponent implements OnInit {

    users : any;

  constructor(private service : DbServiceService ) { }

  ngOnInit(): void {
      this.service.getUsers().subscribe(data => this.users = data);
  }

}
