#STORED PROCEDURES

CREATE PROCEDURE registerUser(
    IN first_name VARCHAR(50),
    IN last_name VARCHAR(50),
    IN e_mail varchar(50),
    IN acc_password varchar(50)
)
BEGIN
    INSERT INTO User (FirstName, LastName, Email, Password)
    VALUES (first_name, last_name, e_mail, acc_password);
END;

CREATE PROCEDURE createClass(
    IN class_name VARCHAR(50),
    IN owner_id int(11),
    IN join_code varchar(10)
)
BEGIN
    INSERT INTO Class (Name, Owner, ClassCode)
    VALUES (class_name, owner_id, join_code);
END;




CREATE PROCEDURE joinClass(IN _userID INT, IN _classCode VARCHAR(10))
BEGIN
    DECLARE _classID INT;
    SELECT ClassID INTO _classID FROM Class WHERE ClassCode = _classCode;
    INSERT INTO ClassParticipant (UserID, ClassID, JoinDate) VALUES(_userID, _classID, NOW());

END



CREATE PROCEDURE addQuizParticipant(IN _quizID INT, IN _userID INT, IN _score INT)
BEGIN
    INSERT INTO QuizParticipant(quizid, userid, score) VALUE(_quizID, _userID, _score);
END

