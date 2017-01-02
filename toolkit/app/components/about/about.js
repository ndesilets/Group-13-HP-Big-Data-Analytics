(function(){
    'use strict';
    angular.module('toolkit').directive('about', function($http){
        return{
            restrict: 'E',
            templateUrl: 'app/components/about/about.html',
            scope: {},
            link: function(scope){
                //
            }
        };
    });
})();