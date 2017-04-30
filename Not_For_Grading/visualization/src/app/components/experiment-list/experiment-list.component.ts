import { Component } from '@angular/core';
import { Router } from '@angular/router';

import { ExperimentService } from '../../services/experiment.service';

@Component({
  selector: 'experiment-list',
  templateUrl: './experiment-list.component.html',
  styleUrls: ['./experiment-list.component.css'],
  providers: [
    ExperimentService
  ]
})
export class ExperimentListComponent {
  private experiments: [any];
  
  constructor(private router: Router, 
              private experimentService: ExperimentService){
    
  }

  ngOnInit(){
    this.experiments = this.experimentService.getExperiments();
  }
}
