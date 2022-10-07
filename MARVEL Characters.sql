drop database if exists Marvel_Characters;
create database if not exists Marvel_Characters;
use Marvel_Characters;

drop table if exists Temporal;
CREATE TABLE IF NOT EXISTS Temporal (
	info varchar(30),
    charname VARCHAR(25) NOT NULL,
    birthname VARCHAR(74) NOT NULL,
    types VARCHAR(129) NOT NULL,
    universes VARCHAR(37) NOT NULL,
    birthplace VARCHAR(15),
    superpowers VARCHAR(185) NOT NULL,
    religions VARCHAR(11),
    gender VARCHAR(6),
    occupation VARCHAR(81),
    memberof VARCHAR(99)
);

# load data infile 'C:/Program Files/MySQL/dataset/MARVEL CHARACTERS.csv' into table temporal fields terminated by ',' ENCLOSED BY '"' lines  terminated by ' ' ignore 1 rows;
# select * from characters;

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
 
DROP TABLE IF EXISTS Superpowers;
CREATE TABLE IF NOT EXISTS Superpowers(
	IdSuperpower INT AUTO_INCREMENT,
    nameSuperpower varchar(25) NOT NULL,
    description varchar(150),
    PRIMARY KEY PK_IdSuperpower (IdSuperpower)
);
 
 DROP TABLE IF EXISTS Categories;
CREATE TABLE IF NOT EXISTS Categories(
	IdCategory INT AUTO_INCREMENT,
    nameCategory varchar(25) NOT NULL,
    description varchar(150),
    PRIMARY KEY PK_IdCategory (IdCategory)
);
 
DROP TABLE IF EXISTS Universes;
CREATE TABLE IF NOT EXISTS Universes(
	IdUniverse INT AUTO_INCREMENT,
    nameUniverse varchar(25) NOT NULL,
    PRIMARY KEY PK_IdUniverse (IdUniverse)
);

DROP TABLE IF EXISTS Teams;
CREATE TABLE IF NOT EXISTS Teams(
	IdTeam INT AUTO_INCREMENT,
    nameTeam varchar(25) NOT NULL,
    PRIMARY KEY PK_IdTeam (IdTeam)
);

DROP TABLE IF EXISTS Activities;
CREATE TABLE IF NOT EXISTS Activities(
	IdOccupation INT AUTO_INCREMENT,
    nameOccupation varchar(25) NOT NULL,
    PRIMARY KEY PK_IdOccupation (IdOccupation)
);

/*//////////////////////////////////////////////////////////////////////*/

DROP TABLE IF EXISTS Character_Power;
CREATE TABLE IF NOT EXISTS Character_Power(
	IdCharacter INT NOT NULL,
    IdSuperpower INT NOT NULL,
		FOREIGN KEY (IdCharacter)
        REFERENCES Characters(IdCharacter),
		FOREIGN KEY (IdSuperpower)
        REFERENCES Superpowers(IdSuperpower)
);

DROP TABLE IF EXISTS Character_Category;
CREATE TABLE IF NOT EXISTS Character_Category(
	IdCharacter INT NOT NULL,
    IdCategory INT NOT NULL,
		FOREIGN KEY (IdCharacter)
        REFERENCES Characters(IdCharacter),
		FOREIGN KEY (IdCategory)
        REFERENCES Categories(IdCategory)
);

DROP TABLE IF EXISTS Character_Universe;
CREATE TABLE IF NOT EXISTS Character_Universe(
	IdCharacter INT NOT NULL,
    IdUniverse INT NOT NULL,
		FOREIGN KEY (IdCharacter)
        REFERENCES Characters(IdCharacter),
		FOREIGN KEY (IdUniverse)
        REFERENCES Universes(IdUniverse)
);

DROP TABLE IF EXISTS Character_Team;
CREATE TABLE IF NOT EXISTS Character_Team(
	IdCharacter INT NOT NULL,
    IdTeam INT NOT NULL,
		FOREIGN KEY (IdCharacter)
        REFERENCES Characters(IdCharacter),
		FOREIGN KEY (IdTeam)
        REFERENCES Teams(IdTeam)
);

DROP TABLE IF EXISTS Character_Occupation;
CREATE TABLE IF NOT EXISTS Character_Occupation(
	IdCharacter INT NOT NULL,
    IdOccupation INT NOT NULL,
		FOREIGN KEY (IdCharacter)
        REFERENCES Characters(IdCharacter),
		FOREIGN KEY (IdOccupation)
        REFERENCES Activities(IdOccupation)
);