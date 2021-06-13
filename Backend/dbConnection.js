var mysql = require('mysql');

var connection = mysql.createConnection({
    host: 'database',
    user: 'root',
    password: 'secretPassword',
    database: 'quizDB',
    multipleStatements: true

})
connection.connect()


module.exports = connection;