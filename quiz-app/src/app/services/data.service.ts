import { Injectable } from '@angular/core';
import * as EventEmitter from 'node:events';

@Injectable({
  providedIn: 'root'
})
export class DataService {

    emitter : EventEmitter = new EventEmitter();

  constructor() { }
}
