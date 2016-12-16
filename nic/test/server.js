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

    console.log(body);

    if(!body){
        res.sendStatus(400);
    }else{
        let query = body.query;
        let options = body.options;

        oradb.execQuery(query, options).then((result) => {
            res.send(result);
        }).catch((e) => {
            console.error(e);
            res.sendStatus(500);
        })
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