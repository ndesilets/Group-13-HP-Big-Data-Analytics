(function(){
    'use strict';
    angular.module('toolkit').factory('queryService', function($http, $q){
        var query = '';
        var trace = '';
        var options = {};

        return {
            setQuery: function(_query, _trace, _options){
                query = _query;
                trace = _trace;
                options = _options;
            },

            runQuery: function(){
                return $q(function(resolve, reject, notify){
                    var body = {
                        query: query,
                        trace: trace,
                        options: options
                    };

                    console.log(body);

                    $http.post('/api/query', body).then(function(res){
                        resolve(res.data);
                    }, function(e){
                        reject(e);
                    }, function(){
                        notify();
                    });
                });
            }
        };
    });
})();