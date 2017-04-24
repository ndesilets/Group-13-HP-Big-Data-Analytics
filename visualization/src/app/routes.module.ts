import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { ExperimentComponent } from './components/experiment/experiment.component';
import { ExperimentListComponent } from './components/experiment-list/experiment-list.component';

const routes: Routes = [
  { path : 'experiments', component: ExperimentListComponent },
  { path : 'experiment/:id', component: ExperimentComponent },
  { path : '', redirectTo: '/experiments', pathMatch: 'full' }
];

@NgModule({
  imports: [
    RouterModule.forRoot(routes)
  ],
  exports: [
    RouterModule
  ]
})
export class AppRoutingModule {}
