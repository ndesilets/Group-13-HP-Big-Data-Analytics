import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';

import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { AppComponent } from './app.component';
import { ExperimentComponent } from './components/experiment/experiment.component';
import { ExperimentListComponent } from './components/experiment-list/experiment-list.component';
import { AppRoutingModule } from './routes.module';

import { ExperimentService } from './services/experiment.service';

import 'bootstrap/dist/css/bootstrap.css';
//import '../styles.css';

@NgModule({
  declarations: [
    AppComponent,
    ExperimentComponent,
    ExperimentListComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpModule,
    BrowserAnimationsModule,
    AppRoutingModule
  ],
  providers: [
    ExperimentService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
