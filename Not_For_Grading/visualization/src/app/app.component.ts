import { Component } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  private homeUrl: string = "/experiments";
  private isHome: boolean = true;

  constructor(private router: Router){
    router.events.subscribe((ev) => {
      if(ev instanceof NavigationEnd){
        let url = ev.url || null;

        if(url && url != this.homeUrl){
          this.isHome = false;
        }else{
          this.isHome = true;
        }
      }
    });
  }

  private goBack(){
    window.history.back();
  }
}
