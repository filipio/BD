import { Injectable } from '@angular/core';
import { BehaviorSubject} from 'rxjs';
import {Class} from '../model/Class';


@Injectable({
  providedIn: 'root'
})
export class DataService {
    private itemSource = new BehaviorSubject<Class>(new Class(-1, "", ""));
    currentItem = this.itemSource.asObservable();

    

  constructor() { }

  changeMessage(classObject : Class){
    this.itemSource.next(classObject);
  }
}
