drop database if exists Marvel_Characters;
create database if not exists Marvel_Characters;
use Marvel_Characters;
SET SQL_SAFE_UPDATES = 0;

drop table if exists Temporal;
CREATE TABLE IF NOT EXISTS Temporal (
	info varchar(50),
    charname VARCHAR(25) NOT NULL,
    birthname VARCHAR(74) NOT NULL,
    category VARCHAR(129) NOT NULL,
    universes VARCHAR(37) NOT NULL,
    birthplace VARCHAR(15),
    superpowers VARCHAR(185) NOT NULL,
    religions VARCHAR(11),
    gender VARCHAR(6),
    occupation VARCHAR(81),
    teams VARCHAR(99),
    primary key pk_info (info)
);

load data infile 'C:/Program Files/MySQL/dataset/Marvel Characters.csv' into table Temporal fields terminated by ',' ENCLOSED BY ';' lines terminated by '\n';
 select * from Temporal;

drop table if exists Characters;
CREATE TABLE IF NOT EXISTS Characters (
	IdCharacter INT AUTO_INCREMENT,
    charname VARCHAR(25) NOT NULL,
    birthname VARCHAR(74) NOT NULL,
    birthplace VARCHAR(15),
    religions VARCHAR(11),
    gender VARCHAR(6),
    primary key PK_IdCharacter (IdCharacter)
);
 insert into Characters(charname, birthname, birthplace, religions, gender) select charname, birthname, birthplace, religions, gender from Temporal ;
 select * from Characters;
 
#////////////////////////////////////////////////////////////////////////////////////// 

DROP TABLE IF EXISTS Superpowers;
CREATE TABLE IF NOT EXISTS Superpowers(
	IdSuperpower INT AUTO_INCREMENT,
    nameSuperpower varchar(30) NOT NULL,
    description varchar(150),
    PRIMARY KEY PK_IdSuperpower (IdSuperpower)
);
delimiter $$
drop procedure if exists pcd_AddSuperpowers $$
create procedure pcd_AddSuperpowers()
begin
	insert into Superpowers(nameSuperpower, description) select distinctrow substring_index(superpowers,",",1), "" from Temporal where superpowers != '';
    insert into Superpowers(nameSuperpower, description) select distinctrow substring_index(substring_index(superpowers,",",2),",",-1), "" from Temporal where superpowers != '';
    insert into Superpowers(nameSuperpower, description) select distinctrow substring_index(substring_index(superpowers,",",3),",",-1), "" from Temporal where superpowers != '';
    insert into Superpowers(nameSuperpower, description) select distinctrow substring_index(substring_index(superpowers,",",4),",",-1), "" from Temporal where superpowers != '';
    insert into Superpowers(nameSuperpower, description) select distinctrow substring_index(substring_index(superpowers,",",5),",",-1), "" from Temporal where superpowers != '';
    insert into Superpowers(nameSuperpower, description) select distinctrow substring_index(substring_index(superpowers,",",6),",",-1), "" from Temporal where superpowers != '';
    UPDATE Superpowers set nameSuperpower = LTRIM(nameSuperpower);
    drop table if exists ss; drop table if exists Character_Power;
    create table if not exists ss like Superpowers;
	INSERT INTO ss SELECT * FROM Superpowers GROUP BY nameSuperpower; 
    DROP TABLE Superpowers;
	ALTER TABLE ss RENAME TO Superpowers;
end $$
delimiter ;
call pcd_AddSuperpowers();
select * from Superpowers;

Select distinct Characters.IdCharacter, Superpowers.IdSuperpower 	
From Characters, Superpowers, Temporal 
Where trim(Characters.charname) like trim(Temporal.charname) and trim(Temporal.superpowers) like ('%' + trim(Superpowers.nameSuperpower) + '%');
#////////////////////////////////////////////////////////////////////////////////////// 

#DROP TABLE IF EXISTS Categories;
CREATE TABLE IF NOT EXISTS Categories(
	IdCategory INT AUTO_INCREMENT,
    nameCategory varchar(25) NOT NULL,
    description varchar(150),
    PRIMARY KEY PK_IdCategory (IdCategory)
);
 insert into Categories(nameCategory, description) select distinctrow substring_index(category,",",1), "prueba2" from Temporal;
 select * from Categories;
 
#//////////////////////////////////////////////////////////////////////////////////////

#DROP TABLE IF EXISTS Universes;
CREATE TABLE IF NOT EXISTS Universes(
	IdUniverse INT AUTO_INCREMENT,
    nameUniverse varchar(25) NOT NULL,
    PRIMARY KEY PK_IdUniverse (IdUniverse)
);
 insert into Universes(nameUniverse) select distinctrow substring_index(universes,",",1) from Temporal;
 select * from Universes;
 
#//////////////////////////////////////////////////////////////////////////////////////

#DROP TABLE IF EXISTS Teams;
CREATE TABLE IF NOT EXISTS Teams(
	IdTeam INT AUTO_INCREMENT,
    nameTeam varchar(25) not null,
    PRIMARY KEY PK_IdTeam (IdTeam)
);
delimiter $$
drop procedure if exists pcd_AddTeams $$
create procedure pcd_AddTeams()
begin
	insert into Teams(nameTeam) select distinctrow substring_index(teams,",",1) from Temporal where teams != '';
    insert into Teams(nameTeam) select distinctrow substring_index(substring_index(teams,",",2),",",-1) from Temporal where teams != '';
    insert into Teams(nameTeam) select distinctrow substring_index(substring_index(teams,",",-2),",",1) from Temporal where teams != '';
    insert into Teams(nameTeam) select distinctrow substring_index(teams,",",-1) from Temporal where teams != '';
    UPDATE Teams set nameTeam = LTRIM(nameTeam);
    drop table if exists tt; drop table if exists Character_Team;
    create table if not exists tt like Teams;
	INSERT INTO tt SELECT * FROM Teams where IdTeam GROUP BY nameTeam; 
    DROP TABLE Teams;
	ALTER TABLE tt RENAME TO Teams;
end $$
delimiter ;
call pcd_AddTeams();
select * from Teams;

#//////////////////////////////////////////////////////////////////////////////////////
 
#DROP TABLE IF EXISTS Activities;
CREATE TABLE IF NOT EXISTS Activities(
	IdOccupation INT AUTO_INCREMENT,
    nameOccupation varchar(25) NOT NULL,
    PRIMARY KEY PK_IdOccupation (IdOccupation)
);
 delimiter $$
drop procedure if exists pcd_AddActivities $$
create procedure pcd_AddActivities()
begin
	insert into Activities(nameOccupation) select distinctrow substring_index(occupation,",",1) from Temporal where occupation != '';
    insert into Activities(nameOccupation) select distinctrow substring_index(substring_index(occupation,",",2),",",-1) from Temporal where occupation != '';
    insert into Activities(nameOccupation) select distinctrow substring_index(substring_index(occupation,",",3),",",-1) from Temporal where occupation != '';
    insert into Activities(nameOccupation) select distinctrow substring_index(substring_index(occupation,",",4),",",-1) from Temporal where occupation != '';
    insert into Activities(nameOccupation) select distinctrow substring_index(substring_index(occupation,",",-3),",",1) from Temporal where occupation != '';
    insert into Activities(nameOccupation) select distinctrow substring_index(substring_index(occupation,",",-2),",",1) from Temporal where occupation != '';
    insert into Activities(nameOccupation) select distinctrow substring_index(occupation,",",-1) from Temporal where occupation != '';
    UPDATE Activities set nameOccupation = LTRIM(nameOccupation);
    drop table if exists tt; drop table if exists Character_Occupation;
    create table if not exists tt like Activities;
	INSERT INTO tt SELECT * FROM Activities GROUP BY nameOccupation; 
    DROP TABLE Activities;
	ALTER TABLE tt RENAME TO Activities;
end $$
delimiter ;
call pcd_AddActivities();
select * from Activities;

/*//////////////////////////////////////////////////////////////////////*/
/*//////////////////////////////////////////////////////////////////////*/
/*//////////////////////////////////////////////////////////////////////*/
/*
select IdCharacter, charname from Characters; select IdSuperpower, nameSuperpower from Superpowers;
select distinctrow charname,  
substring_index(substring_index(superpowers,",",1),",",-1) as power1, substring_index(substring_index(superpowers,",",2),",",-1) as power2, 
substring_index(substring_index(superpowers,",",3),",",-1) as power3, substring_index(substring_index(superpowers,",",4),",",-1) as power4,
substring_index(substring_index(superpowers,",",5),",",-1) as power5, substring_index(substring_index(superpowers,",",6),",",-1) as power6,
substring_index(substring_index(superpowers,",",7),",",-1) as power7, substring_index(substring_index(superpowers,",",8),",",-1) as power8,
substring_index(substring_index(superpowers,",",9),",",-1) as power9, substring_index(substring_index(superpowers,",",10),",",-1) as power10,
substring_index(substring_index(superpowers,",",11),",",-1) as power11, substring_index(substring_index(superpowers,",",12),",",-1) as power12
from Temporal;
*/

delimiter $$
drop procedure if exists pcd_AddCharacter_Power $$
create procedure pcd_AddCharacter_Power()
begin
 declare i int;
 declare a int;
 declare name1 varchar(20);
 declare id1 int;
 declare idP int;
 declare id2 int;
 declare power varchar(25);
 declare oldPower varchar(25);
 set i = 1;
 set idP = 1;
 
 while idP > 0 do
 set @name1 := (select charname from Characters where IdCharacter = idP);
 set @id1 := (select IdCharacter from Characters where charname = @name1);
 set @power :=(select distinctrow substring_index(substring_index(superpowers,",",i),",",-1) from Temporal where charname = @name1);
	if @power = @oldPower then
	set i = 1;
	set idP = idP+1;
	
	else
	 set @oldPower = @power;
	 set i = i+1;
	 set @id2 :=(select IdSuperpower from Superpowers where nameSuperpower = trim(@power));
	select @power, @oldPower, @name1, @id1, @id2, idP, i;
	 insert into Character_Power(IdCharacter, IdSuperpower) values(@id1, @id2);
	 end if;
end while;
SELECT * FROM Character_Power;
end $$
delimiter ;
call pcd_AddCharacter_Power();

DROP TABLE IF EXISTS Character_Power;
CREATE TABLE IF NOT EXISTS Character_Power(
	IdCharacter INT NOT NULL,
    IdSuperpower INT NOT NULL,
		FOREIGN KEY (IdCharacter)
        REFERENCES Characters(IdCharacter)
        ON DELETE CASCADE,
		FOREIGN KEY (IdSuperpower)
        REFERENCES Superpowers(IdSuperpower)
        ON DELETE CASCADE
);
select * from Character_Power;

#//////////////////////////////////////////////////////////////////////////////////////
 
DROP TABLE IF EXISTS Character_Category;
CREATE TABLE IF NOT EXISTS Character_Category(
	IdCharacter INT NOT NULL,
    IdCategory INT NOT NULL,
		FOREIGN KEY (IdCharacter)
        REFERENCES Characters(IdCharacter)
        ON DELETE CASCADE,
		FOREIGN KEY (IdCategory)
        REFERENCES Categories(IdCategory)
        ON DELETE CASCADE
);

#//////////////////////////////////////////////////////////////////////////////////////
 
DROP TABLE IF EXISTS Character_Universe;
CREATE TABLE IF NOT EXISTS Character_Universe(
	IdCharacter INT NOT NULL,
    IdUniverse INT NOT NULL,
		FOREIGN KEY (IdCharacter)
        REFERENCES Characters(IdCharacter)
        ON DELETE CASCADE,
		FOREIGN KEY (IdUniverse)
        REFERENCES Universes(IdUniverse)
        ON DELETE CASCADE
);

#//////////////////////////////////////////////////////////////////////////////////////
 
DROP TABLE IF EXISTS Character_Team;
CREATE TABLE IF NOT EXISTS Character_Team(
	IdCharacter INT NOT NULL,
    IdTeam INT NOT NULL,
		FOREIGN KEY (IdCharacter)
        REFERENCES Characters(IdCharacter)
        ON DELETE CASCADE,
		FOREIGN KEY (IdTeam)
        REFERENCES Teams(IdTeam)
        ON DELETE CASCADE
);

#//////////////////////////////////////////////////////////////////////////////////////
 
DROP TABLE IF EXISTS Character_Occupation;
CREATE TABLE IF NOT EXISTS Character_Occupation(
	IdCharacter INT NOT NULL,
    IdOccupation INT NOT NULL,
		FOREIGN KEY (IdCharacter)
        REFERENCES Characters(IdCharacter)
        ON DELETE CASCADE,
		FOREIGN KEY (IdOccupation)
        REFERENCES Activities(IdOccupation)
        ON DELETE CASCADE
);

/*//////////////////////////////////////////////////////////////////////*/
/*//////////////////////////////////////////////////////////////////////*/
/*//////////////////////////////////////////////////////////////////////*/

/*PROCEDIMINETO ALMACENADO PARA GUARDAR*/
# PENDIENTE A TERMINAR POR COMPLICACIONES CON LOS DATOS :(

/*PROCEDIMIENTO ALMACENADO PARA LIMPIAR*/
delimiter $$
drop procedure if exists pcd_CleanDatabase$$
create procedure pcd_CleanDatabase()
begin
	delete from Character_Occupation;
    delete from Character_Team;
    delete from Character_Universe;
    delete from Character_Category;
    delete from Character_Power;
    delete from Activities;
    delete from Teams;
    delete from Universes;
    delete from Categories;
    delete from Superpowers;
    delete from Characters;
    delete from Temporal;
end $$
delimiter ;
call pcd_CleanDatabase();