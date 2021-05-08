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



create
    definer = karolzaj@`%` procedure addQuestionToCategory(IN q_id int, IN cat_id int)
BEGIN
    INSERT INTO QuestionsSet(CategoryID, QuestionID) VALUES(cat_id, q_id);
end;

create
    definer = karolzaj@`%` procedure createCategory(IN id int, IN name varchar(50))
BEGIN
    INSERT INTO Category(ClassID, Categoryname) VALUES(id, name);
end;


create
    definer = karolzaj@`%` procedure createQuiz(IN Category_id int, IN title varchar(50), IN start_date datetime,
                                                IN end_date datetime, IN q_count int)
BEGIN
    DECLARE quiz_id INT;
    START TRANSACTION;
    INSERT INTO Quiz(CategoryID, QuizTitle, StartDate, EndDate) VALUES
    (Category_id, title, start_date, end_date);
    SET quiz_id = LAST_INSERT_ID();
    CALL pickQuizSet(quiz_id, Category_id, q_count, @result);
    IF @result = 0 THEN
        ROLLBACK;
    ELSE
        COMMIT;
    end if;
end;


create
    definer = karolzaj@`%` procedure loginUser(IN userEmail varchar(100), IN userPassword varchar(50), OUT id int)
BEGIN
    SELECT UserID INTO id FROM User
        WHERE Password = userPassword AND Email = userEmail;
end;


create
    definer = karolzaj@`%` procedure pickQuizSet(IN Quiz_id int, IN Category_id int, IN q_count int, OUT result int)
BEGIN
    DECLARE questionsInCategory INT;
    SELECT COUNT(*) INTO questionsInCategory FROM QuestionsSet
        WHERE CategoryID = Category_id;
    IF questionsInCategory >= q_count THEN
        INSERT INTO QuizSet(QuizID, QuestionID)  SELECT Quiz_id, QuestionID
        FROM QuestionsSet
        ORDER BY RAND()
        LIMIT q_count;
        SET result = 1;
    ELSE
        SET result = 0;
    end if;
end;




