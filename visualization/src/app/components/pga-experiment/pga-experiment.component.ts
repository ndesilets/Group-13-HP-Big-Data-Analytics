import { Component } from '@angular/core';

import { Chart } from 'chart.js/dist/Chart.js';

@Component({
  selector: 'pga-experiment',
  templateUrl: './pga-experiment.component.html',
  styleUrls: ['./pga-experiment.component.css']
})
export class PgaExperimentComponent {
  private experiment: any = {};
  private chart: Chart;
  private ctx: any;
  private data: {

  };

  constructor(){
    
  }

  ngOnInit(){
    this.ctx = document.getElementById("dataChart");
    this.chart = new Chart(this.ctx, this.experiment.chart);
  }
}
