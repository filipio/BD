const express = require('express')
const connection = require('../dbConnection')
var router = express.Router()


router.get('/', function(req, res){

    connection.query('CALL quizesInfo(?,?)', [parseInt(req.query.id), parseInt(req.query.count) ],
    (err, results) => {
        if(err){
            console.error(err);
            res.status(500).json({status : 'database-error during getting quiz : ' + err.message});
        }
        else{
            res.status(200).json(results);
        }
    })
});


router.post('/', function(req, res) {
    connection.query('CALL createQuiz(?,?,?,?,?)', [req.body.categoryID, req.body.title, req.body.start, req.body.end, req.body.n_of_questions], (err, results ) => {
        if(err) {
            console.error(err);
            res.status(500).json({error : 'error during posting quiz : ' + err.message});
        }
        else{
            if(results.length > 0)
                res.status(200).json(results);
            else
                res.status(400).json({error : 'not enough questions to create the quiz.'});
        }
    })
});

router.get('/:quizID', (req, res) => {
    console.log("Trying to get quiz");
    var quizID = req.params.quizID;
    connection.query('SELECT QuestionID FROM QuizSet WHERE QuizID = ?',[quizID],
     (err, results) => {
        if(err) {
            res.status(500).json({error : 'database error when getting quiz data.'});
        }
        else{
            let allQuestions = [];
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

module.exports = router;