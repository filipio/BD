import { Component, Input, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { TimelineItem } from 'ngx-vertical-timeline';
import { DataService } from '../services/data.service';
import { DbService } from '../services/db.service';
@Component({
  selector: 'app-timeline',
  templateUrl: './timeline.component.html',
  styleUrls: ['./timeline.component.css']
})
export class TimelineComponent implements OnInit {

    @Input() classID : number; 

    itemsCount = 5;
    items: TimelineItem[] = [];
    hello = "hello";
    userID : number;
    
    constructor(private db : DbService, private router : Router, private dataService : DataService) {
        this.userID = db.getUser().UserID;
    }
    

  ngOnInit(): void {   
    this.db.getQuizes(this.classID, this.itemsCount).subscribe(data => {
        this.setup(data);
    }, (err : any) => {console.log("received error in timeline component.")});
    }

    launchQuiz(quizID : number, quizName : string, router : Router, dataService : DataService){
        router.navigate(['quiz', quizName]).then((fulfilled : boolean) => {
            dataService.changeQuiz(quizID);
        })
    }

    showQuizData(quizID : number, quizName : string, router : Router, dataService : DataService){
        router.navigate(['quiz', quizName, 'score']).then((fulfilled : boolean) => {
            dataService.changeQuiz(quizID);
        })
    }

    addItem(users, item){
        const currDate = new Date();
        const router = this.router;
        const dataService = this.dataService;
        let startDate : Date = new Date(item.StartDate);
        let handler = this.showQuizData;
        let labelText = 'show data';
        let endDate : Date = new Date(item.EndDate);
        const quizAvailable : boolean = startDate <= currDate && currDate <= endDate;
        if((users.indexOf(this.userID) == -1) && quizAvailable ){
            handler = this.launchQuiz;
            labelText = 'join';
        }
        this.items.push({
            label : labelText,
            icon : 'fa fa-plus',
            styleClass : 'teste',
            title : item.QuizTitle,
            content : `${item.Categoryname}\nStart: ${startDate.toLocaleString()}\nEnd : ${endDate.toLocaleString()}`, 
            command(){
                handler(item.QuizID, item.QuizTitle, router, dataService);
            }
        })
    }

    setup(data){
        const quizes = data[0];
        let usersArr = [];
        let index = 0;
        
        while(index < quizes.length){
            const currItem = quizes[index];

            if(index && currItem.QuizID != quizes[index - 1].QuizID){
                const previousItem = quizes[index - 1];
                this.addItem(usersArr, previousItem);
                usersArr = [];
            }
            usersArr.push(currItem.UserID);
            index++;
        }
        this.addItem(usersArr, quizes[index - 1]);
        
    }

}
