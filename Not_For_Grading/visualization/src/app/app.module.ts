import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';

import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { AppComponent } from './app.component';
import { ExperimentsComponent } from './components/experiments/experiments.component';
import { AbtcExperimentComponent } from './components/abtc-experiment/abtc-experiment.component';
import { ImcsExperimentComponent } from './components/imcs-experiment/imcs-experiment.component';
import { PgaExperimentComponent } from './components/pga-experiment/pga-experiment.component';
import { RamdiskExperimentComponent } from './components/ramdisk-experiment/ramdisk-experiment.component';
import { StatementQueuingComponent} from './components/statement-queuing/statement-queuing.component';
import { IndexPartitionComponent } from './components/index-partition/index-partition.component';
import { AppRoutingModule } from './routes.module';

import 'bootstrap/dist/css/bootstrap.css';
//import '../styles.css';

@NgModule({
  declarations: [
    AppComponent,
    ExperimentsComponent,
    AbtcExperimentComponent,
    ImcsExperimentComponent,
    PgaExperimentComponent,
    RamdiskExperimentComponent,
	StatementQueuingComponent,
	IndexPartitionComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpModule,
    BrowserAnimationsModule,
    AppRoutingModule
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
