
-- insert users

INSERT INTO Project.[User](Email,Password,RegisterDate) VALUES('brunobastos@gmail.com','password', '2018-04-04')
INSERT INTO Project.[User](Email,Password,RegisterDate) VALUES('client@gmail.com', 'client', '2018-11-02')
INSERT INTO Project.[User](Email,Password,RegisterDate) VALUES('NancyKim@gmail.com', 'HelloWorld', '2019-11-02')
INSERT INTO Project.[User](Email,Password,RegisterDate) VALUES('timcarrey@outlook.com', 'notjimcarrey?', '2019-12-10')
INSERT INTO Project.[User](Email,Password,RegisterDate) VALUES('KareemCorbett@gmail.com', '8gMxBJMube', '2018-10-23')
INSERT INTO Project.[User](Email,Password,RegisterDate) VALUES('CocoNava@gmail.com', 'yFxeZXdcaX', '2018-11-11')
INSERT INTO Project.[User](Email,Password,RegisterDate) VALUES('dominik_stokes@gmail.com', 'jDeTicDbvf', '2018-09-22')
INSERT INTO Project.[User](Email,Password,RegisterDate) VALUES('Wesley_Shields@gmail.com', '65bdSkgCqe', '2019-01-20')
INSERT INTO Project.[User](Email,Password,RegisterDate) VALUES('leandrocoelhom@gmail.com', 'BxjthfZPFX', '2020-01-01')
INSERT INTO Project.[User](Email,Password,RegisterDate) VALUES('procsplayerdaubi@gmail.com', 'sLMfQeyTT6', '2019-12-02')


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
