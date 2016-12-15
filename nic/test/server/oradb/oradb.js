'use strict';

const oracle = require('oracledb');
const config = require('./oradbconfig.js');

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

function releaseConnection(connection){
    db.close((err) => {
        if(err){
            console.error(err.message);
        }
    });
}

// SELECT SUM(MEASUREMENT) FROM CAPSTONE_PARALLEL_TEST_V1;

module.exports = {
    execQuery: (query) => {
        console.log(query);

        // Strip trailing ; because raisins
        if(query[query.length - 1] == ";"){
            query = query.slice(0, -1);
        }

        return new Promise((resolve, reject) => {
            db.execute(query, (err, result) => {
                if(err){
                    reject(err);
                }else{
                    console.log(result);
                    resolve(result);
                }
            });
        });
    }
};