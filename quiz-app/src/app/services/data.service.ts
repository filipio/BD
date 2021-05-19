import { Injectable } from '@angular/core';
import { BehaviorSubject} from 'rxjs';
import {Class} from '../model/Class';


@Injectable({
  providedIn: 'root'
})
export class DataService {
    private classSource = new BehaviorSubject<Class>(new Class(-1, "", ""));
    private quizSource = new BehaviorSubject<number>(-1);
    currentClass = this.classSource.asObservable();
    currentQuiz = this.quizSource.asObservable();

    

  constructor() { }

  changeClass(classObject : Class){
    this.classSource.next(classObject);
  }

  changeQuiz(quizId : number){
      this.quizSource.next(quizId);
  }
}
