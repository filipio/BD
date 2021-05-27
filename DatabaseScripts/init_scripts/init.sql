SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `quizDB` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `quizDB`;

DELIMITER $$
DROP PROCEDURE IF EXISTS `addQuestionToCategory`$$
CREATE DEFINER=`karolzaj`@`%` PROCEDURE `addQuestionToCategory` (IN `q_id` INT, IN `cat_id` INT)  BEGIN
    INSERT INTO QuestionsSet(CategoryID, QuestionID) VALUES(cat_id, q_id);
end$$

DROP PROCEDURE IF EXISTS `addQuizParticipant`$$
CREATE DEFINER=`karolzaj`@`%` PROCEDURE `addQuizParticipant` (IN `_quizID` INT, IN `_userID` INT, IN `_score` INT)  BEGIN
    INSERT INTO QuizParticipant(quizid, userid, score) VALUE(_quizID, _userID, _score);
END$$

DROP PROCEDURE IF EXISTS `createCategory`$$
CREATE DEFINER=`karolzaj`@`%` PROCEDURE `createCategory` (IN `id` INT, IN `name` VARCHAR(50))  BEGIN
    INSERT INTO Category(ClassID, Categoryname) VALUES(id, name);
end$$

DROP PROCEDURE IF EXISTS `createClass`$$
CREATE DEFINER=`karolzaj`@`%` PROCEDURE `createClass` (IN `classname` VARCHAR(50), IN `ownerid` INT(11), IN `joincode` VARCHAR(10))  BEGIN
    INSERT INTO Class (Name, Owner, ClassCode)
    VALUES (classname,ownerid,joincode);
end$$

DROP PROCEDURE IF EXISTS `createQuestion`$$
CREATE DEFINER=`karolzaj`@`%` PROCEDURE `createQuestion` (IN `sentence` VARCHAR(500), IN `user_id` INT(11), IN `Answer1` VARCHAR(500), IN `Answer2` VARCHAR(500), IN `Answer3` VARCHAR(500), IN `Answer4` VARCHAR(500), IN `correctAnsNum` INT(1), OUT `success` BIT)  BEGIN
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
end$$

DROP PROCEDURE IF EXISTS `createQuiz`$$
CREATE DEFINER=`karolzaj`@`%` PROCEDURE `createQuiz` (IN `Category_id` INT, IN `title` VARCHAR(50), IN `start_date` DATETIME, IN `end_date` DATETIME, IN `q_count` INT)  BEGIN
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
end$$

DROP PROCEDURE IF EXISTS `joinClass`$$
CREATE DEFINER=`karolzaj`@`%` PROCEDURE `joinClass` (IN `_userID` INT, IN `_classCode` VARCHAR(10))  BEGIN
    DECLARE _classID INT;
    SELECT ClassID INTO _classID FROM Class WHERE ClassCode = _classCode;
    INSERT INTO ClassParticipant (UserID, ClassID, JoinDate) VALUES(_userID, _classID, NOW());

END$$

DROP PROCEDURE IF EXISTS `loginUser`$$
CREATE DEFINER=`karolzaj`@`%` PROCEDURE `loginUser` (IN `userEmail` VARCHAR(100), IN `userPassword` VARCHAR(50), OUT `id` INT)  BEGIN
    SELECT UserID INTO id FROM User
        WHERE Password = userPassword AND Email = userEmail;
end$$

DROP PROCEDURE IF EXISTS `pickQuizSet`$$
CREATE DEFINER=`karolzaj`@`%` PROCEDURE `pickQuizSet` (IN `Quiz_id` INT, IN `Category_id` INT, IN `q_count` INT, OUT `result` INT)  BEGIN
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
end$$

DROP PROCEDURE IF EXISTS `registerUser`$$
CREATE DEFINER=`karolzaj`@`%` PROCEDURE `registerUser` (IN `Firstname` VARCHAR(50), IN `Lastname` VARCHAR(50), IN `email` VARCHAR(50), IN `password` VARCHAR(50))  BEGIN
    INSERT INTO User (FirstName, LastName, Email, Password)
    VALUES (FirstName,LastName,email,password);
end$$

DELIMITER ;

DROP TABLE IF EXISTS `Answer`;
CREATE TABLE `Answer` (
  `AnswerID` int(11) NOT NULL,
  `QuestionID` int(11) NOT NULL,
  `Sentence` varchar(50) NOT NULL,
  `IsCorrect` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Answer` (`AnswerID`, `QuestionID`, `Sentence`, `IsCorrect`) VALUES
(1, 1, 'mleko', b'1'),
(2, 1, 'wode', b'0'),
(3, 1, 'nic', b'0'),
(4, 1, 'inna zla odpowiedz', b'0'),
(5, 3, 'nic', b'0'),
(6, 3, 'wode', b'1'),
(7, 3, 'nic', b'0'),
(8, 3, 'inna zla odpowiedz', b'0'),
(9, 4, 'zwyciezca', b'0'),
(10, 4, 'woda', b'1'),
(11, 4, 'nic', b'0'),
(12, 4, 'inna zla odpowiedz', b'0'),
(13, 5, 'good', b'1'),
(14, 5, 'bad1', b'0'),
(15, 5, 'bad2', b'0'),
(16, 5, 'bad3', b'0'),
(17, 6, 'reload', b'1'),
(18, 6, 'test1', b'0'),
(19, 6, 'test3212', b'0'),
(20, 6, 'asd', b'0'),
(21, 7, 'Correct answer', b'1'),
(22, 7, 'Incorrect answer', b'0'),
(23, 7, 'Incorrect answer', b'0'),
(24, 7, 'Incorrect answer', b'0'),
(25, 8, 'Correct answer', b'1'),
(26, 8, 'Incorrect answer', b'0'),
(27, 8, 'Incorrect answer', b'0'),
(28, 8, 'Incorrect answer', b'0'),
(29, 9, 'Correct answer', b'1'),
(30, 9, 'Incorrect answer', b'0'),
(31, 9, 'Incorrect answer', b'0'),
(32, 9, 'Incorrect answer', b'0'),
(33, 10, 'Correct answer', b'1'),
(34, 10, 'Incorrect answer', b'0'),
(35, 10, 'Incorrect answer', b'0'),
(36, 10, 'Incorrect answer', b'0'),
(37, 11, 'Correct answer', b'1'),
(38, 11, 'Incorrect answer', b'0'),
(39, 11, 'Incorrect answer', b'0'),
(40, 11, 'Incorrect answer', b'0'),
(41, 12, 'Correct answer', b'1'),
(42, 12, 'Incorrect answer', b'0'),
(43, 12, 'Incorrect answer', b'0'),
(44, 12, 'Incorrect answer', b'0'),
(45, 13, 'Correct answer', b'1'),
(46, 13, 'Incorrect answer', b'0'),
(47, 13, 'Incorrect answer', b'0'),
(48, 13, 'Incorrect answer', b'0'),
(49, 14, 'Correct answer', b'1'),
(50, 14, 'Incorrect answer', b'0'),
(51, 14, 'Incorrect answer', b'0'),
(52, 14, 'Incorrect answer', b'0'),
(53, 15, '1', b'1'),
(54, 15, '2', b'0'),
(55, 15, '3', b'0'),
(56, 15, '4', b'0'),
(57, 16, 'wod?', b'1'),
(58, 16, 'kaw?', b'0'),
(59, 16, 'mleko', b'0'),
(60, 16, 'wod? z ogórków', b'0'),
(61, 17, 'bad1', b'0'),
(62, 17, 'good', b'1'),
(63, 17, 'bad2', b'0'),
(64, 17, 'bad3', b'0');

DROP TABLE IF EXISTS `Category`;
CREATE TABLE `Category` (
  `CategoryID` int(11) NOT NULL,
  `ClassID` int(11) NOT NULL,
  `Categoryname` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Category` (`CategoryID`, `ClassID`, `Categoryname`) VALUES
(1, 2, 'awesomeCategory!'),
(2, 2, 'superCategory'),
(3, 2, 'badCategory');

DROP TABLE IF EXISTS `Class`;
CREATE TABLE `Class` (
  `ClassID` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Owner` int(11) NOT NULL,
  `ClassCode` varchar(10) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Class` (`ClassID`, `Name`, `Owner`, `ClassCode`) VALUES
(1, 'ï»¿science', 1, 'xllkmsdqwe'),
(2, 'Biologia', 2, 'j0in2#code'),
(3, 'Math', 1, 'randcode12');

DROP TABLE IF EXISTS `ClassParticipant`;
CREATE TABLE `ClassParticipant` (
  `UserID` int(11) NOT NULL,
  `ClassID` int(11) NOT NULL,
  `JoinDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `ClassParticipant` (`UserID`, `ClassID`, `JoinDate`) VALUES
(1, 2, '2021-05-03 16:56:20'),
(2, 1, '2021-05-03 18:30:10'),
(2, 2, '2021-05-08 22:41:02'),
(2, 3, '2021-05-13 20:36:47'),
(16, 3, '2021-05-13 20:25:14');

DROP TABLE IF EXISTS `Question`;
CREATE TABLE `Question` (
  `QuestionID` int(11) NOT NULL,
  `Data` varchar(500) NOT NULL,
  `UserID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Question` (`QuestionID`, `Data`, `UserID`) VALUES
(1, 'Co pije krowa?', 2),
(3, 'Co pijesz ?', 2),
(4, 'Kim jestes ?', 2),
(5, 'te?cik', 2),
(6, 'test2', 2),
(7, 'swe', 2),
(8, 'Question', 2),
(9, 'Question', 2),
(10, 'Question', 2),
(11, 'Question', 2),
(12, 'Question', 2),
(13, 'Question', 2),
(14, '321', 2),
(15, 'Pytanie 1', 2),
(16, 'co pije cz?owiek?', 2),
(17, 'TestRandom', 2);

DROP TABLE IF EXISTS `QuestionsSet`;
CREATE TABLE `QuestionsSet` (
  `CategoryID` int(11) NOT NULL,
  `QuestionID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `QuestionsSet` (`CategoryID`, `QuestionID`) VALUES
(2, 1),
(2, 3),
(2, 4);

DROP TABLE IF EXISTS `Quiz`;
CREATE TABLE `Quiz` (
  `QuizID` int(11) NOT NULL,
  `CategoryID` int(11) DEFAULT NULL,
  `QuizTitle` varchar(50) NOT NULL,
  `StartDate` datetime NOT NULL,
  `EndDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Quiz` (`QuizID`, `CategoryID`, `QuizTitle`, `StartDate`, `EndDate`) VALUES
(11, 2, 'awesome!!!', '2021-05-03 18:22:36', '2021-05-03 18:30:00'),
(16, 2, 'TEST', '2021-05-14 21:36:00', '2021-05-15 21:33:00'),
(17, 2, 'awesome', '2021-05-15 21:03:00', '2021-05-02 21:58:00'),
(18, 2, 'Question', '2021-05-06 16:53:00', '2021-05-06 17:53:00'),
(22, 2, 'cool', '2021-05-13 18:17:00', '2021-05-20 18:17:00'),
(23, 2, 'BadBoysblue', '2021-05-19 16:19:00', '2021-05-19 22:19:00'),
(24, 2, 'hardy one!', '2021-05-19 17:53:00', '2021-05-19 21:54:00');

DROP TABLE IF EXISTS `QuizParticipant`;
CREATE TABLE `QuizParticipant` (
  `QuizID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `Score` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `QuizParticipant` (`QuizID`, `UserID`, `Score`) VALUES
(11, 2, 3),
(22, 2, 1),
(23, 2, 3),
(24, 2, 3),
(11, 16, 3);

DROP TABLE IF EXISTS `QuizSet`;
CREATE TABLE `QuizSet` (
  `QuizID` int(11) NOT NULL,
  `QuestionID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `QuizSet` (`QuizID`, `QuestionID`) VALUES
(11, 1),
(11, 3),
(11, 4),
(16, 3),
(16, 4),
(17, 3),
(17, 4),
(18, 3),
(18, 4),
(22, 4),
(23, 1),
(23, 3),
(23, 4),
(24, 1),
(24, 3),
(24, 4);

DROP TABLE IF EXISTS `User`;
CREATE TABLE `User` (
  `UserID` int(11) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `Password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `User` (`UserID`, `FirstName`, `LastName`, `Email`, `Password`) VALUES
(1, 'ï»¿filip', 'juza', '123@gmail.com', '123123'),
(2, 'Karol', 'Zajac', 'test@email.pl', '123456'),
(3, 'Bartek', 'Wlodarski', 'email@git.pl', '12345678'),
(4, 'Test', 'Test', 'test2@email.pl', '123abc'),
(5, 'Twoje imie', 'Twoje nazwisko', 'super@user.pl', '123'),
(6, 'Twoje imie', 'Twoje nazwisko', 'qwe.com', 'Twoje has?o'),
(7, 'Twoje imie', 'Twoje nazwisko', 'Adres email', 'Twoje has?o'),
(8, 'Twoje imie', 'Twoje nazwisko', 'Adres email', 'Twoje has?o'),
(9, 'Twoje imie', 'Twoje nazwisko', 'Adres email', 'Twoje has?o'),
(10, 'Twoje imie', 'Twoje nazwisko', 'Adres email', 'Twoje has?o'),
(11, 'felipe', 'inzagi', 'super@user.pl', '123qwe'),
(12, 'kuku', 'ryku', 'awesome@super.com', 'qweasd'),
(13, 'Shrek', 'Kowalski', 'Filip.Juza.2000@gmail.com', '123456'),
(14, 'tube', 'come', 'ser@super.com', 'you'),
(15, 'Twoje imie', 'Twoje nazwisko', 'asdqwe@.com', 'Twoje has?o'),
(16, 'user', 'user', 'user@user.com', '123123'),
(17, 'test1', 'test2', 'asd', '1234567'),
(18, 'Twoje imie', 'Twoje nazwisko', 'Adres email', 'Twoje has?o');


ALTER TABLE `Answer`
  ADD PRIMARY KEY (`AnswerID`),
  ADD UNIQUE KEY `Answer_AnswerID_uindex` (`AnswerID`),
  ADD KEY `Answer_Question_QuestionID_fk` (`QuestionID`);

ALTER TABLE `Category`
  ADD PRIMARY KEY (`CategoryID`),
  ADD KEY `Category_Class_ClassID_fk` (`ClassID`);

ALTER TABLE `Class`
  ADD PRIMARY KEY (`ClassID`),
  ADD UNIQUE KEY `Class_ClassCode_uindex` (`ClassCode`),
  ADD KEY `Class_User_UserID_fk` (`Owner`);

ALTER TABLE `ClassParticipant`
  ADD PRIMARY KEY (`UserID`,`ClassID`),
  ADD KEY `ClassParticipant_Class_ClassID_fk` (`ClassID`);

ALTER TABLE `Question`
  ADD PRIMARY KEY (`QuestionID`),
  ADD UNIQUE KEY `Question_QuestionID_uindex` (`QuestionID`),
  ADD KEY `Question_User_UserID_fk` (`UserID`);

ALTER TABLE `QuestionsSet`
  ADD PRIMARY KEY (`CategoryID`,`QuestionID`),
  ADD KEY `QuestionsSet_Question_QuestionID_fk` (`QuestionID`);

ALTER TABLE `Quiz`
  ADD PRIMARY KEY (`QuizID`),
  ADD KEY `Quiz_Category_CategoryID_fk` (`CategoryID`);

ALTER TABLE `QuizParticipant`
  ADD PRIMARY KEY (`UserID`,`QuizID`),
  ADD KEY `QuizParticipant_Quiz_QuizID_fk` (`QuizID`);

ALTER TABLE `QuizSet`
  ADD PRIMARY KEY (`QuizID`,`QuestionID`),
  ADD KEY `QuizSet_Question_QuestionID_fk` (`QuestionID`);

ALTER TABLE `User`
  ADD PRIMARY KEY (`UserID`);


ALTER TABLE `Answer`
  MODIFY `AnswerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;
ALTER TABLE `Category`
  MODIFY `CategoryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
ALTER TABLE `Class`
  MODIFY `ClassID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
ALTER TABLE `Question`
  MODIFY `QuestionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
ALTER TABLE `Quiz`
  MODIFY `QuizID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;
ALTER TABLE `User`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

ALTER TABLE `Answer`
  ADD CONSTRAINT `Answer_Question_QuestionID_fk` FOREIGN KEY (`QuestionID`) REFERENCES `Question` (`QuestionID`);

ALTER TABLE `Category`
  ADD CONSTRAINT `Category_Class_ClassID_fk` FOREIGN KEY (`ClassID`) REFERENCES `Class` (`ClassID`);

ALTER TABLE `Class`
  ADD CONSTRAINT `Class_User_UserID_fk` FOREIGN KEY (`Owner`) REFERENCES `User` (`UserID`);

ALTER TABLE `ClassParticipant`
  ADD CONSTRAINT `ClassParticipant_Class_ClassID_fk` FOREIGN KEY (`ClassID`) REFERENCES `Class` (`ClassID`),
  ADD CONSTRAINT `ClassParticipant_User_UserID_fk` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`);

ALTER TABLE `Question`
  ADD CONSTRAINT `Question_User_UserID_fk` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`);

ALTER TABLE `QuestionsSet`
  ADD CONSTRAINT `QuestionsSet_Category_CategoryID_fk` FOREIGN KEY (`CategoryID`) REFERENCES `Category` (`CategoryID`),
  ADD CONSTRAINT `QuestionsSet_Question_QuestionID_fk` FOREIGN KEY (`QuestionID`) REFERENCES `Question` (`QuestionID`);

ALTER TABLE `Quiz`
  ADD CONSTRAINT `Quiz_Category_CategoryID_fk` FOREIGN KEY (`CategoryID`) REFERENCES `Category` (`CategoryID`);

ALTER TABLE `QuizParticipant`
  ADD CONSTRAINT `QuizParticipant_Quiz_QuizID_fk` FOREIGN KEY (`QuizID`) REFERENCES `Quiz` (`QuizID`),
  ADD CONSTRAINT `QuizParticipant_User_UserID_fk` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`);

ALTER TABLE `QuizSet`
  ADD CONSTRAINT `QuizSet_Question_QuestionID_fk` FOREIGN KEY (`QuestionID`) REFERENCES `Question` (`QuestionID`),
  ADD CONSTRAINT `QuizSet_Quiz_QuizID_fk` FOREIGN KEY (`QuizID`) REFERENCES `Quiz` (`QuizID`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
