USE LocalDB
go
CREATE SCHEMA Project;
go

CREATE TABLE Project.[User](
    UserID          INT IDENTITY(1,1) ,
    Email           VARCHAR(50) UNIQUE    NOT NULL,
    [Password]        VARBINARY(64)     NOT NULL,
    RegisterDate    DATE            NOT NULL,
    PRIMARY KEY (USERID)
);

CREATE TABLE Project.[Admin](
    USERID      INT,
    PRIMARY KEY (USERID)
);

CREATE TABLE Project.Client(
    UserID          INT,
    Username        VARCHAR(50)   UNIQUE   NOT NULL,
    FullName        VARCHAR(max),
    Sex             CHAR,
    Birth           DATE,
    Balance         DECIMAL(5,2) CHECK (Balance >=0),
    PRIMARY KEY (USERID)
);

CREATE TABLE Project.Follows(
    IDFollower  INT,
    IDFollowed  INT,
    PRIMARY KEY (IDFollower,IDFollowed),
    FOREIGN KEY (IDFollower) REFERENCES Project.Client(UserID),
    FOREIGN KEY (IDFollowed) REFERENCES Project.Client(UserID),
);

CREATE TABLE Project.Credit(

    NumCredit     INT      IDENTITY(1,1)       NOT NULL,
    MetCredit     VARCHAR(20)     NOT NULL,
    DateCredit    DATE            NOT NULL,
    ValueCredit   Decimal(4,2)    NOT NULL,
    IDClient      INT             NOT NULL,
    PRIMARY KEY (NumCredit)
);


CREATE TABLE Project.Reviews(
    IDReview        INT                 IDENTITY(1,1),
    Title           VARCHAR(50)      CHECK(len(Title) > 0)   NOT NULL,
    Text            VARCHAR(280)     CHECK(len(Text) > 0) NOT NULL,
    Rating          DECIMAL(2,1)        NOT NULL,  
    DateReview      DATE                NOT NULL,
    UserID          INT                 NOT NULL,
    IDGame          INT                 NOT NULL,
    PRIMARY KEY (IDReview),
    CONSTRAINT Chk_rat CHECK (Rating >= 0 AND Rating <= 5)          
);

CREATE TABLE Project.Purchase(
    NumPurchase         INT IDENTITY(1,1) ,
    Price               DECIMAL (5,2)      CHECK(Price >= 0) NOT NULL,
    PurchaseDate        DATE                NOT NULL,
    IDClient            INT                 NOT NULL,
    SerialNum           INT                 NOT NULL,
    PRIMARY KEY(NumPurchase)
);

CREATE TABLE Project.Game(

    IDGame          INT				IDENTITY(1,1),
    Name            VARCHAR(50)     NOT NULL,
    Description     VARCHAR(MAX),
    ReleaseDate     DATE            NOT NULL,
    AgeRestriction  INT             NOT NUll,
    CoverImg        VARCHAR(MAX),
    Price           Decimal(5,2)   CHECK(Price >= 0)  NOT NULL,
	IDCompany       INT             NOT NULL,
	IDFranchise    INT,
    CONSTRAINT chk_AgeRestrict CHECK (AgeRestriction >= 1 AND AgeRestriction <= 18),
    PRIMARY KEY(IDGame)
);

CREATE TABLE Project.[Copy](
    SerialNum       INT IDENTITY(100000,1)   NOT NULL,
    IDGame          INT					NOT NULL,
	PlatformName	VARCHAR(30)			NOT NULL,
    PRIMARY KEY(SerialNum)

);


CREATE TABLE Project.Company(
    IDCompany       INT			IDENTITY(1,1),
    Contact         VARCHAR(50), --our contact will only be the email of the companies
    CompanyName     VARCHAR(30) NOT NULL,
    Website         VARCHAR(50) NOT NULL,
    Logo            VARBINARY(MAX),
    FoundationDate  DATE,
    City            VARCHAR(50),
    Country	        VARCHAR(50),
    PRIMARY KEY (IDCompany)
);


CREATE TABLE Project.Discount(

    PromoCode         INT     NOT NULL,
    Percentage        INT     NOT NULL,
    DateBegin         DATE    NOT NULL,
    DateEnd           DATE    NOT NULL,
    PRIMARY KEY(PromoCode),
    CONSTRAINT chk_Discount CHECK (Percentage >= 0 AND Percentage <= 100)
);



CREATE TABLE Project.DiscountGame(

    PromoCode           INT     NOT NULL,
    IDGame              INT     NOT NULL,
    PRIMARY KEY(PromoCode,IDGame),
);


CREATE TABLE Project.[Platform](

    PlatformName       VARCHAR(30)     NOT NULL,
    ReleaseDate         DATE            NOT NULL,
    Producer            VARCHAR(30)     NOT NULL,
    PRIMARY KEY(PlatformName)
);

CREATE TABLE Project.PlatformReleasesGame(

    IDGame          INT             NOT NULL,
    PlatformName  VARCHAR(30)     NOT NULL,
    PRIMARY KEY(IDGame,PlatformName)
);

CREATE TABLE Project.Genre(
    GenName           VARCHAR(25)     NOT NULL,
    Description       VARCHAR(max),
    PRIMARY KEY(GenName)
);

CREATE TABLE Project.GameGenre(
    IDGame          INT         NOT NULL,
    GenName         VARCHAR(25) NOT NULL,
    PRIMARY KEY(IDGame,GenName)
);


CREATE TABLE Project.Franchise(
    IDFranchise    INT				IDENTITY(1,1),
    Name           VARCHAR(30)      NOT NULL,
    Logo       VARBINARY(MAX),
	IDCompany INT NOT NULL, 
    PRIMARY KEY(IDFranchise)
);





-- Foreign keys
ALTER TABLE Project.[Admin] ADD CONSTRAINT AdminID FOREIGN KEY (UserID) REFERENCES Project.[User](UserID);
ALTER TABLE Project.Credit  ADD CONSTRAINT CredClient FOREIGN KEY(IDClient) REFERENCES Project.Client(UserID);
ALTER TABLE Project.Reviews ADD CONSTRAINT RevClient FOREIGN KEY(UserID) REFERENCES Project.Client(UserID);
ALTER TABLE Project.Reviews ADD CONSTRAINT RevGame FOREIGN KEY(IDGame) REFERENCES Project.Game(IDGame);
ALTER TABLE Project.Purchase ADD CONSTRAINT ClientPurchase FOREIGN KEY(IDClient) REFERENCES Project.Client(UserID);
ALTER TABLE Project.Purchase ADD CONSTRAINT GamePurchase FOREIGN KEY(SerialNum) REFERENCES Project.[Copy](SerialNum);
ALTER TABLE Project.Client ADD CONSTRAINT ClientID FOREIGN KEY(UserID) REFERENCES Project.[User](UserID);
ALTER TABLE Project.Game ADD CONSTRAINT   IDCompanyGame  FOREIGN KEY (IDCompany) REFERENCES Project.Company(IDCompany);
ALTER TABLE Project.Game ADD CONSTRAINT   IDFranchiseGame  FOREIGN KEY (IDFranchise) REFERENCES Project.Franchise(IDFranchise);
ALTER TABLE Project.[Copy] ADD CONSTRAINT CopyGame FOREIGN KEY(IDGame) REFERENCES Project.Game(IDGame);
ALTER TABLE Project.[Copy] ADD CONSTRAINT CopyPlatform FOREIGN KEY(PlatformName) REFERENCES Project.[Platform](PlatformName);
ALTER TABLE Project.PlatformReleasesGame ADD CONSTRAINT LaunchedGame FOREIGN KEY(IDGame) REFERENCES Project.Game(IDGame);
ALTER TABLE Project.PlatformReleasesGame ADD CONSTRAINT PlatformGame FOREIGN KEY(PlatformName) REFERENCES Project.[Platform](PlatformName);
ALTER TABLE Project.DiscountGame ADD CONSTRAINT CodDiscount FOREIGN KEY (PromoCode) REFERENCES Project.Discount(PromoCode);
ALTER TABLE Project.DiscountGame ADD CONSTRAINT CodGame FOREIGN KEY (IDGame) REFERENCES Project.Game(IDGame);
ALTER TABLE Project.GameGenre ADD CONSTRAINT  GenGame FOREIGN KEY (IDGame) REFERENCES Project.Game(IDGame);
ALTER TABLE Project.GameGenre ADD CONSTRAINT  GenName FOREIGN KEY (GenName) REFERENCES Project.Genre(GenName);
ALTER TABLE Project.Franchise ADD CONSTRAINT  Comp FOREIGN KEY (IDCompany) REFERENCES Project.Company(IDCompany);



-- Inserts


-- insert users

INSERT INTO Project.[User](Email,[Password],RegisterDate) VALUES('brunobastos@gmail.com',ENCRYPTBYPASSPHRASE('**********','password'), '2018-04-04')
INSERT INTO Project.[User](Email,[Password],RegisterDate) VALUES('client@gmail.com', ENCRYPTBYPASSPHRASE('**********','client'), '2018-11-02')
INSERT INTO Project.[User](Email,[Password],RegisterDate) VALUES('NancyKim@gmail.com', ENCRYPTBYPASSPHRASE('**********','HelloWorld'), '2019-11-02')
INSERT INTO Project.[User](Email,[Password],RegisterDate) VALUES('timcarrey@outlook.com', ENCRYPTBYPASSPHRASE('**********','notjimcarrey?'), '2019-12-10')
INSERT INTO Project.[User](Email,[Password],RegisterDate) VALUES('KareemCorbett@gmail.com', ENCRYPTBYPASSPHRASE('**********', '8gMxBJMube'), '2018-10-23')
INSERT INTO Project.[User](Email,[Password],RegisterDate) VALUES('CocoNava@gmail.com', ENCRYPTBYPASSPHRASE('**********', 'yFxeZXdcaX'), '2018-11-11')
INSERT INTO Project.[User](Email,[Password],RegisterDate) VALUES('dominik_stokes@gmail.com', ENCRYPTBYPASSPHRASE('**********','jDeTicDbvf'), '2018-09-22')
INSERT INTO Project.[User](Email,[Password],RegisterDate) VALUES('Wesley_Shields@gmail.com', ENCRYPTBYPASSPHRASE('**********','65bdSkgCqe'), '2019-01-20')
INSERT INTO Project.[User](Email,[Password],RegisterDate) VALUES('leandrocoelhom@gmail.com', ENCRYPTBYPASSPHRASE('**********','BxjthfZPFX'), '2020-01-01')
INSERT INTO Project.[User](Email,[Password],RegisterDate) VALUES('procsplayerdaubi@gmail.com', ENCRYPTBYPASSPHRASE('**********','sLMfQeyTT6'), '2019-12-02')


-- insert admin
INSERT INTO Project.[Admin](UserID) VALUES (1);

--insert clients 
INSERT INTO Project.Client(UserID,Username,FullName,Sex,Birth,Balance) Values(2,'JohnyS','John Kerry Smith','M','2000-10-05',12.00)
INSERT INTO Project.Client(UserID,Username,FullName,Sex,Birth,Balance) Values(3,'NKimmy','Nancy Black Kim','F','1999-01-01',0.00)
INSERT INTO Project.Client(UserID,Username,FullName,Sex,Birth,Balance) Values(4,'TimJ0Carrey','Tim John Carrey','M','1993-04-15',32.56)
INSERT INTO Project.Client(UserID,Username,FullName,Sex,Birth,Balance) Values(5,'CorKareembett','Kareem Zinca Corbett','F','1975-12-13',9.99)
INSERT INTO Project.Client(UserID,Username,FullName,Sex,Birth,Balance) Values(6,'Aceu','Coco Nava','M','1990-10-20',0.00)
INSERT INTO Project.Client(UserID,Username,FullName,Sex,Birth,Balance) Values(7,'Shroud','Dominik Billy White Armstrong Stokes','M','1978-05-12',0.00)
INSERT INTO Project.Client(UserID,Username,FullName,Sex,Birth,Balance) Values(8,'Zorlakoka','Wesley Marvel Shields','M','1983-03-15',0.00)
INSERT INTO Project.Client(UserID,Username,FullName,Sex,Birth,Balance) Values(9,'Leav0n','Leandro Leonardo Lionel Silva','M','2000-09-19',0.00)
INSERT INTO Project.Client(UserID,Username,FullName,Sex,Birth,Balance) Values(10,'AceDestiny','Chico Carry Me Silva','M','2000-06-27',0.00)

-- inser Company

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('beth@softworks.com','Bethesda Softworks','www.bethesda.net',NULL,'1986-06-28','Rockville, Maryland','United States');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('privacy_policy@ea.com','Electronic Arts', 'www.ea.com',NULL,'1982-05-27', 'Redwood City,California','United States');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('squareenix@se.com','	Square Enix','www.square-enix-games.com',NULL,'1975-09-22','Shinjuku, Tokyo','Japan');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('rockstargames@rs.com','Rockstar Games','www.rockstargames.com',NULL,'1998-12-01','New York City, New York','United States');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('beth@softworks.com','Tencent Games','www.tencent.com',NULL,'1998-11-11','Nanshan,Shenzen','China');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('easports@ea.com','EA Sports','www.easports.com',NULL,'1991-01-01','Redwood City,California','United States');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('konami@pes.com','Konami','www.konami.com',NULL,'1969-03-21','Tokyo','Japan');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('sonygames@sony.com','Sony Interactive Entertainment','www.sie.com',NULL,'1993-11-16','San Mateo, California','United States');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('microstudios@micro.pt','Xbox Game Studios','www.microsoftstudios.com',NULL,'2002-01-01','Redmond, Washington','United States');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('activision@contact.com','Activision','www.activision.com',NULL,'1979-10-01','Santa Monica, California','United States');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('billing@blizzard.com','Blizzard Entertainment','www.blizzard.com',NULL,'1991-02-08','Irving, California','United States');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('dmca@noa.nintendo.com','Nintendo','www.nintendo.com',NULL,'1889-09-23','Kyoto','Japan');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('bandai@namco.com','BANDAI NAMCO Entertainment','www.bandainamcoent.com',NULL,'2006-03-31','	Tokyo','Japan');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('cap@com.com','Capcom','www.capcom.co.jp',NULL,'1979-05-30','Osaka','Japan');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('press@wizards.com','Wizards of the Coast','company.wizards.com',NULL,'1990-01-01','Renton, Washington','United States');
    
INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('ubi@mail.com','Ubisoft','www.ubisoft.com',NULL,'1986-03-12','Montreuil','France');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('contact@epic.com','Epic Games','www.epicgames.com',NULL,'1991-01-01','Cary, North Carolina','United States');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES (NULL,'Riot games','www.riotgames.com',NULL,'2006-08-31','Los Angeles, California','United States');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('contact@valvesoftware.com','Valve','www.valvesoftware.com',NULL,'1996-09-24','Belleveue, Washington','United States');

INSERT INTO Project.Company(Contact,CompanyName,Website,Logo,FoundationDate,City,Country) 
VALUES ('wbsf@warnerbros.com','Warner Bros Int. Entertainment','www.wbgames.com',NULL,'1993-06-23','Burbank, California','United States');

-- insert franchise

INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Mario',12);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Pokemon',12);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Grand Theft Auto',4);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('FIFA',2);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Call of Duty',10);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Left 4 Dead',19);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Need For Speed',2);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Assassins Creed',16);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Far Cry',16);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Pro Evolution Soccer',7);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('The Legend Of Zelda',12);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Battlefield',2);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Uncharted',8);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Resident Evil',14);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Halo',9);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Tomb Raider',3);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('The Elder Scrolls',1);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Counter Strike',19);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('God Of War',8);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Warcraft',11);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Forza',9);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Mass Effect',9);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Tekken',13);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Street Fighter',14);
INSERT INTO Project.Franchise(Name,IDCompany) VALUES ('Borderlands',8);


-- insert genre

INSERT INTO Project.Genre(GenName,Description) VALUES('Action','Action games are just that�games where the player is in control of and at the center of the action, which is mainly comprised of physical challenges players must overcome.');
INSERT INTO Project.Genre(GenName,Description) VALUES('Platformer','Platformer games get their name from the fact that the game�s character interacts with platforms throughout the gameplay.');
INSERT INTO Project.Genre(GenName,Description) VALUES('Shooter','Shooters let players use weapons to engage in the action, with the goal usually being to take out enemies or opposing players.');
INSERT INTO Project.Genre(GenName,Description) VALUES('Fighting','Fighting games like Mortal Kombat and Street Fighter II focus the action on combat, and in most cases, hand-to-hand combat.');
INSERT INTO Project.Genre(GenName,Description) VALUES('Adventure','Adventure games are categorized by the style of gameplay, not the story or content. And while technology has given developers new options to explore storytelling in the genre, at a basic level, adventure games haven�t evolved much from their text-based origins.');
INSERT INTO Project.Genre(GenName,Description) VALUES('Role-Playing','Probably the second-most popular game genre, role-playing games, or RPGs, mostly feature medieval or fantasy settings. ');
INSERT INTO Project.Genre(GenName,Description) VALUES('MMORPG','MMORPGs involve hundreds of players actively interacting with each other in the same world, and typically, all players share the same or a similar objective.');
INSERT INTO Project.Genre(GenName,Description) VALUES('Strategy','With gameplay is based on traditional strategy board games, strategy games give players a godlike access to the world and its resources. ');
INSERT INTO Project.Genre(GenName,Description) VALUES('Battle Royale','A battle royale game is a genre that blends the survival, exploration and scavenging elements of a survival game with last man standing gameplay g to stay in safe playable area which shrinks as the time passes, with the winner being the last competitor in the game');
INSERT INTO Project.Genre(GenName,Description) VALUES('Sports','Sports games simulate sports like golf, football, basketball, baseball, and soccer. They can also include Olympic sports like skiing, and even pub sports like darts and pool.');
INSERT INTO Project.Genre(GenName,Description) VALUES('Puzzle','Puzzle or logic games usually take place on a single screen or playfield and require the player to solve a problem to advance the action.');
INSERT INTO Project.Genre(GenName,Description) VALUES('Idle','Idle games are simplified games that involve minimal player involvement, such as clicking on an icon over and over. Idle games keep players engaged by rewarding those who complete simple objectives.');
INSERT INTO Project.Genre(GenName,Description) VALUES('Racing','Racing simulator series like Forza and Gran Turismo are some of the most popular games in this category, but arcade classics like Pole Position are included here too. In these games, players race against another opponent or the clock.');
INSERT INTO Project.Genre(GenName,Description) VALUES('MOBA','This category combines action games, role-playing games, and real-time strategy games. In this subgenre of strategy games, players usually do not build resources such as bases or combat units.');
INSERT INTO Project.Genre(GenName,Description) VALUES('Simulation','Games in the simulation genre have one thing in common�they are all designed to emulate real or fictional reality, to simulate a real situation or event.');
INSERT INTO Project.Genre(GenName,Description) VALUES('Side-Scrolling','A side-scrolling game is a video game in which the gameplay action is viewed from a side-view camera angle, and as the players character moves left or right, the screen scrolls with them. These games make use of scrolling computer display technology.');
INSERT INTO Project.Genre(GenName,Description) VALUES('Survival','The survival horror game Resident Evil was one of the earliest (though a linear game), while more modern survival games like Fortnite take place in open-world game environments and give players access to resources to craft tools, weapons, and shelter to survive as long as possible.');


-- insert platform

INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('Xbox 360','2005-11-22', 'Microsoft' );
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('Xbox One','2013-11-22', 'Microsoft' );
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('Windows 7','2009-07-22', 'Microsoft' );
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('Windows 10','2015-07-29', 'Microsoft' );
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('PlayStation','1994-12-03', 'Sony' );
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('PlayStation 2','2000-03-04', 'Sony' );
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('PlayStation 3','2006-11-11', 'Sony' );
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('PlayStation 4','2005-11-13', 'Sony' );
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('PlayStation Portable','2004-12-12', 'Sony' );
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('PlayStation Vita','2011-12-17', 'Microsoft' );
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('Nintendo DS', '2004-12-02','Nintendo' );
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('Nintendo 3DS', '2011-02-26', 'Nintendo');
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('Wii', '2006-11-19', 'Nintendo' );
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('Nintendo Switch', '2017-03-03', 'Nintendo');
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('Nintendo 64', '1996-06-23','Nintendo' );
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('GameCube', '2001-09-14','Nintendo');
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('Wii U', '2012-11-18','Nintendo');
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('MacOS', '2018-11-24', 'Apple');
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('iOS', '2007-06-29','Apple');
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('Android', '2006-09-28','Google');
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('Linux', '1991-04-20', 'Linux');
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('Sega Saturn', '1994-11-22','Sega');
INSERT INTO Project.[Platform](PlatformName,ReleaseDate,Producer) VALUES ('Dreamcast', '1998-11-27','Sega' );

-- insert follows

INSERT INTO Project.Follows(IDFollowed,IDFollower) VALUES(2,3);
INSERT INTO Project.Follows(IDFollowed,IDFollower) VALUES(2,4);
INSERT INTO Project.Follows(IDFollowed,IDFollower) VALUES(2,5);
INSERT INTO Project.Follows(IDFollowed,IDFollower) VALUES(2,6);
INSERT INTO Project.Follows(IDFollowed,IDFollower) VALUES(3,2);
INSERT INTO Project.Follows(IDFollowed,IDFollower) VALUES(4,5);
INSERT INTO Project.Follows(IDFollowed,IDFollower) VALUES(5,6);

-- insert games


INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Super Mario 64','Super Mario 64 is a 1996 platform video game for the Nintendo 64.','1996-06-23',3,3.99, 12 ,1,'i.ya-webdesign.com/images/super-mario-64-png-8.png')

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany, IDFranchise,CoverImg) 
VALUES('New Super Mario Bros.','New Super Mario Bros. is a side-scrolling video game.',
'2006-05-01',3, 3.99, 12 , 1, 'yuzu-emu.org/images/game/boxart/new-super-mario-bros-u-deluxe.png' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany, IDFranchise,CoverImg) 
VALUES('Super Mario Run','Super Mario Run is a 2016 side-scrolling platform mobile game developed and published by Nintendo.',
'2016-12-15',3,1.99,12, 1,'a.thumbs.redditmedia.com/N9gGTwEaZJ3D2iGF13A-RRNgeqgPbkNr1jetwhXIVQ0.png')

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Pokemon Red','Pokemon Red Version is role-playing video game developed by Game Freak and published by Nintendo.'
,'1996-03-27', 3 ,9.99, 12 , 2,'tecnoblog.net/wp-content/uploads/2011/08/ruby-saphire.jpg' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Pokemon Sword','Pokemon Sword is a role-playing video game developed by Game Freak and published by Nintendo.','2019-11-15', 3 ,59.99, 12 , 2,'www.speedrun.com/themes/pkmnswordshield/cover-256.png' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Grand Theft Auto V','Grand Theft Auto V is a 2013 action-adventure game published by Rockstar Games.','2013-09-17', 18 ,59.99, 4 , 3,'pngimage.net/wp-content/uploads/2018/06/gta-v-icon-png-2.png' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('FIFA Football 2004','FIFA Football 2004 is a football video game developed and published by Electronic Arts','2003-10-24', 3 ,59.99, 6 , 4,'upload.wikimedia.org/wikipedia/en/thumb/e/e3/FIFA_Football_2004_cover.jpg/250px-FIFA_Football_2004_cover.jpg' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise, CoverImg) 
VALUES('FIFA 20','FIFA 20 is a football simulation video game published by Electronic Arts as part of the FIFA series.','2019-07-19', 3 ,59.99, 6 , 4,'1.bp.blogspot.com/-rD96Hu8rAyw/XYeClZZIlWI/AAAAAAAABD0/Uocets3DupIJNQgFFAe8l0Hq8Vi5RFOtgCEwYBhgL/s1600/fifa20.jpg' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Call of Duty : Black Ops 2','Call of Duty: Black Ops II is a 2012 first-person shooter published by Activision.','2012-11-12', 18 ,11.99, 10 ,5,'pbs.twimg.com/profile_images/2772600693/ca93f6313b2310cfb4dfdb6c11366775.jpeg' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Call of Duty : World at War','Call of Duty: World at War is a 2008 first-person shooter video game published by Activision. ','2008-11-11', 18 ,4.99, 10 , 5,'p1.hiclipart.com/preview/850/213/205/the-call-of-duty-series-icon-2003-2011-world-at-war-call-of-duty-world-at-war-illustration-png-clipart.jpg' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Left 4 Dead 2','Left 4 Dead 2 is a 2009 multiplayer survival horror game developed and published by Valve.','2009-11-17', 18 ,5.99, 19 , 6,'steamuserimages-a.akamaihd.net/ugc/845968188390814023/37674AD466665B9F4E540AAE7128C51D0C59A1D1/' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Need For Speed : Most Wanted','Need for Speed: Most Wanted is an open world racing game published by Electronic Arts.','2012-10-30', 3 ,10.99, 2 , 7,'cdn6.aptoide.com/imgs/0/e/4/0e492e0ec8a53fa7c3c1fbf5e58c6322_icon.png?w=256' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Need For Speed : Shift','Need for Speed: Shift is the 13th installment of the racing video game franchise Need for Speed.','2009-07-15', 3 ,4.99, 2 , 7,'images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/i/8dd91536-f09a-487f-838f-140f69ff9d8a/d5reyzt-658a6e08-0dd5-458a-8227-46ed76d956fa.png/v1/fill/w_256,h_256,q_80,strp/need_for_speed_shift_icon_for_obly_tile_by_enigmaxg2_d5reyzt-fullview.jpg' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Assassins Creed II','Assassins Creed II is a 2009 action-adventure video game developed published by Ubisoft.','2009-11-17', 18 ,9.99, 16 , 8, 'images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/i/8dd91536-f09a-487f-838f-140f69ff9d8a/d5ws6i1-1fb4c643-f683-4f93-9f23-bd20f0535403.png/v1/fill/w_256,h_256,q_80,strp/assassin_s_creed_2_icon_for_obly_tile_by_enigmaxg2_d5ws6i1-fullview.jpg' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Assassins Creed IV: Black Flag','Assassins Creed IV: Black Flag is an action-adventure video game published by Ubisoft.','2013-10-29', 18 ,19.99, 16 , 8,'pbs.twimg.com/profile_images/3321242353/74d0589d590170d9a6c914496ffb81d2.jpeg' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Far Cry 3','Far Cry 3 is a 2012 first-person shooter developed by Ubisoft Montreal and published by Ubisoft.','2012-11-29', 18 ,19.99, 16 , 9,'c-sf.smule.com/sf/s34/arr/6e/75/11178429-7c20-4335-8c8e-7771de9945b9.jpg' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Far Cry 5','Far Cry 5 is a first-person shooter game published by Ubisoft, the 5th game in the Far Cry series.','2018-03-27', 18 ,49.99, 16 , 9,'turkce-yama.com/wp-content/uploads/FarCry-5-Simge-256x256.png' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Pro Evolution Soccer 2019','Pro Evolution Soccer 2019 is a football simulation video game published by Konami','2019-08-08', 3 ,39.99, 7 , 10,'i.pinimg.com/474x/15/e8/fa/15e8fa57c4588318250d2676c9f40a56.jpg' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise, CoverImg) 
VALUES('The Legend of Zelda: Breath of the Wild','The Legend of Zelda: Breath of the Wild is an action-adventure game developed and published by Nintendo','2017-03-03', 3 ,59.99, 12 , 11, 'i.pinimg.com/474x/15/e8/fa/15e8fa57c4588318250d2676c9f40a56.jpg' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Uncharted: Drakes Fortune', 'Uncharted: Drakes Fortune is a 2007 action-adventure game published by Sony Computer Entertainment. It is the first game in the Uncharted series.','2007-1-20', 3 ,9.99, 1 , 13,'static.truetrophies.com/boxart/Game_986.png' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Uncharted 4: A Thiefs End' , 'Uncharted 4: A Thiefs End is a 2016 action-adventure game published by Sony Computer Entertainment.','2007-1-20', 3 ,9.99, 1 , 13,'www.truetrophies.com/boxart/Game_4209.png' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Battlefield 4','Battlefield 4 is a first-person shooter video game developed by video game developer EA DICE and published by Electronic Arts','2013-10-29', 18 ,39.99, 2 , 12,'vectorified.com/images/battlefield-4-icon-16x16-33.png' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Resident Evil 2','Resident Evil 2 is a survival horror game developed and published by Capcom.','2019-01-25', 18 ,39.99, 14 , 14,'static.truetrophies.com/boxart/Game_8024.jpg' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Halo 5 : Guardian','Halo 5: Guardians is a first-person shooter video game developed by 343 Industries and published by Microsoft Studios','2015-10-17', 16 ,39.99, 9 , 15,'avatarfiles.alphacoders.com/123/123823.png' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Shadow of the Tomb Raider','Shadow of the Tomb Raider is an action-adventure video game published by Square Enix.','2018-09-12', 18 ,20.00, 3 , 16,'www.truetrophies.com/boxart/Game_7519.jpg' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('The Elder Scrolls V: Skyrim','The Elder Scrolls V: Skyrim is an action role-playing video game published by Bethesda Softworks.','2011-11-11', 12, 19.99, 1 , 17,'images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/i/78aa3687-9f6e-45cc-9450-47d0978a810d/d39n68b-07b03bff-a1c3-4417-be06-a228a0ab0cff.png/v1/fill/w_256,h_256,q_80,strp/elder_scrolls_v___skyrim_icon_by_bonscha_d39n68b-fullview.jpg' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Counter Strike Global Offensive','Counter-Strike: Global Offensive is a multiplayer first-person shooter video game developed by Valve and Hidden Path Entertainment.','2012-08-21', 18 ,10.00, 19 , 18,'p1.hiclipart.com/preview/915/443/598/counter-strike-go-game-icon-pack-cs-go-6-png-icon.jpg' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('God Of War','God of War is an action-adventure game developed by Santa Monica Studio and published by Sony Interactive Entertainment.','2018-04-20', 18 ,40.00, 8 , 19,'avatarfiles.alphacoders.com/222/222728.jpg' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Warcraft III: Reign of Chaos','Warcraft III: Reign of Chaos is a high fantasy real-time strategy computer video game developed and published by Blizzard Entertainment released in July 2002. It is the second sequel to Warcraft: Orcs & Humans','2002-07-03', 16 ,5.00, 11 , 20,'dl1.cbsistatic.com/i/2016/07/12/f3f4e353-38aa-4de9-8c87-a6ad905ce9e9/d900d0e88d0f97b1464494805baac237/imgingest-6030158764582817665.png' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Mass Effect: Andromeda','Mass Effect: Andromeda is an action role-playing video game developed by BioWare and published by Electronic Arts.','2017-03-21', 16 ,45.00, 2 , 22,'m.media-amazon.com/images/I/51zkf-kP5yL._AA256_.jpg' )

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Tekken 7','Tekken 7 is a fighting game developed and published by Bandai Namco Entertainment.','2015-03-18', 18 ,49.99, 13 , 23,'static.truetrophies.com/boxart/Game_5497.png')

INSERT INTO Project.Game(Name,Description,ReleaseDate,AgeRestriction,Price,IDCompany,IDFranchise,CoverImg) 
VALUES('Street Fighter','Street Fighter V is a fighting game developed by Capcom','2016-02-16', 3 ,15.00, 14 , 24,'pbs.twimg.com/profile_images/697220635198689285/T34coLzR_400x400.png' )


-- insert credit

INSERT INTO Project.Credit(MetCredit,DateCredit,ValueCredit,IDClient)
VALUES('PayPal','2020-05-01',3.99,2);

INSERT INTO Project.Credit(MetCredit,DateCredit,ValueCredit,IDClient)
VALUES('MBWay','2020-05-01',19.99,2);

INSERT INTO Project.Credit(MetCredit,DateCredit,ValueCredit,IDClient)
VALUES('PayPal','2020-05-01',12.00,2);

INSERT INTO Project.Credit(MetCredit,DateCredit,ValueCredit,IDClient)
VALUES('VISA','2020-03-04', 3.99,3);

INSERT INTO Project.Credit(MetCredit,DateCredit,ValueCredit,IDClient)
VALUES('PayPal','2020-01-01',19.99,3);

INSERT INTO Project.Credit(MetCredit,DateCredit,ValueCredit,IDClient)
VALUES('VISA','2020-03-22',1.99,3);

INSERT INTO Project.Credit(MetCredit,DateCredit,ValueCredit,IDClient)
VALUES('PayPal','2020-03-03',1.99,4);

INSERT INTO Project.Credit(MetCredit,DateCredit,ValueCredit,IDClient)
VALUES('MasterCard','2020-05-01',32.56,4);

INSERT INTO Project.Credit(MetCredit,DateCredit,ValueCredit,IDClient)
VALUES('PayPal','2020-01-21',1.99,5);

INSERT INTO Project.Credit(MetCredit,DateCredit,ValueCredit,IDClient)
VALUES('PayPal','2020-05-01',9.99,5);


-- insert discount

INSERT INTO Project.Discount(PromoCode,Percentage,DateBegin,DateEnd) 
VALUES(1,50,'2020-05-01','2020-11-20');
INSERT INTO Project.Discount(PromoCode,Percentage,DateBegin,DateEnd) 
VALUES(2,50,'2020-03-01','2020-04-20');
INSERT INTO Project.Discount(PromoCode,Percentage,DateBegin,DateEnd) 
VALUES(3,30,'2020-06-01','2020-11-20');


-- insert discountgame

INSERT INTO Project.DiscountGame(PromoCode,IDGame) VALUES(1,1);
INSERT INTO Project.DiscountGame(PromoCode,IDGame) VALUES(2,2);
INSERT INTO Project.DiscountGame(PromoCode,IDGame) VALUES(3,3);
INSERT INTO Project.DiscountGame(PromoCode,IDGame) VALUES(1,4);


-- insert gamegenre



INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (1,'Platformer');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (1,'Side-Scrolling');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (2,'Platformer');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (2,'Adventure');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (3,'Platformer');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (3,'Role-Playing');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (3,'Adventure');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (4,'Role-Playing');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (4,'Adventure');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (5,'Role-Playing');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (5,'Adventure');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (6,'Adventure');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (6,'Action');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (6,'Shooter');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (7,'Simulation');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (7,'Sports');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (8,'Simulation');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (8,'Sports')

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (9,'Shooter');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (9,'Action');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (10,'Shooter');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (10,'Action');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (11,'Shooter');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (11,'Action');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (11,'Survival');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (12,'Racing');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (13,'Racing');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (14,'Adventure');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (14,'Action');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (15,'Adventure');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (15,'Action');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (16,'Adventure');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (16,'Action');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (16,'Shooter');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (17,'Adventure');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (17,'Action');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (17,'Shooter');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (18,'Sports');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (18,'Simulation');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (19,'Adventure');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (19,'Action');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (19,'Role-Playing');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (20,'Action');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (20,'Adventure');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (20,'Platformer');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (20,'Shooter');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (21,'Action');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (21,'Adventure');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (21,'Platformer');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (21,'Shooter');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (22,'Shooter');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (22,'Action');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (23,'Shooter');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (23,'Action');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (23,'Survival');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (24,'Shooter');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (24,'Strategy');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (24,'Action');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (24,'Adventure');


INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (25,'Shooter');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (25,'Action');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (25,'Adventure');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (25,'Puzzle');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (26,'Role-Playing');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (26,'Action');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (26,'Adventure');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (26,'Puzzle');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (27,'Shooter');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (27,'Strategy');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (27,'Action');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (28,'Puzzle');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (28,'Action');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (28,'Adventure');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (28,'Role-Playing');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (29,'Adventure');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (29,'MMORPG');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (29,'Strategy');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (30,'Role-Playing');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (30,'Action');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (31,'Fighting');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (31,'Action');

INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (32,'Fighting');
INSERT INTO Project.GameGenre(IDGame,GenName) VALUES (32,'Action');

-- insert platformreleasesgame


INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (1,'Nintendo 64');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (2,'Nintendo DS');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (3,'Android');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (3,'iOS');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (4,'Nintendo DS');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (5,'Nintendo Switch');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (6,'Windows 10');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (6,'PlayStation 3');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (6,'PlayStation 4');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (6,'Xbox 360');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (6,'Xbox One');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (7,'Xbox 360');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (7,'PlayStation');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (7,'PlayStation 2');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (7,'GameCube');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (8,'Xbox One');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (8,'PlayStation 4');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (8,'Nintendo Switch');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (8,'MacOS');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (8,'Windows 10');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (8,'Windows 7');



INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (9,'Xbox 360');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (9,'PlayStation 3');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (9,'Windows 7');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (10,'Xbox 360');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (10,'PlayStation 3');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (10,'Windows 7');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (10,'Wii');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (11,'Windows 7');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (11,'MacOS');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (11,'Linux');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (11,'Xbox 360');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (12,'Xbox 360');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (12,'PlayStation 3');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (12,'Windows 7');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (12,'Wii U');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (12,'PlayStation Vita');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (12,'Android');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (12,'iOS');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (13,'PlayStation Portable');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (13,'PlayStation 3');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (13,'iOS');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (13,'Android');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (13,'Xbox 360');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (14,'Xbox 360');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (14,'PlayStation 3');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (14,'Windows 7');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (15,'Xbox 360');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (15,'PlayStation 3');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (15,'Windows 7');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (15,'Xbox One');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (15,'PlayStation 4');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (15,'Windows 10');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (16,'Xbox 360');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (16,'PlayStation 3');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (16,'Windows 7');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (17,'Xbox One');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (17,'PlayStation 4');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (17,'Windows 10');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (18,'Xbox 360');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (18,'PlayStation 3');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (18,'Windows 7');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (18,'Xbox One');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (18,'PlayStation 4');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (18,'Windows 10');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (19,'Nintendo Switch');


INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (20,'PlayStation 3');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (21,'PlayStation 4');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (22,'Xbox One');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (22,'PlayStation 4');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (22,'Windows 10');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (23,'Xbox One');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (23,'PlayStation 4');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (23,'Windows 10');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (24,'Xbox One');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (24,'Xbox 360');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (24,'Windows 7');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (25,'Xbox One');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (25,'PlayStation 4');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (25,'Windows 10');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (26,'Xbox 360');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (26,'PlayStation 3');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (26,'Windows 7');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (27,'Windows 7');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (27,'Windows 10');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (28,'PlayStation 4');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (29,'Windows 7');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (30,'Xbox One');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (30,'PlayStation 4');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (30,'Windows 10');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (31,'Xbox One');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (31,'PlayStation 4');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (31,'Windows 10');

INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (32,'PlayStation 4');
INSERT INTO Project.PlatformReleasesGame(IDGame,PlatformName) VALUES (32,'Windows 10');

-- insert Reviews


INSERT INTO Project.Reviews(Title,Text,Rating,DateReview,UserID,IDGame) 
VALUES('Very bad game','My game keeps crashing. I can not play this...',1,'2020-05-01',2,1);


INSERT INTO Project.Reviews(Title,Text,Rating,DateReview,UserID,IDGame) 
VALUES('Not that good', 'I really do not like the graphic design :/',3,'2020-03-04', 3, 1  );

INSERT INTO Project.Reviews(Title,Text,Rating,DateReview,UserID,IDGame)
VALUES('Amazing', 'I really have fun playing this!', 4, '2020-01-02',5,1);


INSERT INTO Project.Reviews(Title,Text,Rating,DateReview,UserID,IDGame)
VALUES('Can not stop playing! OMG','This game is so addictive, pls send help!',5,'2020-05-01',2,2);

INSERT INTO Project.Reviews(Title,Text,Rating,DateReview,UserID,IDGame) 
VALUES('Could be worse','The game looks nice, but it has some problems in playability',3,'2020-01-01',3,2 );


INSERT INTO Project.Reviews(Title,Text,Rating,DateReview,UserID,IDGame) 
VALUES('Not worth the money!','If anyone is reading this pls do not buy this game',1,'2020-03-22',3,3);

INSERT INTO Project.Reviews(Title,Text,Rating,DateReview,UserID,IDGame) 
VALUES('Couldnt ask for better', 'Really fun, addictive and nostalgic',4, '2020-01-21',5,3 );

INSERT INTO Project.Reviews(Title,Text,Rating,DateReview,UserID,IDGame)
VALUES('GG', 'good design and playability, but some problems',3, '2020-03-03',4,3 );

-- insert copias



INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(1,'Nintendo 64');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(1,'Nintendo 64');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(1,'Nintendo 64');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(1,'Nintendo 64');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(2,'Nintendo DS');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(2,'Nintendo DS');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(2,'Nintendo DS');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(2,'Nintendo DS');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(3,'Android');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(3,'Android');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(3,'Android');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(3,'iOS');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(4,'Nintendo DS');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(4,'Nintendo DS');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(4,'Nintendo DS');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(4,'Nintendo DS');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(5,'Nintendo Switch');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(5,'Nintendo Switch');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(5,'Nintendo Switch');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(5,'Nintendo Switch')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(6,'Windows 10');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(6,'PlayStation 3');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(6,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(6,'Xbox One')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(7,'PlayStation 2');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(7,'GameCube');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(7,'Xbox 360');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(7,'PlayStation');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(8,'Xbox One');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(8,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(8,'Windows 10');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(8,'Windows 10')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(9,'Xbox 360');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(9,'PlayStation 3');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(9,'PlayStation 3');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(9,'Windows 7')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(10,'Xbox 360');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(10,'PlayStation 3');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(10,'Windows 7');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(10,'Wii')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(11,'Windows 7');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(11,'MacOS');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(11,'Linux');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(11,'Xbox 360')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(12,'Xbox 360');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(12,'PlayStation 3');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(12,'Windows 7');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(12,'PlayStation Vita')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(13,'PlayStation Portable');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(13,'PlayStation Portable');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(13,'Xbox 360');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(13,'Android')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(14,'Windows 7');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(14,'Xbox 360');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(14,'PlayStation 3');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(14,'PlayStation 3')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(15,'Windows 7');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(15,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(15,'Windows 10');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(15,'Windows 10')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(16,'PlayStation 3');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(16,'PlayStation 3');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(16,'Windows 7');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(16,'Xbox 360')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(17,'Xbox One');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(17,'Xbox One');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(17,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(17,'Windows 10')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(18,'PlayStation 3');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(18,'PlayStation 3');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(18,'Windows 10');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(18,'Xbox 360')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(19,'Nintendo Switch');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(19,'Nintendo Switch');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(19,'Nintendo Switch');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(19,'Nintendo Switch');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(20,'PlayStation 3');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(20,'PlayStation 3');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(20,'PlayStation 3');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(20,'PlayStation 3')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(21,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(21,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(21,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(21,'PlayStation 4')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(22,'Xbox One');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(22,'Xbox One');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(22,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(22,'Windows 10')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(23,'Xbox One');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(23,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(23,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(23,'Windows 10')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(24,'Xbox One');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(24,'Xbox One');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(24,'Xbox 360');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(24,'Windows 7')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(25,'Xbox One');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(25,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(25,'Windows 10');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(25,'Windows 10')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(26,'Windows 7');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(26,'Xbox 360');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(26,'Xbox 360');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(26,'PlayStation 3')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(27,'Windows 7');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(27,'Windows 7');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(27,'Windows 10');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(27,'Windows 10')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(28,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(28,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(28,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(28,'PlayStation 4')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(29,'Windows 7');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(29,'Windows 7');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(29,'Windows 7');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(29,'Windows 7')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(30,'Xbox One');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(30,'Xbox One');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(30,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(30,'Windows 10')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(31,'Xbox One');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(31,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(31,'Windows 10');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(31,'Windows 10')
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(32,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(32,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(32,'PlayStation 4');
INSERT INTO Project.[Copy](IDGame,PlatformName) VALUES(32,'Windows 10')



-- insert purchases

INSERT INTO Project.Purchase(Price,PurchaseDate,IDClient,SerialNum) 
VALUES(3.99,'2020-05-01',2,100001);

INSERT INTO Project.Purchase(Price,PurchaseDate,IDClient,SerialNum) 
VALUES(3.99,'2020-03-04',3,100002);

INSERT INTO Project.Purchase(Price,PurchaseDate,IDClient,SerialNum) 
VALUES(3.99,'2020-01-02',5,100003);

INSERT INTO Project.Purchase(Price,PurchaseDate,IDClient,SerialNum) 
VALUES(19.99,'2020-05-01',2,100005);

INSERT INTO Project.Purchase(Price,PurchaseDate,IDClient,SerialNum) 
VALUES(19.99,'2020-05-01',3,100006);

INSERT INTO Project.Purchase(Price,PurchaseDate,IDClient,SerialNum) 
VALUES(3.99,'2020-03-22',3,100009);

INSERT INTO Project.Purchase(Price,PurchaseDate,IDClient,SerialNum) 
VALUES(3.99,'2020-01-21',5,100010);

INSERT INTO Project.Purchase(Price,PurchaseDate,IDClient,SerialNum) 
VALUES(3.99,'2020-03-03',4,100011);

---UDFS-----
go 
CREATE FUNCTION Project.[udf_check_email](@email VARCHAR(50)) RETURNS INT
AS
BEGIN
	IF EXISTS(SELECT * FROM Project.[User] AS U WHERE u.Email = @email)
		RETURN 1;
	RETURN 0;
END
GO

create FUNCTION Project.[udf_check_username](@username VARCHAR(50)) RETURNS INT
AS
BEGIN
	declare @temp as int
	set @temp = ( SELECT UserID FROM Project.Client AS C WHERE C.Username = @username);
	return @temp;
END
GO


GO
CREATE FUNCTION Project.[udf_isadmin] (@email VARCHAR(50)) RETURNS INT
AS
BEGIN
	  declare @temp varchar(50)
	  declare @id INT --gets the admin id,
	  set @temp= (SELECT  [Admin].UserID  FROM (Project.[User] JOIN Project.[Admin] on [User].UserID = [Admin].UserID ) WHERE Email = @email);
	  if  (@temp is null)
		 set @id=0;
	  else
		 set @id=@temp	
	  RETURN @id;
END
GO


GO
CREATE FUNCTION Project.[udf_isclient] (@email VARCHAR(50)) RETURNS INT
AS
BEGIN
	  declare @temp varchar(50)
	  declare @id INT --gets the client id,
	  set @temp= (SELECT  Client.UserID  FROM (Project.[User] JOIN Project.Client on [User].UserID = Client.UserID ) WHERE Email = @email);
	  if  (@temp is null)
		 set @id=0;
	  else
		 set @id=@temp	
	  RETURN @id;
END
GO

CREATE FUNCTION Project.[udf_checkusersgames](@IDClient INT) RETURNS TABLE
AS 
		RETURN ( SELECT Game.*  
		FROM (( Project.Purchase JOIN  Project.[Copy] ON Purchase.SerialNum = [Copy].SerialNum) 
		JOIN  Project.Game ON [Copy].IDGame = Game.IDGame ) 
		WHERE Purchase.IDClient = @IDClient )
GO


GO
CREATE FUNCTION Project.[udf_countuserGames] (@IDClient INT) RETURNS INT
AS 
	begin
			DECLARE @counter AS INT;
			SELECT @counter= COUNT( IDGame) FROM Project.[udf_checkusersgames] (@IDClient);
	
				RETURN @counter
	end
GO
CREATE FUNCTION Project.[udf_userfollowers] (@IDClient INT) RETURNS TABLE
AS
	RETURN ( SELECT IDFollower FROM  Project.Follows WHERE Follows.IDFollowed =  @IDClient)

GO

SELECT * FROM Project.[udf_userfollowers] (2)

GO

create FUNCTION Project.[udf_countuserFollowers] (@IDClient INT) RETURNS INT
AS 
	begin
			DECLARE @counter AS INT;
			SELECT @counter= COUNT( IDFollower) FROM Project.[udf_userfollowers] (@IDClient);
			RETURN @counter
	end
GO


GO

go
--Check the people that we follow that have a  specific game in common with the client itself 
create FUNCTION Project.[udf_checkGameofFollows] (@IDGame INT, @IDClient INT ) RETURNS TABLE
AS
	RETURN (SELECT  DISTINCT Client.UserID,Client.Username 
	FROM ( (Project.Follows
	JOIN Project.Purchase ON Purchase.IDClient = Follows.IDFollowed) 
	JOIN Project.Client ON Client.UserID = Follows.IDFollowed 
	JOIN Project.[Copy] ON ([Copy].SerialNum = Purchase.SerialNum) 
	JOIN Project.Game ON Game.IDGame= [Copy].IDGame)
	WHERE Follows.IDFollower = @IDClient and Game.IDGame=@IDGame)


GO

go
Create Function Project.udf_checkIfFollows(@IDFollower INT , @IDFollowed INT) Returns INT
as
	begin

		declare @temp as varchar(50)
		set @temp= ( Select IDFollowed From Project.Follows where IDFollowed=@IDFollowed and IDFollower=@IDFollower);
		if @temp is null
			return 0
		return 1

	end
go
SELECT Project.udf_checkIfFollows(8,2)




--Get all Games that two users have in common 
GO
CREATE FUNCTION Project.[udf_checkAllGamesinCommon] (@IDClient INT, @IDPerson INT ) RETURNS TABLE
AS
	   RETURN (SELECT  Game.IDGame,Game.[Name] FROM  Project.Purchase 
		JOIN Project.[Copy] ON Purchase.SerialNum = [Copy].SerialNum
		JOIN Project.Game ON Game.IDGame = [Copy].IDGame 
		WHERE Purchase.IDClient = @IDClient  OR Purchase.IDClient = @IDPerson
		GROUP BY Game.IDGame,Game.[Name] HAVING COUNT(Game.IDGame) > 1 )
GO

CREATE FUNCTION Project.[udf_getGameGenres] (@IDGame INT) RETURNS TABLE 
AS
	RETURN (SELECT Genre.* FROM Project.GameGenre 
	JOIN Project.Game ON Game.IDGame = GameGenre.IDGame 
	JOIN Project.Genre ON Genre.GenName = GameGenre.GenName
	WHERE Game.IDGame = @IDGame ) 
GO

CREATE FUNCTION Project.[udf_getGamePlataforms] (@IDGame INT) RETURNS TABLE
AS
	RETURN (SELECT [Platform].* FROM Project.PlatformReleasesGame 
	JOIN Project.Game ON Game.IDGame = PlatformReleasesGame.IDGame 
	JOIN Project.[Platform] ON [Platform].PlatformName = PlatformReleasesGame.PlatformName
	WHERE Game.IDGame = @IDGame)
GO


CREATE FUNCTION Project.[udf_getPurchaseInfo] (@IDGame INT,@IDClient INT) RETURNS TABLE
AS	
	RETURN (SELECT Purchase.*,Copy.PlatformName FROM Project.Purchase
	JOIN Project.[Copy] ON  Purchase.SerialNum = [Copy].SerialNum
	JOIN Project.Game ON Game.IDGame = [Copy].IDGame
	WHERE Purchase.IDClient = @IDClient AND Game.IDGame=@IDGame) 
GO


CREATE FUNCTION Project.[udf_getGameDetails] (@IDGame INT) RETURNS TABLE 
AS
	RETURN ( SELECT * FROM Game WHERE Game.IDGame = @IDGame)

GO

SELECT * FROM Project.udf_getGameDetails (30)

GO
CREATE FUNCTION Project.[udf_getCompanyDetails] (@IDCompany INT) RETURNS TABLE
AS
	RETURN ( SELECT * FROM Company WHERE Company.IDCompany = @IDCompany)
GO

go 
CREATE FUNCTION Project.[udf_getReviewsList] (@IDGame INT) RETURNS TABLE
AS
	RETURN ( SELECT Username,Title,Rating,[Text], Game.[Name],DateReview
	FROM (Project.Reviews JOIN Project.Client ON Reviews.UserID=Client.UserID) JOIN Project.Game ON Reviews.IDGame=Game.IDGame
	where Reviews.IDGame=@IDGame);
go

go
CREATE FUNCTION Project.[udf_getNumberOfReviews] (@IDGame INT) RETURNS INT
AS
	Begin
		DECLARE @ret as int;
		SELECT @ret=COUNT(IDReview) From Project.Reviews where Reviews.IDGame=@IDGame;
		return @ret;
	end
go
SELECT * FROM Project.[udf_getReviewsList](1);
SELECT Project.[udf_getNumberOfReviews](1);


GO

CREATE FUNCTION Project.[udf_getFranchiseDetails] (@IDFranchise INT) RETURNS TABLE
AS
	RETURN ( SELECT * FROM Franchise WHERE Franchise.IDFranchise =@IDFranchise)
GO

CREATE FUNCTION Project.[udf_getFranchisesComp] (@IDCompany INT) RETURNS TABLE
AS
	RETURN (SELECT Franchise.IDFranchise,Franchise.[Name] FROM Project.Franchise  WHERE IDCompany = @IDCompany)

GO

CREATE FUNCTION Project.[udf_getGamesFranchise] (@IDFranchise INT) RETURNS TABLE
AS
	RETURN (SELECT Game.[Name] FROM Project.Franchise JOIN Project.Game ON Game.IDFranchise = Franchise.IDFranchise WHERE Franchise.IDFranchise=@IDFranchise) 
GO



CREATE FUNCTION Project.[udf_getNumberGameFranchises] (@IDFranchise INT) RETURNS INT
AS
	BEGIN
		DECLARE @counter INT;
		SElECT @counter = COUNT([Name]) FROM Project.[udf_getGamesFranchise] (@IDFranchise);
		RETURN @counter;
	END
GO


CREATE FUNCTION Project.[udf_getNumberFranchiseComp] (@IDCompany INT) RETURNS INT
AS
	BEGIN
		DECLARE @counter INT;
		SElECT @counter = COUNT(IDFranchise) FROM Project.[udf_getFranchisesComp] (@IDCompany);
		RETURN @counter;
	END
GO


CREATE FUNCTION Project.[udf_getCompGames] (@IDCompany INT) RETURNS TABLE
AS
	RETURN ( SELECT Game.[Name] FROM Project.Game JOIN Project.Company ON Game.IDCompany = Company.IDCompany WHERE Company.IDCompany=@IDCompany)

GO

CREATE FUNCTION Project.[udf_getNumberCompGames] (@IDCompany INT) RETURNS INT
AS
	BEGIN
		DECLARE @counter INT;
		SElECT @counter = COUNT([Name]) FROM Project.udf_getCompGames (@IDCompany);
		RETURN @counter;
	END

GO


CREATE FUNCTION Project.[udf_checkReview] (@IDClient INT, @IDGame INT) RETURNS INT
AS
BEGIN
		DECLARE @id as INT;
		DECLARE @temp as VARCHAR(50);
		set @temp = (SELECT IDReview FROM Project.Reviews JOIN Project.Game ON Game.IDGame = Reviews.IDGame  WHERE Reviews.UserID = @IDClient AND Game.IDGame = @IDGame)
		IF (@temp is null)  
			set @id=0;
		ELSE
			set @id=@temp;
		RETURN @id;
END
GO



CREATE FUNCTION Project.[udf_checkGameCopies] (@IDGame INT, @PlatformName VARCHAR(30)) RETURNS TABLE
AS
			RETURN( SELECT Copy.SerialNum as notBought
			FROM Project.[Copy]  
			WHERE @IDGame = [Copy].IDGame AND @PlatformName = [Copy].PlatformName EXCEPT SELECT [Copy].SerialNum FROM Project.Purchase JOIN Project.[Copy] ON [Copy].SerialNum = Purchase.SerialNum)
go

CREATE FUNCTION Project.[udf_checkGameDiscount] (@IDGame INT) RETURNS TABLE
AS
	RETURN (SELECT ISNULL([Percentage], 0) AS [Percentage] FROM Project.Game 
	JOIN Project.DiscountGame ON Game.IDGame =DiscountGame.IDGame 
	JOIN Project.Discount ON Discount.PromoCode =DiscountGame.PromoCode
	WHERE DATEDIFF(DAY,DateEnd,GETDATE()) <0  AND DATEDIFF(DAY,DateBegin,GETDATE()) >0 AND Game.IDGame=@IDGame)

GO




create Function Project.[udf_getGenreDetails](@GenName Varchar(25)) Returns Table
as
	Return( Select * From Project.Genre where Genre.GenName=@GenName);
go
go
Create Function Project.[udf_getGenreGames](@GenName Varchar(25)) Returns Table
as
	Return ( Select Name From Project.GameGenre Join Project.Game ON GameGenre.IDGame=Game.IDGame where GenName=@GenName);

go
go
Create Function Project.[udf_getNumberGenreGames](@GenName Varchar(25)) Returns int
as
	begin
	declare @temp as int
	SELECT @temp=COUNT(Name) FROM Project.udf_getGenreGames(@GenName);
	return @temp;
	end
go

create FUNCTION Project.[udf_getPlatformDetails](@platformName Varchar(30)) returns table
as
	RETURN( SELECT * FROM Project.[Platform] where [Platform].PlatformName=@platformName);

go
go
Create Function Project.[udf_getPlatformGames](@platformName Varchar(30)) returns table
as
	Return ( Select Game.Name from Project.PlatformReleasesGame 
	JOIN Project.Game ON Game.IDGame=PlatformReleasesGame.IDGame
	where PlatformReleasesGame.PlatformName=@platformName)

go

go
Create Function Project.[udf_getNumberPlatformGames](@platformName Varchar(30)) returns int
as
begin
	Declare @temp as int
	Select @temp = COUNT(Name) From Project.udf_getPlatformGames(@platformName);
	return @temp;
end
go


CREATE FUNCTION Project.[udf_checkUserPurchase] (@IDClient INT,@IDGame INT) RETURNS INT
AS
	BEGIN
	IF EXISTS ( SELECT TOP 1 Purchase.NumPurchase  FROM Project.Purchase JOIN Project.Copy ON Copy.SerialNum=Purchase.SerialNum WHERE Copy.IDGame=@IDGame AND Purchase.IDClient=@IDClient)
		RETURN 1
	RETURN 0
	END
GO
---- PROCEDURES---
create procedure Project.pd_Login(
	@Loginemail varchar(50),
	@password varchar(20),
	@response  bit output)
	as
	begin
	  declare @temp varchar(50)
	  set @temp= (select Email FROM Project.[User] where Email=@Loginemail and @password = CONVERT(varchar(20),DECRYPTBYPASSPHRASE('**********',[Password])) )
	  if  (@temp is null)
		set @response=0
	  else
	  set @response=1
	end		
go

go
create procedure Project.pd_sign_up
    @email VARCHAR(50), 
    @password VARCHAR(20), 
    @registerDate    DATE ,
    @userName VARCHAR(50),
    @fullName VARCHAR(max),
    @sex        CHAR,
    @birth      DATE,
    @response INT output
as
begin
    begin try

        insert into Project.[User](Email,[Password], RegisterDate) values (@email,ENCRYPTBYPASSPHRASE('**********',@password) ,@registerDate)
        DECLARE @client_id AS INT;
        SELECT @client_id = UserID from Project.[User] where [User].Email=@email
        INSERT INTO Project.Client(UserID,Username,FullName,Sex,Birth,Balance)  VALUES(@client_id,@userName,@fullName,@sex, @birth,0.0)
        set @response=1
    end try
    begin catch
        set @response=0
    end catch
end
go


CREATE PROCEDURE Project.pd_insertReview(
	@Title VARCHAR(50),
	@Text VARCHAR(280),
	@Rating DECIMAL (2,1),
	@DateReview DATE,
	@UserID INT ,
	@IDGame INT
	)
	AS
		BEGIN
				INSERT INTO Project.Reviews(Title,[Text],Rating,DateReview,UserID,IDGame) VALUES (@Title,@Text,@Rating,@DateReview,@UserID,@IDGame)
		END
GO

CREATE PROCEDURE Project.pd_insertCredit(
	@MetCredit varchar(20),
	@DateCredit DATE,
	@ValueCredit DECIMAL (4,2),
	@IDClient INT)
	AS
		BEGIN
			INSERT INTO Project.Credit(MetCredit,DateCredit,ValueCredit,IDClient) VALUES (@MetCredit,@DateCredit,@ValueCredit,@IDClient)
		END

GO

CREATE PROCEDURE Project.pd_insertPurchase(
	@PurchaseDate DATE,
	@IDClient INT,
	@IDGame INT,
	@PlatformName VARCHAR(30),
	@res VARCHAR(30) output
	)
	AS
		BEGIN
			BEGIN TRAN
			DECLARE @Price DECIMAL(5,2)
			DECLARE @countDispCopies INT;
			DECLARE @SerialNum INT;
			DECLARE @tempPer INT;
			BEGIN TRY
			IF ( (SELECT Project.udf_checkUserPurchase(@IDClient,@IDGame)) = 1)
				raiserror ('User Already Contains that Game',16,1);

			SET @Price = (SELECT Price from Project.Game WHERE Game.IDGame=@IDGame)
			SET @SerialNum= (SELECT top 1 notBought FROM Project.[udf_checkGameCopies] (@IDGame,@PlatformName))
			IF @SerialNum IS NULL
				BEGIN
					INSERT INTO Project.Copy VALUES (@IDGame,@PlatformName)
					SET @SerialNum =( SELECT TOP 1 Copy.SerialNum FROM Project.[Copy] WHERE Copy.IDGame=@IDGame AND Copy.PlatformName=@PlatformName ORDER BY SerialNum DESC  )
				END
			
			SET @tempPer = (SELECT TOP 1 * FROM Project.[udf_checkGameDiscount](@IDGame))
				IF @tempPer is not null 
					BEGIN
						SET @Price-=@Price*(@tempPer/100)
					END
			INSERT INTO Project.Purchase(Price,PurchaseDate,IDClient,SerialNum) VALUES (@Price,@PurchaseDate,@IDClient,@SerialNum)
			SET @res ='Success!'
			END TRY
			BEGIN CATCH
				 PRINT 'Error on line ' + CAST(ERROR_LINE() AS VARCHAR(10))
				 PRINT ERROR_MESSAGE()
				 SET @res= ERROR_MESSAGE()
				 rollback tran
			END CATCH
			if @@TRANCOUNT >0
			COMMIT TRAN
		END

go
DECLARE @res AS VARCHAR(30);
EXEC Project.pd_insertPurchase '2020-06-03',5,10,'PlayStation 3',@res
SELECT @res
select * from Project.Purchase
GO
CREATE PROCEDURE Project.pd_filter_PurchaseHistory(
		@IDClient INT,
		@MinValue DECIMAL (5,2) =NULL,
		@MaxValue DECIMAL (5,2) = NULL,
		@MinDate  DATE =NULL,
		@MaxDate DATE =NULL,
		@GameName VARCHAR(max) =NULL -- user input
		)
	AS
		BEGIN
			declare @temp TABLE (
				Price DECIMAL(5,2),
				PurchaseDate DATE,
				SerialNumber INT,
				GameName VARCHAR(50)
			)
			INSERT INTO @temp(Price,PurchaseDate,SerialNumber,GameName) SELECT Purchase.Price,PurchaseDate,Purchase.SerialNum,[Name]
			FROM  Project.Purchase JOIN Project.[Copy] ON Purchase.SerialNum=Copy.SerialNum 
			JOIN Project.Game ON Game.IDGame = [Copy].IDGame WHERE Purchase.IDClient=@IDClient
			IF @MinValue is not null
				DELETE FROM @temp WHERE @MinValue>Price 
			IF @MaxValue is not null 
				DELETE FROM @temp WHERE @MaxValue<Price
			IF @MinDate is not  null
				DELETE FROM @temp WHERE DATEDIFF(DAY,@MinDate,PurchaseDate) < 0
			IF @MaxDate is not null
				DELETE FROM @temp WHERE DATEDIFF(DAY,@MaxDate,PurchaseDate) > 0
            IF @GameName is not  null
				DELETE FROM @temp WHERE GameName NOT LIKE  @GameName + '%'
					
			SELECT * FROM @temp
		END
go

CREATE PROCEDURE Project.pd_filter_CreditHistory(
	@IDClient INT,
	@MinValue DECIMAL(5,2),
	@MaxValue DECIMAL(5,2),
	@MinDate DATE,
	@MaxDate DATE,
	@selectedMets VARCHAR(max) -- selected payment methods in the app checkbox
	)
	AS
		BEGIN
			   DECLARE @temp TABLE (
				MetCredit VARCHAR(20), 
				ValueCredit DECIMAL(5,2),
				DateCredit DATE)
				INSERT INTO @temp SELECT MetCredit,ValueCredit,DateCredit FROM Project.Credit where Project.Credit.IDClient =@IDClient
				IF @MinValue is not null
					DELETE FROM @temp WHERE @MinValue>ValueCredit 
				IF @MaxValue is not null 
					DELETE FROM @temp WHERE @MaxValue<ValueCredit
				IF @MinDate is not  null
					DELETE FROM @temp WHERE DATEDIFF(DAY,@MinDate,DateCredit) < 0
				IF @MaxDate is not null
					DELETE FROM @temp WHERE DATEDIFF(DAY,@MaxDate,DateCredit) > 0
				IF @selectedMets is not null	
					DELETE FROM @temp WHERE  MetCredit NOT  IN (SELECT value FROM STRING_SPLIT(@selectedMets, ','));

				SELECT * FROM @temp
		END
GO

CREATE PROCEDURE Project.pd_filter_Games(
	@MinValue DECIMAL (5,2),
	@MaxValue DECIMAL (5,2),
	@MinDate DATE,
	@MaxDate DATE,
	@SelectedPlats VARCHAR(MAX),
	@SelectedGenres VARCHAR(MAX),
	@SelectedAge INT, 
	@MinDiscount INT,
	@GameName VARCHAR(max),  -- user input
	@orderopt VARCHAR(MAX)  -- option to order games
)
AS
	BEGIN
			DECLARE  @tempPurchase TABLE(
				IDGame INT,
				GameName VARCHAR(50),
				[Description] VARCHAR(max),
				ReleaseDate DATE,
				AgeRestriction INT,
				CoverImg varchar(max),
				Price  DECIMAL (5,2),
				IDCompany INT,
				IDFranchise INT,
				GenName VARCHAR(25),
				PlatformName  VARCHAR(30),
				Disc INT
			) 
				DECLARE @tempPer INT;
				INSERT INTO @tempPurchase SELECT Game.*,GameGenre.GenName,PlatformReleasesGame.PlatformName,0
				FROM Project.Game JOIN Project.PlatformReleasesGame ON Game.IDGame=PlatformReleasesGame.IDGame 
				JOIN Project.GameGenre ON GameGenre.IDGame= Game.IDGame
				UPDATE @tempPurchase
				SET Disc =(SELECT IIF (EXISTS (SELECT TOP 1 [Percentage]  FROM Project.udf_checkGameDiscount (IDGame)),(SELECT TOP 1 [Percentage]  FROM Project.udf_checkGameDiscount (IDGame)),0))
				UPDATE @tempPurchase
				SET Price-=Price *Disc/100;
				IF @MinValue is not null
					DELETE FROM @tempPurchase WHERE @MinValue>Price
				IF @MaxValue is not null 
					DELETE FROM @tempPurchase WHERE @MaxValue<Price 
				IF @MinDate is not  null
					DELETE FROM @tempPurchase WHERE DATEDIFF(DAY,@MinDate,ReleaseDate) < 0
				IF @MaxDate is not null
					DELETE FROM @tempPurchase WHERE DATEDIFF(DAY,@MaxDate,ReleaseDate) > 0
				IF @SelectedPlats is not null
					DELETE FROM @tempPurchase WHERE  PlatformName NOT  IN (SELECT value FROM STRING_SPLIT(@SelectedPlats, ','));
                IF @SelectedGenres is not null
					DELETE FROM @tempPurchase WHERE  GenName NOT  IN (SELECT value FROM STRING_SPLIT(@SelectedGenres, ','));
				IF @SelectedAge is not null
					DELETE FROM @tempPurchase WHERE AgeRestriction > @SelectedAge;
				IF @MinDiscount is not null
					DELETE FROM @tempPurchase WHERE  Disc < @MinDiscount
                IF @GameName is not  null
					DELETE FROM @tempPurchase WHERE GameName NOT LIKE  @GameName + '%'
	---ordering options
				IF @orderopt = 'DateDesc'
				BEGIN
					select * from @tempPurchase where ReleaseDate IS NOT NULL ORDER BY ReleaseDate DESC
				END
				IF @orderopt = 'DateAsc'
				BEGIN
					select * from @tempPurchase where ReleaseDate IS NOT NULL ORDER BY ReleaseDate ASC

				END
				if @orderopt = 'NameDesc'
				BEGIN
					select * from @tempPurchase where GameName IS NOT NULL ORDER BY GameName DESC
				END
				if @orderopt ='NameAsc'
				BEGIN
					select * from @tempPurchase where GameName IS NOT NULL ORDER BY GameName ASC
				END
				if @orderopt='PriceAsc'
				BEGIN
					select * from @tempPurchase where Price IS NOT NULL ORDER BY Price ASC
				END
				if @orderopt='PriceDesc'
				BEGIN
					select * from @tempPurchase where Price IS NOT NULL ORDER BY Price DESC
				END
				if @orderopt is null
				BEGIN
					select * from @tempPurchase ORDER BY IDGame
				END
	END

go
EXEC pROJECT.pd_filter_Games null,null,null,null,null,null,null,null,null,NULL

--TRIGGERS
CREATE TRIGGER Project.trigger_review ON Project.[Reviews]
instead of insert
AS
	BEGIN
	BEGIN TRY
		DECLARE @Title AS VARCHAR(50);
		DECLARE @Text  AS VARCHAR(280);
		DECLARE @Rating AS DECIMAL (2,1);
		DECLARE @DateReview AS DATE;
		DECLARE @UserID AS INT;
		DECLARE @IDGame AS INT;
		DECLARE  @temp AS INT;
		SELECT @Title = Title, @Text = [Text] , @Rating = Rating, @DateReview = DateReview, @UserID = UserID, @IDGame = IDGame FROM INSERTED;
		SET @temp = (SELECT Project.[udf_checkReview](@UserID,@IDGame));
		if @temp = 0 
			INSERT INTO Project.Reviews(Title,[Text],Rating,DateReview,UserID,IDGame) VALUES (@Title,@Text,@Rating,@DateReview,@UserID,@IDGame)
		else
		 UPDATE Project.Reviews

		 SET Title=@Title,[Text]=@Text, Rating=@Rating, DateReview=@DateReview
		 WHERE Project.Reviews.IDGame = @IDGame AND Project.Reviews.UserID=@UserID
	END TRY
	BEGIN CATCH
		 PRINT 'Error on line ' + CAST(ERROR_LINE() AS VARCHAR(10))
		 PRINT ERROR_MESSAGE()
		 raiserror ('Insertion Error', 16, 1);
	END CATCH
	END
go


go
CREATE TRIGGER Project.trigger_credit ON Project.Credit
INSTEAD OF INSERT
AS
	BEGIN
		BEGIN TRAN
			DECLARE @MetCredit as VARCHAR(20);
			DECLARE @DateCredit as DATE;
			DECLARE @ValueCredit as DECIMAL(4,2);
			DECLARE @IDClient AS INT;
			
			SELECT @MetCredit = MetCredit,@DateCredit = DateCredit, @ValueCredit = ValueCredit,@IDClient = IDClient FROM INSERTED;
			BEGIN TRY
					INSERT INTO Project.Credit(MetCredit,DateCredit,ValueCredit,IDClient) VALUES (@MetCredit,@DateCredit,@ValueCredit,@IDClient)
					UPDATE Project.Client
						SET Balance+=@ValueCredit 
						WHERE Project.Client.UserID=@IDClient
			END TRY
			BEGIN CATCH
			 PRINT 'Error on line ' + CAST(ERROR_LINE() AS VARCHAR(10))
			 PRINT ERROR_MESSAGE()
			 raiserror ('Insertion Error', 16, 1);
			END CATCH
		COMMIT TRAN
	END

	GO

create TRIGGER Project.trigger_purchase ON Project.Purchase
INSTEAD OF INSERT
AS
	BEGIN
				DECLARE @Price  AS DECIMAL(5,2);
				DECLARE @PurchaseDate AS DATE;
				DECLARE	@IDClient AS INT;
				DECLARE @SerialNum AS INT;
				DECLARE @IDGame AS INT;
				DECLARE @tempPer AS INT;
				SELECT * FROM inserted
				SELECT @Price = Price , @PurchaseDate=PurchaseDate,@IDClient=IDClient,@SerialNum=SerialNum FROM INSERTED;
				if @Price - (SELECT Balance FROM Project.Client WHERE Client.UserID =@IDClient) >0
				BEGIN
					raiserror('Not enough balance to buy this game',16,1)

				END
				ELSE
					BEGIN TRY
						PRINT 'OLA'
						UPDATE Project.Client 
						SET Balance-=@Price WHERE Project.Client.UserID=@IDClient
						INSERT INTO Project.Purchase(Price,PurchaseDate,IDClient,SerialNum) VALUES (@Price,@PurchaseDate,@IDClient,@SerialNum)
						
					END TRY
					BEGIN CATCH
					 PRINT 'Error on line ' + CAST(ERROR_LINE() AS VARCHAR(10))
					 --PRINT ERROR_MESSAGE()
					 raiserror ('Error while inserting purchase values', 16, 1);
					END CATCH
	END

EXEC Project.pd_insertPurchase '2020-05-02',4,16,'PlayStation 3'
SELECT * FROM Project.Client 




