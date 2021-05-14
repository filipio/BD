import { Injectable } from '@angular/core';
import { BehaviorSubject} from 'rxjs';


@Injectable({
  providedIn: 'root'
})
export class DataService {
    private itemSource = new BehaviorSubject<number>(-1);
    currentItem = this.itemSource.asObservable();

    

  constructor() { }

  changeMessage(id : number){
    this.itemSource.next(id);
  }
}
