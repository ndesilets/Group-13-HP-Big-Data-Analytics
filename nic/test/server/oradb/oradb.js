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
    execQuery: (query, options, trace) => {
        console.log(query);

        let fn = [];

        // TEMP Strip trailing ; because oracledb raisins
        if(query[query.length - 1] == ";"){
            query = query.slice(0, -1);
        }

        // Add unique identifier to query 
        const hash = crypto.createHash('md5');
        hash.update(query);
        let id = hash.digest('hex');
        query += ` /*+ MONITOR ${id} */`; 

        // Check for trace args and wrap query
        if(trace){
            
            for(let i = 0; i<trace.length; i++){
                console.log("== trace[" + i + "]: " + trace[i]);
                //console.log("== typeof trace[i]: " + typeof String(i));
            }
        
            // Add trace and query to async function stack
            for(let i = 0; i<trace.length; i++){
            fn.push((next) => {
                    console.log('== trying trace[' + i + ']: ' + trace[i]);
                    db.execute(trace[i], (err, result) => {
                        if(err){
                            console.error(err);
                            next(err, null);
                        }else{
                            next(null, {'id': 'q', data: result});
                        }
                    });
                
                })
            }

        }else{ 
             // Add user query function to async function stack
            fn.push((next) => {
                db.execute(query, (err, result) => {
                    if(err){
                        console.error(err);
                        next(err, null);
                    }else{
                        next(null, {'id': 'q', data: result});
                    }
                });
            })
        }

  
        // Eval query options
        for(let key in options){
            let enabled = options[key];

            // Add option functions to async function stack
            switch(key){
                case 'pei':
                    if(enabled){
                        fn.push((next) => {
                            let query = PEI(id);
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