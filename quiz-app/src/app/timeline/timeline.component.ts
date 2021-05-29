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
    
    constructor(private db : DbService, private router : Router, private dataService : DataService) {}
    

  ngOnInit(): void {   
    console.log("class id is : ", this.classID);
    this.db.getQuizes(this.classID, this.itemsCount).subscribe(data => {
        this.setup(data);
    }, (err : any) => {console.log("received error in timeline component.")});
    }

    launchQuiz(quizID : number, quizName : string, router : Router, dataService : DataService){
        console.log(`going to quiz ${quizID} : ${quizName} !`);
        router.navigate(['quiz', quizName]).then((fulfilled : boolean) => {
            console.log("navigating successfully.");
            dataService.changeQuiz(quizID);
        })
    }

    showQuizData(quizID : number, quizName : string, router : Router, dataService : DataService){
        console.log(`showing quiz ${quizID} data!`);
        router.navigate(['quiz', quizName, 'score']).then((fulfilled : boolean) => {
            console.log("navigating to highscores successfully.");
            dataService.changeQuiz(quizID);
        })
    }

    setup(data){
        let index = data.length-1;
        const currDate = new Date();
        const router = this.router;
        const dataService = this.dataService;
        while(index >= 0){
            const currItem = data[index];
            let startDate : Date = new Date(currItem.StartDate);
            let endDate : Date = new Date(currItem.EndDate);
            const isJoinable = startDate <= currDate && currDate <= endDate;
            let handler = this.showQuizData;
            let labelText = 'show data';
            if(isJoinable){
                handler = this.launchQuiz;
                labelText = 'join';
            }
            this.items.push({
                label : labelText,
                icon: 'fa fa-plus',
                styleClass : 'teste',
                title: currItem.QuizTitle,
                content : `${currItem.Categoryname}\nStart: ${startDate.toLocaleString()}\nEnd : ${endDate.toLocaleString()}`, 
                command(){
                    handler(currItem.QuizID, currItem.QuizTitle, router, dataService);
                }
            })
            index--;
        }
    }

}
