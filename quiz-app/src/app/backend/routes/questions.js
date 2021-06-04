const express = require('express')
const connection = require('../dbConnection')
var router = express.Router()

router.get('/:userID', (req, res) => {
    var userID = req.params.userID;
    connection.query('SELECT * FROM Question WHERE UserID = ?',[userID],
     (err, results) => {
        if(err) {
            console.error(err);
            res.status(500).json({error : 'error occured when getting questions : ' + err.message});
        }
        else{
            res.status(200).json(results);
        }

    })
})

router.post('/', function(req, res) {
    let ind = Math.floor(Math.random()*4);

    let arr = [req.body.correct, req.body.answer1, req.body.answer2, req.body.answer3];

    var temp = arr[0];
    arr[0] = arr[ind];
    arr[ind] = temp;

    connection.query('CALL createQuestion(?,?,?,?,?,?,?,@res)', 
    [req.body.sentence, req.body.userID, arr[0], arr[1], arr[2], arr[3], ind+1], (err, results ) => {
        if(err) {
            console.error(err);
            res.status(500).json({status : 'error occured when posting question : ' + err.message});
        }
        else{
            res.status(200).json(results);
        }
    })
});

module.exports = router;