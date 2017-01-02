const oracle = require('oracledb');
const config = require('./oradbconfig.js');

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