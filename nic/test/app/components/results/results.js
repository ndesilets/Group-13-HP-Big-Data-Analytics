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

                queryService.runQuery().then(function(results){
                    scope.results = results;
                    console.log(results);
                    var parsed = parseTable(results);
                    scope.header = parsed.headers;
                    scope.rows = parsed.rows;

                    scope.loading = false;
                }, function(e){
                    console.error(e);
                    scope.loading = false;
                    scope.error = true;
                });

                /* --- Util --- */

                // Format results to be more table friendly
                function parseTable(results){
                    var out = {
                        headers: [],
                        rows: []
                    };

                    for(var i in results){
                        var table = results[i];
                        var tableName = table.id;
                        var tableData = table.data;

                        if(tableName == 'q'){
                            // Setup header
                            var headers = []; 
                            var metadata = tableData.metaData;
                            for(var key in metadata){
                                var colname = metadata[key].name;
                                headers.push(colname);
                            }

                            // Setup rows 
                            var rows = [];
                            for(var i in tableData.rows){
                                var row = tableData.rows[i];
                                var newRow = [];

                                for(var j in row){
                                    newRow.push(row[j]);
                                }

                                rows.push(newRow);
                            }

                            out.headers = headers;
                            out.rows = rows;

                            console.log(out);
                        }
                    }

                    return out;
                }
            }
        };
    });
})();