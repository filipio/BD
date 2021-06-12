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
CREATE DEFINER=`karolzaj`@`%` PROCEDURE `createClass` (IN `classname` VARCHAR(50), IN `ownerid` INT, IN `joincode` VARCHAR(10))  BEGIN

    INSERT INTO Class (Name, Owner, ClassCode)
    VALUES (classname,ownerid,joincode);

    CALL joinClass(ownerid, joincode);
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
        SELECT 1 AS result;
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
        WHERE CategoryID = Category_id
        ORDER BY RAND()
        LIMIT q_count;
        SET result = 1;
    ELSE
        SET result = 0;
    end if;
end$$

DROP PROCEDURE IF EXISTS `quizesInfo`$$
CREATE DEFINER=`karolzaj`@`%` PROCEDURE `quizesInfo` (IN `classID` INT, IN `QuizCount` INT)  BEGIN
    SELECT Quiz.QuizID, QuizTitle, StartDate, EndDate, Categoryname, UserID  FROM Quiz
    LEFT OUTER JOIN QuizParticipant QP on Quiz.QuizID = QP.QuizID
    LEFT OUTER JOIN Category C on Quiz.CategoryID = C.CategoryID
    WHERE C.ClassID = classID
    AND Quiz.QuizID IN
        (SELECT * FROM(SELECT QuizID FROM Quiz ORDER BY StartDate DESC LIMIT QuizCount) q2)
    ORDER BY StartDate DESC;
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
  `Sentence` varchar(500) NOT NULL,
  `IsCorrect` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Answer` (`AnswerID`, `QuestionID`, `Sentence`, `IsCorrect`) VALUES
(89, 24, '240', b'0'),
(90, 24, '360', b'0'),
(91, 24, '90', b'0'),
(92, 24, '180', b'1'),
(93, 25, 'Rectangular', b'1'),
(94, 25, 'Equilateral', b'0'),
(95, 25, 'Obtuse', b'0'),
(96, 25, 'This situation is not possible', b'0'),
(97, 26, '14', b'0'),
(98, 26, '16', b'0'),
(99, 26, '8', b'0'),
(100, 26, '10', b'1'),
(101, 27, '18', b'0'),
(102, 27, '10', b'0'),
(103, 27, '6', b'0'),
(104, 27, '17', b'1'),
(105, 28, '1/5', b'0'),
(106, 28, '1/3', b'0'),
(107, 28, '1/2', b'0'),
(108, 28, '1/6', b'1'),
(109, 29, '1', b'0'),
(110, 29, '0', b'1'),
(111, 29, '1/10', b'0'),
(112, 29, '9/10', b'0'),
(113, 30, '36', b'0'),
(114, 30, '32', b'0'),
(115, 30, '34', b'1'),
(116, 30, '28', b'0'),
(117, 31, 'Poznan', b'0'),
(118, 31, 'Cracow', b'0'),
(119, 31, 'Radom', b'0'),
(120, 31, 'Warsaw', b'1'),
(121, 32, 'Roma', b'0'),
(122, 32, 'Barcelona', b'0'),
(123, 32, 'France', b'0'),
(124, 32, 'Madrid', b'1'),
(125, 33, 'Paris', b'1'),
(126, 33, 'Marsylia', b'0'),
(127, 33, 'Berlin', b'0'),
(128, 33, 'Moscow', b'0'),
(129, 34, 'in Europe', b'0'),
(130, 34, 'in Antarctica', b'0'),
(131, 34, 'in South America', b'1'),
(132, 34, 'in Australia', b'0'),
(133, 35, 'Giraffe', b'0'),
(134, 35, 'Penguin', b'1'),
(135, 35, 'Tiger', b'0'),
(136, 35, 'Rhino', b'0'),
(137, 36, 'in Australia', b'0'),
(138, 36, 'in Europe', b'1'),
(139, 36, 'in South America', b'0'),
(140, 36, 'in North America', b'0'),
(141, 37, 'in Asia', b'1'),
(142, 37, 'in Europe', b'0'),
(143, 37, 'in South America', b'0'),
(144, 37, 'in North America', b'0'),
(145, 38, 'in South America', b'0'),
(146, 38, 'in Europe', b'0'),
(147, 38, 'in Asia', b'1'),
(148, 38, 'in North America', b'0'),
(149, 39, 'in Asia', b'0'),
(150, 39, 'in Europe', b'1'),
(151, 39, 'in Africa', b'0'),
(152, 39, 'in North America', b'0'),
(153, 40, 'in Asia', b'0'),
(154, 40, 'in North America', b'1'),
(155, 40, 'in Africa', b'0'),
(156, 40, 'in Europe', b'0'),
(157, 41, 'South America', b'1'),
(158, 41, 'Africa', b'0'),
(159, 41, 'Asia', b'0'),
(160, 41, 'Europe', b'0'),
(161, 42, 'Australia', b'0'),
(162, 42, 'America', b'0'),
(163, 42, 'Africa', b'1'),
(164, 42, 'Europe', b'0'),
(165, 43, 'Asia', b'0'),
(166, 43, 'South America', b'0'),
(167, 43, 'Australia', b'0'),
(168, 43, 'North America', b'1'),
(169, 44, 'Australia', b'0'),
(170, 44, 'South America', b'0'),
(171, 44, 'North America', b'1'),
(172, 44, 'Asia', b'0'),
(173, 45, 'South America', b'0'),
(174, 45, 'Asia', b'1'),
(175, 45, 'Europe', b'0'),
(176, 45, 'Africa', b'0'),
(177, 46, 'Africa', b'0'),
(178, 46, 'Europe', b'0'),
(179, 46, 'Australia', b'0'),
(180, 46, 'Asia', b'1'),
(181, 47, 'Asia', b'0'),
(182, 47, 'Europe', b'0'),
(183, 47, 'Australia', b'1'),
(184, 47, 'Africa', b'0'),
(185, 48, '7', b'1'),
(186, 48, '6', b'0'),
(187, 48, '5', b'0'),
(188, 48, '8', b'0'),
(189, 49, 'SELECT ALL ROWS', b'0'),
(190, 49, 'SELECT COUNT ', b'0'),
(191, 49, 'SELECT COUNT (*)', b'1'),
(192, 49, 'SELECT COUNT(ALL)', b'0'),
(193, 50, '6', b'0'),
(194, 50, '3', b'0'),
(195, 50, '5', b'0'),
(196, 50, '4', b'1'),
(198, 53, 'must contain all pure virtual functions', b'0'),
(199, 53, 'must contain at least one pure virtual function', b'1'),
(200, 53, 'may not contain pure virtual function.', b'0'),
(201, 55, 'Destructor', b'0'),
(202, 55, 'Constructor', b'1'),
(203, 55, 'Friend function', b'0'),
(204, 55, 'Inline function', b'0'),
(205, 56, 'Stack', b'0'),
(206, 56, 'Data', b'1'),
(207, 56, 'Heap', b'0'),
(208, 56, 'Code', b'0'),
(209, 57, 'g++', b'1'),
(210, 57, 'cpp', b'0'),
(211, 57, 'Borland', b'0'),
(212, 57, 'vc++', b'0'),
(213, 58, 'public', b'0'),
(214, 58, 'private', b'0'),
(215, 58, 'protected', b'1'),
(216, 58, 'Access specifiers not applicable for structures', b'0'),
(217, 59, 'None of the mentioned', b'0'),
(218, 59, 'It can be used to evaluate a type.', b'0'),
(219, 59, 'It can of no return type', b'0'),
(220, 59, 'It can be used to pass a type as argument', b'1'),
(221, 60, 'class', b'0'),
(222, 60, 'object', b'0'),
(223, 60, 'pointer to member', b'1'),
(224, 60, 'none of the mentioned', b'0'),
(225, 61, 'Implicit specialization', b'0'),
(226, 61, 'Explicit specialization', b'1'),
(227, 61, 'Function overloading template', b'0'),
(228, 61, 'None of the mentioned', b'0'),
(229, 62, '2', b'0'),
(230, 62, '1', b'0'),
(231, 62, 'No memory needed', b'1'),
(232, 62, '4', b'0'),
(233, 63, 'Modularization', b'1'),
(234, 63, 'Specific task', b'0'),
(235, 63, 'Program control', b'0'),
(236, 63, 'Macros', b'0'),
(237, 64, '1.5m', b'0'),
(238, 64, '2m', b'0'),
(239, 64, '1m', b'0'),
(240, 64, '0.8m', b'1'),
(241, 65, 'Macro', b'0'),
(242, 65, 'Interface', b'1'),
(243, 65, 'Records', b'0'),
(244, 65, 'None of the mentioned', b'0'),
(245, 66, '29', b'0'),
(246, 66, '27', b'1'),
(247, 66, '26', b'0'),
(248, 66, '28', b'0'),
(249, 67, '990', b'0'),
(250, 67, '1300', b'0'),
(251, 67, '1500', b'0'),
(252, 67, '1700', b'1'),
(253, 68, 'namespace#operator', b'0'),
(254, 68, 'namespace,operator', b'0'),
(255, 68, 'namespaceid::operator', b'1'),
(256, 68, 'none of the mentioned', b'0'),
(257, 69, 'By seeing (-)', b'0'),
(258, 69, ' By seeing ()', b'0'),
(259, 69, 'By seeing a blankspace', b'1'),
(260, 69, 'None of the mentioned', b'0'),
(261, 70, 'Marlin, Sableflish', b'0'),
(262, 70, 'shark, blueFish, Carp, darkFish', b'0'),
(263, 70, 'ButterFish, Golden Snapper', b'0'),
(264, 70, 'salmon, trout, sea lamprey, three-spined stickleback', b'1'),
(265, 71, '99', b'0'),
(266, 71, '96', b'0'),
(267, 71, '98', b'0'),
(268, 71, '97', b'1'),
(269, 72, 'Pollock', b'0'),
(270, 72, 'marlin', b'0'),
(271, 72, 'salmon', b'0'),
(272, 72, 'delphin', b'1'),
(273, 73, '15/18', b'0'),
(274, 73, '15/17', b'1'),
(275, 73, '15/19', b'0'),
(276, 73, '15/21', b'0'),
(277, 74, '22', b'0'),
(278, 74, '20', b'0'),
(279, 74, '21', b'1'),
(280, 74, '20.5', b'0'),
(281, 75, 'any method', b'0'),
(282, 75, 'method overriding', b'1'),
(283, 75, 'method overloading', b'0'),
(284, 75, 'compiling', b'0'),
(285, 76, '200', b'0'),
(286, 76, '5000', b'0'),
(287, 76, '400', b'0'),
(288, 76, '2000', b'1'),
(289, 77, '17', b'1'),
(290, 77, '15', b'0'),
(291, 77, '18', b'0'),
(292, 77, '11', b'0'),
(293, 78, 'the weather conditions for each house in a small neighborhood', b'1'),
(294, 78, 'the number of people in each house in a small neighborhood', b'0'),
(295, 78, 'the lot size for each house in a small neighborhood', b'0'),
(296, 78, 'the color of each house in a small neighborhood', b'0'),
(297, 79, '1.5 hours', b'1'),
(298, 79, '1.30 hours', b'0'),
(299, 79, '1 hour', b'0'),
(300, 79, 'None of these correct.', b'0'),
(301, 80, 'to avoid redundant coding in children', b'1'),
(302, 80, 'to explore a hypothetical class', b'0'),
(303, 80, 'to prevent unwanted method implementation', b'0'),
(304, 80, 'to reserve memory for an unspecified class type', b'0'),
(305, 81, 'LUNATIC DRAGON', b'0'),
(306, 81, 'Cannibal Savage Gear', b'1'),
(307, 81, 'housefly', b'0'),
(308, 81, 'human meat', b'0'),
(321, 85, 'at compile time', b'1'),
(322, 85, 'only when you export', b'0'),
(323, 85, 'both at compile time and runtime', b'0'),
(324, 85, 'at runtime', b'0'),
(325, 86, 'elephant', b'1'),
(326, 86, 'lion', b'0'),
(327, 86, 'delphin', b'0'),
(328, 86, 'dog', b'0'),
(329, 87, '10', b'0'),
(330, 87, '12', b'0'),
(331, 87, '15', b'0'),
(332, 87, '25', b'1'),
(333, 88, 'It will speed initial development.', b'0'),
(334, 88, 'It will result in a more compact product.', b'0'),
(335, 88, 'It will result in code that is more extensible and maintainable', b'1'),
(336, 88, 'It will allow you to add that design pattern to your resume.', b'0'),
(337, 89, 'hiding the data and implementation details within a class', b'1'),
(338, 89, 'defining classes by focusing on what is important for a purpose', b'0'),
(339, 89, 'making all methods private', b'0'),
(340, 89, 'using words to define classes', b'0'),
(341, 90, 'A subclass object has an IS-A relationship with its superclass or interface', b'1'),
(342, 90, 'A superclass object has an IS-A relationship with its subclass.', b'0'),
(343, 90, 'It implies a virtual method.', b'0'),
(344, 90, 'It implies encapsulation.', b'0'),
(345, 91, 'Employee currentEmployee;', b'0'),
(346, 91, 'Employee current Employee = Employee.Create();', b'0'),
(347, 91, 'Employee current Employee = new Employee();', b'1'),
(348, 91, 'Employee currentEmployee = Employee.New();', b'0'),
(349, 92, 'default', b'0'),
(350, 92, 'parameterized', b'0'),
(351, 92, 'copy', b'0'),
(352, 92, 'Constructors do not have a return type', b'1'),
(353, 93, 'Getters and setters provide a debugging point for when a property changes at runtime.', b'0'),
(354, 93, 'Getters and setters provide encapsulation of behavior.', b'0'),
(355, 93, 'Getters and setters can speed up compilation.', b'1'),
(356, 93, 'Getters and setters permit different access levels.', b'0'),
(357, 94, '3m', b'0'),
(358, 94, '1.5m', b'0'),
(359, 94, '1.8m', b'1'),
(360, 94, '4.2m', b'0');

DROP TABLE IF EXISTS `Category`;
CREATE TABLE `Category` (
  `CategoryID` int(11) NOT NULL,
  `ClassID` int(11) NOT NULL,
  `Categoryname` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Category` (`CategoryID`, `ClassID`, `Categoryname`) VALUES
(4, 11, 'Geometry'),
(5, 11, 'Algebra'),
(6, 11, 'Logic'),
(7, 11, 'Probability'),
(8, 12, 'Countries'),
(9, 12, 'Capitals'),
(10, 12, 'Rivers'),
(11, 12, 'Continents'),
(12, 13, 'Fishes'),
(13, 13, 'Mammals'),
(14, 14, 'Relative Databases'),
(15, 14, 'Document Databases'),
(16, 14, 'Queries'),
(17, 15, 'Geometry'),
(18, 15, 'Algebra'),
(19, 16, 'C++ Programming'),
(20, 16, 'Object-Oriented Programming');

DROP TABLE IF EXISTS `Class`;
CREATE TABLE `Class` (
  `ClassID` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Owner` int(11) NOT NULL,
  `ClassCode` varchar(10) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Class` (`ClassID`, `Name`, `Owner`, `ClassCode`) VALUES
(11, 'Math', 27, 'CL455C0D3#'),
(12, 'Geography', 25, 'GeoClass12'),
(13, 'Biology', 26, 'Bi0Class3'),
(14, 'Databases', 25, 'DbCode3456'),
(15, 'Math', 26, 'Maths2+3=5'),
(16, 'Computer Science', 27, 'dsfo214nks');

DROP TABLE IF EXISTS `ClassParticipant`;
CREATE TABLE `ClassParticipant` (
  `UserID` int(11) NOT NULL,
  `ClassID` int(11) NOT NULL,
  `JoinDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `ClassParticipant` (`UserID`, `ClassID`, `JoinDate`) VALUES
(25, 11, '2021-06-12 17:36:38'),
(25, 12, '2021-06-12 17:33:28'),
(25, 13, '2021-06-12 17:37:34'),
(25, 14, '2021-06-12 17:34:02'),
(25, 16, '2021-06-12 17:38:31'),
(26, 13, '2021-06-12 17:33:59'),
(26, 15, '2021-06-12 17:34:04'),
(27, 11, '2021-06-12 17:33:07'),
(27, 16, '2021-06-12 17:34:05'),
(28, 11, '2021-06-12 19:38:30');

DROP TABLE IF EXISTS `Question`;
CREATE TABLE `Question` (
  `QuestionID` int(11) NOT NULL,
  `Data` varchar(500) NOT NULL,
  `UserID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Question` (`QuestionID`, `Data`, `UserID`) VALUES
(24, 'What is the sum of the angles in a triangle?', 25),
(25, 'Triangle which hypotenuse is a diameter of circle is', 25),
(26, 'How much is 2 + 2 * 4 ?', 25),
(27, 'Michael was two times younger than Mea when she was 6. Now, Mea is 20 years old. How old is Michael?', 25),
(28, 'What is the probability of rolling 6 dice in one cube throw?', 25),
(29, 'There is 10 bananas in a box. What is the probability of picking apple from this box?', 25),
(30, 'How much is (2+3)*5+8-2*2 ?', 25),
(31, 'The capital of Poland is :', 25),
(32, 'The capital of Spain is :', 25),
(33, 'The capital of France is :', 25),
(34, 'Where is Brasil ?', 25),
(35, 'Which animal you can meet on Antarctica?', 25),
(36, 'Where is Italy?', 25),
(37, 'Where is China?', 25),
(38, 'Where is India?', 25),
(39, 'Where is Portugal?', 25),
(40, 'Where is Canada?', 25),
(41, 'Amazon river flows in:', 25),
(42, 'Nile river flows in:', 25),
(43, 'Missisipi river flows in:', 25),
(44, 'Missouri river flows in:', 25),
(45, 'Yangtze river flows in:', 25),
(46, 'The largest continent is :', 25),
(47, 'The smallest continent is :', 25),
(48, 'How many continents are in the world ?', 25),
(49, 'How do you find the total number of rows in a table ?', 25),
(50, 'How many vertices has deltoid?', 25),
(53, 'Abstract class is a class', 27),
(55, 'Class function which is called automatically as soon as the object is created is called as', 27),
(56, 'The programs machine instructions are store in __ memory segment', 27),
(57, 'Identify the C++ compiler of Linux', 27),
(58, 'By default the members of the structure are', 27),
(59, 'What is meant by template parameter?', 27),
(60, 'Which parameter is legal for non-type template?', 27),
(61, 'What is other name of full specialization?', 27),
(62, 'How many bits of memory needed for internal representation of a class?', 27),
(63, 'What is the ability to group some lines of code that can be included in the program?', 27),
(64, 'What is the avarage length of salmon?', 26),
(65, 'What does the client module import?', 27),
(66, 'Ann has 10 cookies, Ben has 8 cookies, Carl has more cookies than Ben but less than Ann. How much cookies they have in total ?', 25),
(67, 'What is the world-record for the weight of a fish ? (in pounds)', 26),
(68, 'What is the general syntax for accessing the namespace variable?', 27),
(69, 'Where does a cin stops during extraction of data?', 27),
(70, 'Choose a set of freshwater fish:', 26),
(71, 'What is the largest two digits prime number?', 25),
(72, 'Which is not a fish:', 26),
(73, 'Which is the largest number in 15/17, 15/18, 15/19, 15/21?', 25),
(74, 'What is the average value of 20, 21 and 22?', 25),
(75, 'What is an example of dynamic binding?', 27),
(76, 'How many teeth has a shark?', 26),
(77, 'What is the sum of one digit prime numbers?', 25),
(78, 'For which case would the use of a static attribute be appropriate?', 27),
(79, 'How many hours in 90 minutes?', 25),
(80, 'Why would you create an abstract class, if it can have no real instances?', 27),
(81, 'Choose the best bait for pike:', 26),
(85, 'When does static binding happen?', 27),
(86, 'Choose the biggest mammal:', 26),
(87, 'How long does the avarage giraffe live? ( in years)', 26),
(88, 'What is the best reason to use a design pattern?', 27),
(89, 'What is encapsulation?', 27),
(90, 'What is an IS-A relationship?', 27),
(91, 'Which code creates a new object from the Employee class?', 27),
(92, 'Which type of constructor cannot have a return type?', 27),
(93, 'Which of the following is NOT an advantage of using getters and setters?', 27),
(94, 'What is avarage length of giraffes neck?', 26);

DROP TABLE IF EXISTS `QuestionsSet`;
CREATE TABLE `QuestionsSet` (
  `CategoryID` int(11) NOT NULL,
  `QuestionID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `QuestionsSet` (`CategoryID`, `QuestionID`) VALUES
(4, 24),
(4, 25),
(4, 50),
(5, 26),
(5, 27),
(5, 30),
(5, 71),
(5, 73),
(5, 74),
(5, 77),
(5, 79),
(7, 28),
(7, 29),
(8, 34),
(8, 36),
(8, 37),
(8, 38),
(8, 39),
(8, 40),
(9, 31),
(9, 32),
(9, 33),
(10, 41),
(10, 42),
(10, 43),
(10, 44),
(10, 45),
(11, 35),
(11, 46),
(11, 47),
(11, 48),
(12, 64),
(12, 67),
(12, 70),
(12, 72),
(12, 76),
(12, 81),
(19, 55),
(19, 56),
(19, 57),
(19, 58),
(19, 59),
(19, 60),
(19, 61),
(19, 62),
(19, 63),
(19, 65),
(19, 68),
(19, 69),
(20, 75),
(20, 78),
(20, 80),
(20, 85),
(20, 88),
(20, 89),
(20, 90),
(20, 91),
(20, 92),
(20, 93);

DROP TABLE IF EXISTS `Quiz`;
CREATE TABLE `Quiz` (
  `QuizID` int(11) NOT NULL,
  `CategoryID` int(11) DEFAULT NULL,
  `QuizTitle` varchar(50) NOT NULL,
  `StartDate` datetime NOT NULL,
  `EndDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Quiz` (`QuizID`, `CategoryID`, `QuizTitle`, `StartDate`, `EndDate`) VALUES
(77, 8, 'GeoTest!', '2021-06-12 18:02:00', '2021-06-12 20:02:00'),
(78, 5, 'FaceAlgebra', '2021-06-12 17:11:00', '2021-06-12 20:11:00'),
(79, 5, 'Basic Algebra Test', '2021-06-12 19:40:00', '2021-06-12 20:00:00');

DROP TABLE IF EXISTS `QuizParticipant`;
CREATE TABLE `QuizParticipant` (
  `QuizID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `Score` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `QuizParticipant` (`QuizID`, `UserID`, `Score`) VALUES
(77, 25, 3),
(78, 25, 0),
(79, 25, 2),
(78, 27, 0),
(79, 27, 0),
(79, 28, 5);

DROP TABLE IF EXISTS `QuizSet`;
CREATE TABLE `QuizSet` (
  `QuizID` int(11) NOT NULL,
  `QuestionID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `QuizSet` (`QuizID`, `QuestionID`) VALUES
(77, 36),
(77, 37),
(77, 38),
(77, 39),
(77, 40),
(78, 26),
(78, 27),
(78, 30),
(79, 26),
(79, 27),
(79, 30),
(79, 73),
(79, 74),
(79, 77),
(79, 79);

DROP TABLE IF EXISTS `User`;
CREATE TABLE `User` (
  `UserID` int(11) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `Password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `User` (`UserID`, `FirstName`, `LastName`, `Email`, `Password`) VALUES
(25, 'Jan', 'Kowalski', 'adres@email.com', 'password'),
(26, 'Anna', 'Nowak', 'student@poczta.pl', 'student'),
(27, 'Pawel', 'Dobrowolski', 'pawel.dob@email.pl', 'pawlo123'),
(28, 'Bolek', 'Bolkowski', 'super@hero.pl', 'super123');


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
  MODIFY `AnswerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=361;
ALTER TABLE `Category`
  MODIFY `CategoryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
ALTER TABLE `Class`
  MODIFY `ClassID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
ALTER TABLE `Question`
  MODIFY `QuestionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=95;
ALTER TABLE `Quiz`
  MODIFY `QuizID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;
ALTER TABLE `User`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

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
