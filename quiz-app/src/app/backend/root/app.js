var express = require('express');
const bodyParser = require('body-parser');
const port = 3000;
var mysql = require('mysql')
var connection = mysql.createConnection({
    host: 'mysql.agh.edu.pl',
    user: 'karolzaj',
    password: 'c1KbMPKuLxMSdNdY',
    database: 'karolzaj'

})
var app = express();
// var router = express.Router();

connection.connect()

// router.get('/', (req, res) => {
//     connection.query('SELECT * FROM USERS', (err, rows, fields) => {
//         res.send(rows);
//     })
// })
app.use(bodyParser.json());
app.use(function (request, response, next) {
    response.header("Access-Control-Allow-Origin", "*");
    response.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
  });
  

app.get('/users', (req, res) => {
        connection.query('SELECT * FROM Users', (err, results) => {
            if(err) {
                console.error(err);
                res.status(500).json({status : 'error'});
            }
            else{
                res.status(200).json(results);
            }

        })
    })

// module.exports = app;
app.listen(port, () => {
    console.log(`App is listening on ${port}.`)
})

// connection.end()
