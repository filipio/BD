import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
<<<<<<< HEAD
import { DataService } from '../services/data.service';
=======
>>>>>>> 40ab3e9f150e2e86c481d38bc12ea9fec80cc429
import { DbServiceService } from '../services/db-service.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

  constructor(private service : DbServiceService, private router : Router, private dataService : DataService) { }

  classes: any
  ngOnInit(): void {
    this.service.getClasses().subscribe(data => this.classes = data);
  }

  moveToClass(index : number){
    const toLoadClass = this.classes[index];
    this.router.navigate(['class', toLoadClass.Name]).then((fulfilled : boolean) => {
        console.log("navigating successfully.");
        this.dataService.emitter.emit(toLoadClass.ClassID);
    })
  }
  
}
