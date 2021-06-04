var mysql = require('mysql');

var connection = mysql.createConnection({
    host: 'mysql.agh.edu.pl',
    user: 'karolzaj',
    password: 'c1KbMPKuLxMSdNdY',
    database: 'karolzaj',
    multipleStatements: true

})
connection.connect()

module.exports = connection;