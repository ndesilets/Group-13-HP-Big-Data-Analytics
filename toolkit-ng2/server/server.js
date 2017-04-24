'use strict';

const path = require('path');
const express = require('express');
const bodyParser = require('body-parser');
const morgan = require('morgan');

const oradb = require('./oradb/oradb.js');

/******************************************************************************
 * Express config
 ******************************************************************************/

const PORT = 3000;
const DIST = path.resolve(__dirname, '../client/dist');

let app = express();
app.use(morgan('dev'));
app.use('/', express.static(DIST));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

/******************************************************************************
 * API Routes
 ******************************************************************************/

app.post('/api/query', (req, res) => {
    let body = req.body;

    // Prevent response timeout for
    // long running queries
    res.connection.setTimeout(0);

    if(!body){
        res.sendStatus(400);
    }else{

        let query = body.query;
        let options = body.options;
        
        if(body.trace !== ''){
            let trace = [];

            // Consider changing logic to expose the hash id from oradb.js as test identifier
            trace.push('alter session set tracefile_identifier="APP-' + body.trace + '"');
            trace.push("alter session set timed_statistics = true");
            trace.push("alter session set statistics_level=all");
            trace.push("alter session set max_dump_file_size = unlimited");
            trace.push("alter session set events '" + body.trace + " trace name context forever, level 12'");
            trace.push("alter session set events '" + body.trace + " trace name context off'");

            // Trying to implement routing for 10053 case
            if(body.trace === '10053'){
                // Query external table
                trace.push("select * from ten053_xt");
            }else{
                trace.push("select text from tkprof_xt");
            }

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
    res.sendFile(`${DIST}/index.html`);
});

/******************************************************************************
 * Start
 ******************************************************************************/

app.listen(PORT, () => {
    console.log(`Listening on port: ${PORT}`);
});