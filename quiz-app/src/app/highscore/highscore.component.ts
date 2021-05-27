import { Component, OnInit } from '@angular/core';
import { DataService } from '../services/data.service';
import { DbService } from '../services/db.service';

@Component({
  selector: 'app-highscore',
  templateUrl: './highscore.component.html',
  styleUrls: ['./highscore.component.css']
})
export class HighscoreComponent implements OnInit {

  quizID: any;
  quizParticipants: any;

  constructor(private db : DbService, private dataService : DataService ) 
  { 
    this.trySetupQuizID(11);
    //this.dataService.currentQuiz.subscribe(quizID => this.trySetupQuizID(quizID)); 

  }

  trySetupQuizID(quizID : number){
    if(quizID > 0){
        this.quizID = quizID;
        this.db.getQuizParticipants(this.quizID).subscribe(highscore => this.quizParticipants = highscore);
    }
  }


  ngOnInit(): void {
  }

}
