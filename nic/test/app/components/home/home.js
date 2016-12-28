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
                scope.query = 'SELECT * FROM CAPSTONE_DEMO.CAPSTONE_PARALLEL_TEST_V1;';
                scope.trace = '';
                scope.options = {};

                /* --- User actions --- */

                scope.submit = function(){
                 // if(scope.trace !== ''){
                 //        console.log("Trace query start"); 

                 //        // Consider how we can ensure uniqueness for tracefile_identifier 
                 //        scope.traceStart = "alter session set tracefile_identifier='TEST-" + scope.trace + "; alter session set timed_statistics = true; alter session set statistics_level=all; alter session set max_dump_file_size = unlimited; alter session set events '" + scope.trace + " trace name context forever,level 12';";

                 //        scope.traceEnd = "alter session set events '" + scope.trace + " trace name context off';";

                 //        for(var key in scope){
                 //            console.log('== key', key);
                 //            console.log('== value', scope[key]);
                 //        }
                 //        queryService.setQuery(scope.traceStart, scope.query, scope.traceEnd, scope.options);
                 //        $state.go('Results');
                 //     }
                 //     else{
                        queryService.setQuery(scope.query, scope.trace, scope.options);
                        $state.go('Results');
                     // }
                }
            }
        };
    });
})();