import { Component } from '@angular/core';

@Component({
  selector: 'experiments',
  templateUrl: './experiments.component.html',
  styleUrls: ['./experiments.component.css'],
})
export class ExperimentsComponent {
  private experiments: [any] = [
    {
      name: 'Automatic Big Table Caching',
      route: 'abtc-experiment'
    },
    {
      name: 'In-Memory Column Store',
      route: 'imcs-experiment'
    },
    {
      name: 'PGA Size',
      route: 'pga-experiment'
    },
    {
      name: 'Temp Table Ramdisk',
      route: 'ramdisk'
    }
  ];
  
  constructor(){
    
  }

  ngOnInit(){
    
  }
}
