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

                                                                    
      
                                                                  
CREATE PROCEDURE createQuestion(
    IN sentence VARCHAR(500),
    IN user_id INT(11),
    IN Answer1 VARCHAR(500),
    IN Answer2 VARCHAR(500),
    IN Answer3 VARCHAR(500),
    IN Answer4 VARCHAR(500),
    IN correctAnsNum INT(1),
    OUT success BIT)
BEGIN
    DECLARE inserted_id INT(11);
    START TRANSACTION;

    INSERT INTO Question (Data, UserID)
    VALUES (sentence, user_id);

    SET inserted_id = LAST_INSERT_ID();

    IF correctAnsNum = 1 THEN
        BEGIN
            INSERT INTO Answer (QuestionID, Sentence, IsCorrect)
            VALUES (inserted_id, Answer1, 1);
            INSERT INTO Answer (QuestionID, Sentence, IsCorrect)
            VALUES (inserted_id, Answer2, 0);
            INSERT INTO Answer (QuestionID, Sentence, IsCorrect)
            VALUES (inserted_id, Answer3, 0);
            INSERT INTO Answer (QuestionID, Sentence, IsCorrect)
            VALUES (inserted_id, Answer4, 0);
            COMMIT;
        END;
    ELSEIF correctAnsNum = 2 THEN
        BEGIN
            INSERT INTO Answer (QuestionID, Sentence, IsCorrect)
            VALUES (inserted_id, Answer1, 0);
            INSERT INTO Answer (QuestionID, Sentence, IsCorrect)
            VALUES (inserted_id, Answer2, 1);
            INSERT INTO Answer (QuestionID, Sentence, IsCorrect)
            VALUES (inserted_id, Answer3, 0);
            INSERT INTO Answer (QuestionID, Sentence, IsCorrect)
            VALUES (inserted_id, Answer4, 0);
            COMMIT;
        END;
    ELSEIF correctAnsNum = 3 THEN
        BEGIN
            INSERT INTO Answer (QuestionID, Sentence, IsCorrect)
            VALUES (inserted_id, Answer1, 0);
            INSERT INTO Answer (QuestionID, Sentence, IsCorrect)
            VALUES (inserted_id, Answer2, 0);
            INSERT INTO Answer (QuestionID, Sentence, IsCorrect)
            VALUES (inserted_id, Answer3, 1);
            INSERT INTO Answer (QuestionID, Sentence, IsCorrect)
            VALUES (inserted_id, Answer4, 0);
            COMMIT;
        END;
    ELSEIF correctAnsNum = 4 THEN
        BEGIN
            INSERT INTO Answer (QuestionID, Sentence, IsCorrect)
            VALUES (inserted_id, Answer1, 0);
            INSERT INTO Answer (QuestionID, Sentence, IsCorrect)
            VALUES (inserted_id, Answer2, 0);
            INSERT INTO Answer (QuestionID, Sentence, IsCorrect)
            VALUES (inserted_id, Answer3, 0);
            INSERT INTO Answer (QuestionID, Sentence, IsCorrect)
            VALUES (inserted_id, Answer4, 1);
            COMMIT;
        END;
    ELSE
        ROLLBACK ;
        SET success = 0;
    end if;
    SET success = 1;
end;
