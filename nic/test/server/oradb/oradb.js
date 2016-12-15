'use strict';

const oracle = require('oracledb');
const config = require('./oradbconfig.js');
const async = require('async');
const crypto = require('crypto');

const PEI = require('./scripts/pei');

let db;

// --- Init 
oracle.getConnection(
    {
        user: config.username,
        password: config.password,
        connectString: config.connectString
    }, 
    (err, connection) => {
        if(err){
            console.error(err);
            process.exit(1);
        }else{
            console.log('oradb: Connection successful.');
            db = connection;
        }
    }
);

function releaseConnection(){
    db.close((err) => {
        if(err){
            console.error(err.message);
        }
    });
}

// SELECT SUM(MEASUREMENT) FROM CAPSTONE_PARALLEL_TEST_V1;

module.exports = {
    execQuery: (query, options) => {
        console.log(query);

        let fn = [];

        // Strip trailing ; because raisins
        if(query[query.length - 1] == ";"){
            query = query.slice(0, -1);
        }

        // Add unique identifier to query 
        const hash = crypto.createHash('md5');
        hash.update(query);
        let id = hash.digest('hex');
        query += ` /*+ MONITOR ${id} */`; 

        // Eval query options
        for(let key in options){
            let val = options[key];

            switch(key){
                case 'pei':
                    if(val){
                        fn.push((next) => {
                            let query = PEI.init(id);
                            db.execute(query, (err, result) => {
                                if(err){
                                    console.error(err);
                                    next(err, null);
                                }else{
                                    next(null, {'id': 'pei', data: result});
                                }
                            });
                        })
                    }
                    break;
                default:
                    console.log('Invalid option');
            }
        }

        fn.unshift((next) => {
            db.execute(query, (err, result) => {
                if(err){
                    console.error(err);
                    next(err, null);
                }else{
                    next(null, {'id': 'q', data: result});
                }
            });
        })

        return new Promise((resolve, reject) => {
            async.series(fn, (err, results) => {
                if(err){
                    reject(err);
                }else{
                    resolve(results);
                }
            })
        });
    }
};