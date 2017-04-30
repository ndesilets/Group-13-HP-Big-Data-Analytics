import { Component } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';

import { ExperimentService } from '../../services/experiment.service';

import 'rxjs/add/operator/switchMap';
import { Chart } from 'chart.js/dist/Chart.js';

@Component({
  selector: 'experiment',
  templateUrl: './experiment.component.html',
  styleUrls: ['./experiment.component.css'],
  providers: [
    ExperimentService
  ]
})
export class ExperimentComponent {
  private experiment: any = {};
  private sub: any;
  private chart: Chart;
  private ctx: any;

  constructor(private route: ActivatedRoute,
              private experimentService: ExperimentService){
    
  }

  ngOnInit(){
    this.sub = this.route.params.subscribe(params => {
      let id = params["id"];
      this.experiment = this.experimentService.getExperimentById(id);

      this.ctx = document.getElementById("dataChart");
      this.chart = new Chart(this.ctx, this.experiment.chart);
    });
  }
}
