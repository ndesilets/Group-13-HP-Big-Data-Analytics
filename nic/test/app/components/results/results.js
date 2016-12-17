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
                scope.error = false;
                scope.tables = {};
                scope.options = {};

                queryService.runQuery().then(function(results){
                    console.log(results);
                    scope.results = results;

                    scope.tables = parseTables(results);
                    scope.loading = false;
                }, function(e){
                    console.error(e);
                    scope.error = true;
                    scope.loading = false;
                });

                /* --- Util --- */

                // Format table results as an object rather than an array
                // [{id: 'q', data: {...}}] -> {q: {headers: [], rows: []}}
                function parseTables(results){
                    var parsed = {};

                    // For each table received
                    for(var i in results){
                        var table = results[i];
                        var tableName = table.id;
                        var tableData = table.data;

                        // Setup table header
                        var headers = []; 
                        var metadata = tableData.metaData;
                        for(var key in metadata){
                            var colname = metadata[key].name;
                            headers.push(colname);
                        }

                        // Setup table rows 
                        var rows = [];
                        for(var i in tableData.rows){
                            var row = tableData.rows[i];
                            rows.push(row);
                        }

                        parsed[tableName] = {
                            headers: headers,
                            rows: rows
                        };

                        switch(tableName){
                            case 'pei':
                                scope.options.pei = true;
                                break;
                            default:
                                break;
                        }
                    }

                    console.log(parsed);
                    return parsed;
                }
            }
        };
    });
})();