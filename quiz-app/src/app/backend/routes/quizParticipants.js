const express = require('express')
const connection = require('../dbConnection')
var router = express.Router()

router.get('/:quizID', (req, res) => {
    var quizID = req.params.quizID;
    
    connection.query('SELECT u.FirstName, u.LastName, q.Score FROM QuizParticipant q INNER JOIN User u ON u.UserID = q.UserID WHERE q.QuizID = ?',[quizID],
     (err, results) => {
        if(err) {
            console.error(err);
            res.status(500).json({error : 'error occured when getting participants of a quiz : ' + err.message});
        }
        else{
            res.status(200).json(results);
        }
    })
});

router.post('/', function(req, res) {
    connection.query('CALL addQuizParticipant(?, ?, ?)', 
    [req.body.quizID, req.body.userID, req.body.score], (err, results ) => {
        if(err) {
            console.error(err);
            res.status(500).json({status : 'error during posting quizParticipant : ' + err.message});
        }
        else{
            res.status(200).json(results);
        }
    })
});


module.exports = router;
