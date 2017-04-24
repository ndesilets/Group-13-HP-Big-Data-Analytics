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
            //process.exit(1);
        }else{
            console.log('oradb: Connection successful.');
            db = connection;
        }
    }
);

// --- Private functions

function releaseConnection(){
    db.close((err) => {
        if(err){
            console.error(err.message);
        }
    });
}

// Used to modularize code below
function pushQuery(query, fn){
    fn.push((next) => {
        db.execute(query, (err, result) => {
            if(err){
                console.error(err);
                next(err, null);
            }else{
                // Don't return a table 
                // e.g. executing ALTER SYSTEM etc... don't need results
                next(null, null);
            }
        });
    })
}

function pushTable(query, fn, name = 'unknown'){
    fn.push((next) => {
        db.execute(query, (err, result) => {
            if(err){
                console.error(err);
                next(err, null);
            }else{
                // Return named table
                next(null, {type: 'table', name: name, data: result});
            }
        });
    })
}

function pushGraph(query, fn, name = 'unknown'){
    fn.push((next) => {
        db.execute(query, (err, result) => {
            if(err){
                console.error(err);
                next(err, null);
            }else{
                // Return named table
                next(null, {type: 'graph', name: name, data: result});
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

// --- Public functions

module.exports = {
    execQuery: (query, options, trace) => {
        console.log(query);

        // Holds query functions to be executed
        let fn = [];

        /* --- User query --- */

        // TEMP Strip trailing ; from query because oracledb 
        // will reject it if it's there
        if(query[query.length - 1] == ";"){
            query = query.slice(0, -1);
        }

        // Add unique identifier to user query hint
        const hash = crypto.createHash('md5');
        hash.update(query);
        let id = hash.digest('hex');
        query += ` /*+ MONITOR ${id} */`; 

        /* --- Trace options --- */

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
                pushQuery(trace[i], fn);
            }

            // Execute trace footer
            console.log(trace[5]);
            pushQuery(trace[5],fn);
            
            // Update to recent trace file         
            if(isSubstr(trace[0], "10053")){
                console.log("== test passed");
                db.execute(
                 "begin Alter_ExtTab(:tableName); END;",
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
            pushQuery(trace[6],fn);
        }

        /* --- Profiling options --- */
  
        // Eval query options
        for(let key in options){
            let enabled = options[key];

            // Add option functions to async function stack
            if(enabled){
                switch(key){
                    case 'pei':
                        let query = PEI(id);
                        pushTable(query, fn, 'PEI');
                        break;
                    default:
                        console.log('Invalid option');
                }
            }
        }

        // Lastly, push user query
        console.log(query);
        pushTable(query, fn, 'User Query');

        return new Promise((resolve, reject) => {
            // Execute array of functions and return results
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