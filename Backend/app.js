

var express = require('express');
const classes = require('./routes/classes');
const users = require("./routes/users");
const questions = require("./routes/questions");
const quizes = require("./routes/quizes");
const connection = require('./dbConnection');
const quizParticipants = require('./routes/quizParticipants');
const http = require('http');

const port = process.env.PORT || '3000';
var app = express();

app.set('port', port);




app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(function (request, response, next) {
    response.header("Access-Control-Allow-Origin", "*");
    response.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
  });

app.use('/classes', classes);
app.use('/users', users);
app.use('/questions', questions);
app.use('/quizes', quizes);
app.use('/quizParticipants', quizParticipants);




app.get('/categories/:classID', (req, res) => {
    var classID = req.params.classID;
    connection.query('SELECT * FROM Category WHERE ClassID = ?',[classID],
     (err, results) => {
        if(err) {
            console.error(err);
            res.status(500).json({error : 'database-error occured when getting categories of a class : ' + err.message});
        }
        else{
            res.status(200).json(results);
        }

    })
});


app.post('/questionsSet', function(req, res) {
    connection.query('CALL addQuestionToCategory(?,?)', [req.body.questionID, req.body.categoryID], (err, results ) => {
        if(err) {
            console.error(err);
            res.status(500).json({error : 'error during posting question in category : ' + err.message});
        }
        else{
            res.status(200).json(results);
        }
    })
});


const server = http.createServer(app);
server.listen(port, () => {
    console.log(`App is listening on ${port}.`)
})