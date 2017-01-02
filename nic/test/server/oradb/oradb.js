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

// Used to modularize code below
function executeQuery(query, fn){
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

function isSubstr(str, substr){
    console.log("== before conditional\n");
    if(str.indexOf(substr) !== -1){
        console.log("== returned true\n");
        return true;
    }  
    console.log("== returned false\n");
    return false;
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

        // Check for trace args, interate through 
        // trace head clauses, then execute query
        // and tail trace clause
        if(trace){
            
            for(let i = 0; i<trace.length; i++){
                console.log("== trace[" + i + "]: " + trace[i]);
            }

        
            // Execute trace header clauses
            for(let i = 0; i<=4; i++){
                console.log(trace[i]);
                executeQuery(trace[i],fn);
            }

            // Execute updated query
            console.log(query);
            executeQuery(query,fn);

            // Execute trace footer
            console.log(trace[5]);
            executeQuery(trace[5],fn);
            
            // Update to recent trace file         
            if(isSubstr(trace[0], "10053")){
                console.log("== test passed");
                db.execute(
                 "@Alter_ExtTab(:tableName);",
                 {  // Bind variables
                    tableName: "10053"
                 },
                 function(err, result){
                    if(err){
                        console.log(err.message);
                        return;
                    }
                    console.log("== result" + result);
                 });
                
            }

            // Query external table
            console.log(trace[6]);
            executeQuery(trace[6],fn);
        }else{ 
             // Add user query function to async function stack
            executeQuery(query,fn);
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