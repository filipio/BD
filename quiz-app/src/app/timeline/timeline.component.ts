import { Component, OnInit } from '@angular/core';
import { TimelineItem } from 'ngx-vertical-timeline';
@Component({
  selector: 'app-timeline',
  templateUrl: './timeline.component.html',
  styleUrls: ['./timeline.component.css']
})
export class TimelineComponent implements OnInit {

    externalVariable = 'hello';

    items: TimelineItem[] = [];
  constructor() { }

  ngOnInit(): void {   
    this.items.push({
        label: this.externalVariable,
        icon: 'fa fa-calendar-plus-o',
        styleClass: 'teste',
        content: `Lorem ipsum dolor sit amet, consectetur adipiscing elit,
        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.`,
        title: '18 de June, 2019, 10:12',
        command() {
          alert(`test: ${this.externalVariable}`);
        }
      });
   
      this.items.push({
        label: 'Action',
        // label: 'OtherAction',
        icon: 'fa fa-plus',
        styleClass: 'teste',
        content: `Ut enim ad minim veniam, quis nostrud exercitation ullamco
        laboris nisi ut aliquip ex ea commodo consequat.`,
        title: '11 de November, 2019, 12:00',
        command() {
          alert('Action!');
          console.log("action was called.");
        }
      });
  }

}
