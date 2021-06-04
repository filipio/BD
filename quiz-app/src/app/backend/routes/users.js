const express = require('express')
const connection = require('../dbConnection')
var router = express.Router()

router.get('/:email/:password', (req, res) => {
    var email = req.params.email;
    var password = req.params.password;
    connection.query('SELECT * FROM User WHERE Email = ? AND Password = ?',[email,password],
     (err, results) => {
        if(err) {
            console.error(err);
            res.status(500).json({error : 'error occured when logging : ' + err.message});
        }
        else{
            res.status(200).json(results);
        }

    })
})

router.post('/', function(req, res) {
connection.query('CALL registerUser(?,?,?,?)', [req.body.firstname, req.body.lastname, req.body.email, req.body.password], (err, results ) => {
    if(err) {
        console.error(err);
        res.status(500).json({error : 'error occured when registring : ' + err.message});
    }
    else{
        res.status(200).json(results);
    }
})
});

module.exports = router;