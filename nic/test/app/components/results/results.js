(function () {
    'use strict';
    angular.module('toolkit').directive('results', function ($state, queryService) {
        return {
            restrict: 'E',
            templateUrl: 'app/components/results/results.html',
            scope: {},
            link: function (scope) {
                /* --- On page load --- */

                // Init vars
                scope.loading = true;
                scope.error = false;

                // Dummy graph
                var ctx = document.getElementById("myChart");
                var myChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
                        datasets: [{
                            label: '# of Votes',
                            data: [12, 19, 3, 5, 2, 3],
                            backgroundColor: [
                                'rgba(255, 99, 132, 0.2)',
                                'rgba(54, 162, 235, 0.2)',
                                'rgba(255, 206, 86, 0.2)',
                                'rgba(75, 192, 192, 0.2)',
                                'rgba(153, 102, 255, 0.2)',
                                'rgba(255, 159, 64, 0.2)'
                            ],
                            borderColor: [
                                'rgba(255,99,132,1)',
                                'rgba(54, 162, 235, 1)',
                                'rgba(255, 206, 86, 1)',
                                'rgba(75, 192, 192, 1)',
                                'rgba(153, 102, 255, 1)',
                                'rgba(255, 159, 64, 1)'
                            ],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true
                                }
                            }]
                        }
                    }
                });

                queryService.runQuery().then(function(results){
                    console.log(results);
                    scope.results = results;
                }, function(e){
                    console.error(e);
                    scope.error = true;
                }).finally(function(){
                    scope.loading = false;
                    console.log(scope.loading);
                });

                /* --- Util --- */

                // Format table results as an object rather than an array
                // [{id: 'q', data: {...}}] -> {q: {headers: [], rows: []}}
                function parseTables(results) {
                    var parsed = {};

                    // For each table received
                    for (var i in results) {
                        var table = results[i];
                        var tableName = table.id;
                        var tableData = table.data;

                        // Setup table header
                        var headers = [];
                        var metadata = tableData.metaData;
                        for (var key in metadata) {
                            var colname = metadata[key].name;
                            headers.push(colname);
                        }

                        // Setup table rows 
                        var rows = [];
                        for (var i in tableData.rows) {
                            var row = tableData.rows[i];
                            rows.push(row);
                        }

                        parsed[tableName] = {
                            headers: headers,
                            rows: rows
                        };

                        switch (tableName) {
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