(function(){
    'use strict';
    angular.module('toolkit').directive('home', function($state, queryService){
        return{
            restrict: 'E',
            templateUrl: 'app/components/home/home.html',
            scope: {},
            link: function(scope){
                /* --- On page load --- */

                // Init vars 
                scope.query = 'SELECT * FROM CAPSTONE_PARALLEL_TEST_V1;';
                scope.trace = '';
                scope.options = {};

                /* --- User actions --- */

                scope.submit = function(){
                    queryService.setQuery(scope.query, scope.trace, scope.options);
                    $state.go('Results');
                }
            }
        };
    });
})();