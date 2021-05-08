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

connection.connect()

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(function (request, response, next) {
    response.header("Access-Control-Allow-Origin", "*");
    response.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
  });

  

app.get('/users/:email/:password', (req, res) => {
        var email = req.params.email;
        var password = req.params.password;
        connection.query('SELECT * FROM User WHERE Email = ? AND Password = ?',[email,password],
         (err, results) => {
            if(err) {
                console.log("error occured.");
                console.error(err);
                res.status(500).json({error : 'error'});
            }
            else{
                console.log("OK!");
                console.log(results);
                if(results.length  > 0 )
                    if(results)
                        res.status(200).json(results);
                    else
                        res.status(500).json({msg : 'error'});
                else{
                    res.status(500).json({error : 'error'});
                }
            }

        })
    })




    app.get('/classes/:userID', (req, res) => {
        var userID = req.params.userID;
        connection.query('SELECT * FROM Class INNER JOIN ClassParticipant ON Class.ClassID = ClassParticipant.ClassID AND ClassParticipant.UserID = ?',[userID],
         (err, results) => {
            if(err) {
                console.log("error occured.");
                console.error(err);
                res.status(500).json({error : 'error'});
            }
            else{
                console.log("OK!");
                console.log(results);
                if(results.length  > 0 )
                    if(results)
                        res.status(200).json(results);
                    else
                        res.status(500).json({msg : 'error'});
                else{
                    res.status(500).json({error : 'error'});
                }
            }

        })
    })


app.post('/users', function(req, res) {
    connection.query('CALL registerUser(?,?,?,?)', [req.body.firstname, req.body.lastname, req.body.email, req.body.password], (err, results ) => {
        console.log("name of the user" + req.body.firstname);
        if(err) {
            console.log("error occured.");
            console.error(err);
            res.status(500).json({status : 'error'});
        }
        else{
            console.log("registered!");
            res.status(200).json({status : 'ok!'});
        }
    })
});

app.listen(port, () => {
    console.log(`App is listening on ${port}.`)
})

