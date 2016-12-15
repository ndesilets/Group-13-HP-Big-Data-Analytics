(function(){
    'use strict';
    angular.module('toolkit').directive('results', function($state, queryService){
        return{
            restrict: 'E',
            templateUrl: 'app/components/results/results.html',
            scope: {},
            link: function(scope){
                /* --- On page load --- */

                // Init vars
                scope.results = '';
                scope.loading = true;

                queryService.runQuery().then(function(results){
                    scope.results = results;
                    scope.loading = false;
                }, function(e){
                    console.error(e);
                    scope.loading = false;
                }, function(_){
                    scope.loading = false;
                });

                /* --- User actions --- */

            }
        };
    });
})();