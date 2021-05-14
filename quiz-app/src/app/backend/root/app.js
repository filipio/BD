

var express = require('express');
const bodyParser = require('body-parser');
const port = 3000;
var mysql = require('mysql')
var connection = mysql.createConnection({
    host: 'mysql.agh.edu.pl',
    user: 'karolzaj',
    password: 'c1KbMPKuLxMSdNdY',
    database: 'karolzaj',
    multipleStatements: true

})
var app = express();

connection.connect()

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(function (request, response, next) {
    response.header("Access-Control-Allow-Origin", "*");
    response.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
  });
// app.use(app.router());
  

app.get('/users/:email/:password', (req, res) => {
        console.log("Try to log");
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
                console.log("OK logged!");
                //console.log(results);
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

app.post('/classes', function(req, res) {
    console.log("joining a class!");
    connection.query('CALL joinClass(?,?)', [req.body.userID, req.body.classCode], (err, results ) => {

        if(err) {
            console.log("error occured.");
            console.error(err);
            res.status(500).json({status : 'error'});
        }
        else{
            console.log("joined class!");
            res.status(200).json({status : 'ok!'});
        }
    })
});

app.listen(port, () => {
    console.log(`App is listening on ${port}.`)
})



app.get('/questions/:userID', (req, res) => {
    console.log("Trying to get questions");
    var userID = req.params.userID;
    connection.query('SELECT * FROM Question WHERE UserID = ?',[userID],
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
                    res.status(500).json({msg : 'error1'});
            else{
                res.status(500).json({error : 'error1'});
            }
        }

    })
})


app1.post('/questions', function(req, res) {
    let ind = Math.floor(Math.random()*4);

    let arr = [req.body.correct, req.body.answer1, req.body.answer2, req.body.answer3];

    var temp = arr[0];
    arr[0] = arr[ind];
    arr[ind] = temp;

    connection.query('CALL createQuestion(?,?,?,?,?,?,?,@res)', 
    [req.body.sentence, req.body.userID, arr[0], arr[1], arr[2], arr[3], ind+1], (err, results ) => {
        if(err) {
            console.log("error occured during posting question.");
            console.error(err);
            res.status(500).json({status : 'error during posting question'});
        }
        else{
            console.log("ok posting question!");
            res.status(200).json({status : 'ok posting question!'});
        }
    })
});


app1.get('/quizes/:quizID', (req, res) => {
    console.log("Trying to get quiz");
    var quizID = req.params.quizID;
    connection.query('SELECT QuestionID FROM QuizSet WHERE QuizID = ?',[quizID],
     (err, results) => {
        if(err) {
            console.log("error occured during getting QuestionIDs");
            console.error(err);
            res.status(500).json({error : 'error1'});
        }
        else{
            let allQuestions = [];
            console.log(results.length);
            if(results.length > 0 )
                if(results)
                    for(let i=0; i<results.length; i++)
                    {
                        let question = {details: "", answers: []};
                        console.log(results[i].QuestionID);
                        connection.query('SELECT * FROM Question WHERE QuestionID = ?', [results[i].QuestionID],
                        (err1, results1) =>
                        {
                            if(err1)
                            {
                                console.log("Error during getting question sentence");
                            }
                            else
                            {
                                question.details = results1[0];
                                connection.query('SELECT * FROM Answer WHERE QuestionID = ?', [results[i].QuestionID],
                                (err2, results2) =>
                                {
                                    if(err2)
                                    {
                                        res.status(500).json({msg : 'error'});
                                        console.log("Error during answer for question");
                                    }
                                    else
                                    {
                                        question.answers = results2;
                                        allQuestions.push(question);

                                        if(i == results.length-1)
                                        {
                                            console.log(allQuestions);
                                            res.status(200).json(allQuestions);
                                        }

                                    }
                                })
                            }
                        });
                        
                    }
                else
                    res.status(500).json({msg : 'error1'});
            else{
                res.status(500).json({error : 'error1'});
            }
        }

    })
});

app1.post('/quizes', function(req, res) {
    connection.query('CALL addQuizParticipant(?, ?, ?)', 
    [req.body.quizID, req.body.userID, req.body.score], (err, results ) => {
        if(err) {
            console.log("error occured during posting quizParticipant.");
            console.error(err);
            res.status(500).json({status : 'error during posting quizParticipant'});
        }
        else{
            console.log("ok posting quizParticipant!");
            res.status(200).json({status : 'ok posting quizParticipant!'});
        }
    })
});

