create table Category
(
    CategoryID   int auto_increment
        primary key,
    ClassID      int        not null,
    Categoryname linestring not null,
    constraint Category_Class_ClassID_fk
        foreign key (ClassID) references Class (ClassID)
);

create table Question
(
    QuestionID int auto_increment,
    Data       linestring not null,
    UserID     int        not null,
    constraint Question_QuestionID_uindex
        unique (QuestionID),
    constraint Question_User_UserID_fk
        foreign key (UserID) references User (UserID)
);

alter table Question
    add primary key (QuestionID);

create table Answer
(
    AnswerID   int auto_increment,
    QuestionID int        not null,
    Sentence   linestring not null,
    IsCorrect  bit        not null,
    constraint Answer_AnswerID_uindex
        unique (AnswerID),
    constraint Answer_Question_QuestionID_fk
        foreign key (QuestionID) references Question (QuestionID)
);

alter table Answer
    add primary key (AnswerID);
    

create table QuestionsSet
(
    CategoryID int not null,
    QuestionID int not null,
    constraint QuestionsSet_Category_CategoryID_fk
        foreign key (CategoryID) references Category (CategoryID),
    constraint QuestionsSet_Question_QuestionID_fk
        foreign key (QuestionID) references Question (QuestionID)
);

create table Class
(
    ClassID   int auto_increment
        primary key,
    Name      linestring               not null,
    Owner     int                      not null,
    ClassCode varchar(10) charset utf8 not null,
    constraint Class_ClassCode_uindex
        unique (ClassCode),
    constraint Class_User_UserID_fk
        foreign key (Owner) references User (UserID)
);

create table ClassParticipant
(
    UserID   int      not null,
    ClassID  int      not null,
    JoinDate datetime not null,
    constraint ClassParticipant_Class_ClassID_fk
        foreign key (ClassID) references Class (ClassID),
    constraint ClassParticipant_User_UserID_fk
        foreign key (UserID) references User (UserID)
);

create table Quiz
(
    QuizID     int auto_increment
        primary key,
    CategoryID int        null,
    QuizTitle  linestring not null,
    StartDate  datetime   not null,
    EndDate    datetime   not null,
    constraint Quiz_Category_CategoryID_fk
        foreign key (CategoryID) references Category (CategoryID)
);

create table QuizParticipant
(
    QuizID int not null,
    UserID int not null,
    Score  int not null,
    constraint QuizParticipant_Quiz_QuizID_fk
        foreign key (QuizID) references Quiz (QuizID),
    constraint QuizParticipant_User_UserID_fk
        foreign key (UserID) references User (UserID)
);

create table QuizSet
(
    QuizID     int not null,
    QuestionID int not null,
    constraint QuizSet_Question_QuestionID_fk
        foreign key (QuestionID) references Question (QuestionID),
    constraint QuizSet_Quiz_QuizID_fk
        foreign key (QuizID) references Quiz (QuizID)
);

create table User
(
    UserID    int auto_increment
        primary key,
    FirstName linestring not null,
    LastName  linestring not null,
    Email     linestring not null,
    Password  linestring not null
);
