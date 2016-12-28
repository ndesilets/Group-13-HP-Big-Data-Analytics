'use strict';

const express = require('express');
const bodyParser = require('body-parser');
const morgan = require('morgan');

const oradb = require('./server/oradb/oradb.js');

/******************************************************************************
 * Express config
 ******************************************************************************/

const PORT = 3000;

let app = express();
app.use(morgan('dev'));
app.use('/app', express.static(__dirname + '/app'));
app.use('/npm', express.static(__dirname + '/node_modules'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

/******************************************************************************
 * API Routes
 ******************************************************************************/

app.post('/api/query', (req, res) => {
    let body = req.body;

    // console.log('\n== body\n',body);
    // console.log('\n== body.trace',body.trace);

    if(!body){
        res.sendStatus(400);
    }else{

        let query = body.query;
        let options = body.options;

        // TEMP Strip trailing ; because oracledb raisins
        if(query[query.length - 1] == ";"){
            query = query.slice(0, -1);
        }

        if(body.trace !== ''){
            let trace = [];

            // Consider changing logic to expose the hash id from oradb.js as test identifier
            trace.push('alter session set tracefile_identifier="TEST-' + body.trace + '"');
            trace.push("alter session set timed_statistics = true");
            trace.push("alter session set statistics_level=all");
            trace.push("alter session set max_dump_file_size = unlimited");
            trace.push('alter session set events "' + body.trace + ' trace name context forever, level 12"');

            // Issue with ;
            trace.push(query);

            trace.push('alter session set events "' + body.trace + ' trace name context off"');

            oradb.execQuery(query, options, trace).then((result) => {
                 res.send(result);
             }).catch((e) => {
                 console.error(e);
                 res.sendStatus(500);
             })
        }else{   

             oradb.execQuery(query, options).then((result) => {
                res.send(result);
            }).catch((e) => {
                console.error(e);
                res.sendStatus(500);
            })
        }
    }
});

// Default
app.all('*', (req, res) => {
    res.sendFile(__dirname + '/app/index.html');
});

/******************************************************************************
 * Start
 ******************************************************************************/

app.listen(PORT, () => {
    console.log(`Listening on port: ${PORT}`);
});