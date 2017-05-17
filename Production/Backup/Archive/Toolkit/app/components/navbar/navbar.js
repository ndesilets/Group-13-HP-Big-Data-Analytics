(function(){
    'use strict';
    angular.module('toolkit').directive('navbar', function($http){
        return{
            restrict: 'E',
            templateUrl: 'app/components/navbar/navbar.html',
            scope: {},
            link: function(scope){
                //
            }
        };
    });
})();