(function(){
    'use strict';
    angular.module('toolkit', ['ui.router'])
        .run(function(){

        })
        .config(function($stateProvider, $urlRouterProvider, $locationProvider){
            $locationProvider.html5Mode(true);

            $stateProvider
                .state('Home', {
                    url: '/',
                    template: '<home></home>'
                })
                .state('Results', {
                    url: '/results',
                    template: '<results></results>'
                })
                .state('About', {
                    url: '/about',
                    template: '<about></about>'
                });

            // Default
            $urlRouterProvider.otherwise('/');
        });
})();