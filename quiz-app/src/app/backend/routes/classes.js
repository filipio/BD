const express = require('express')
const connection = require('../dbConnection')
var router = express.Router()

router.get('/:userID', (req, res) => {
    var userID = req.params.userID;
    connection.query('SELECT * FROM Class INNER JOIN ClassParticipant ON Class.ClassID = ClassParticipant.ClassID AND ClassParticipant.UserID = ?',[userID],
     (err, results) => {
        if(err) {
            console.error(err);
            res.status(500).json({error : 'database-error occured when getting class data : ' + err.message});
        }
        else{
            res.status(200).json(results);
        }

    })
})

// name is wrong below
router.post('/', function(req, res) {
    connection.query('CALL joinClass(?,?)', [req.body.userID, req.body.classCode], (err, results ) => {
        if(err) {
            console.error(err);
            res.status(500).json({error : 'database-error occured when joining new class by the client : ' + err.message});
        }
        else{
            res.status(200).json({});
        }
    })
});

module.exports = router;