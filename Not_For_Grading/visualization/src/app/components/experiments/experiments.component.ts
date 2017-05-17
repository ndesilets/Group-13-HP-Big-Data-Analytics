import { Component } from '@angular/core';

@Component({
  selector: 'experiments',
  templateUrl: './experiments.component.html',
  styleUrls: ['./experiments.component.css'],
})
export class ExperimentsComponent {
  private experiments: [any] = [
	{
      name: 'PGA Size',
      route: 'pga-experiment'
    },
    {
      name: 'Automatic Big Table Caching',
      route: 'abtc-experiment'
    },
    {
      name: 'In-Memory Column Store',
      route: 'imcs-experiment'
    },
	{
      name: 'Statement Queuing',
      route: 'statement-queuing'
    },
    {
      name: 'Temporary Tablespace Ramdisk',
      route: 'ramdisk'
    }
	];
  
  constructor(){
    
  }

  ngOnInit(){
    
  }
}
