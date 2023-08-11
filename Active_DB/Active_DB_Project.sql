DROP DATABASE IF EXISTS ActiveDB;
CREATE DATABASE ActiveDB;
USE ActiveDB; #Default DB
CREATE USER 'active'@'localhost' IDENTIFIED BY 'data';

CREATE TABLE CUSTOMER
	(id int not null,
    name varchar(100) not null,
    email varchar(100) not null,
    `credit-card` char(16) not null,
    primary key (id));

CREATE TABLE AUTOPOD
	(ain char(10) not null,
    model varchar(64) not null,
    color varchar(16) not null,
    year int not null,
    primary key (ain));

CREATE TABLE DOCK
	(dockcode char(6) not null,
    location varchar(64) not null,
    capacity int not null,
    primary key (dockcode));

CREATE TABLE AVAILABLE
	(ain char(10) not null,
    dockcode char(6) not null,
    primary key (ain),
    foreign key (ain) references AUTOPOD (ain),
    foreign key (dockcode) references DOCK (dockcode));

CREATE TABLE RENTAL
	(ain char(10) not null,
    custid int not null,
    origdc char(6) not null,
    renttime datetime not null,
    primary key (ain, custid, renttime),
    foreign key (ain) references AUTOPOD (ain),
    foreign key (custid) references CUSTOMER (id),
    foreign key (origdc) references DOCK (dockcode));

CREATE TABLE COMPLETEDRENTAL
	(ain char(10) not null,
    custid int not null,
    inittime datetime not null,
    endtime datetime not null,
    origdc char(6) not null,
    destdc char(6) not null,
    cost decimal(10,2) not null,
    primary key (ain, custid, inittime),
    foreign key (ain) references AUTOPOD (ain),
    foreign key (custid) references CUSTOMER (id),
    foreign key (origdc) references DOCK (dockcode),
    foreign key (destdc) references DOCK (dockcode));
    

DELIMITER //
CREATE TRIGGER available_autopod
AFTER INSERT ON AUTOPOD
FOR EACH ROW
BEGIN
	IF count(dockcode)<DOCK.capacity
    THEN INSERT INTO AVAILABLE(ain, dockcode) VALUES (new.ain,new.dockcode);
    END IF;
END//
DELIMITER ;
    														
DELIMITER //
CREATE TRIGGER off_service
AFTER DELETE ON AUTOPOD
FOR EACH ROW
BEGIN
	DELETE FROM AVAILABLE
    WHERE AVAILABLE.ain = old.ain;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE StartRental(IN ain char(10),IN custid int)
BEGIN
	IF (new.ain<>char(10)) #OR new.custid<>int)
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT="These are not valid parameters";

	ELSEIF NOT EXISTS (SELECT * FROM AVAILABLE WHERE AVAILABLE.ain = new.ain)
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT="Autopod is not available";
    
    ELSE DELETE FROM AVAILABLE WHERE AVAIALBLE.ain = new.ain;
    INSERT INTO RENTAL(ain,custid) VALUES (new.ain,new.custid);
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EndRental(IN ain char(10),IN custid int,IN destdc char(6),IN cost decimal(10,2))
BEGIN
	IF NOT EXISTS (SELECT * FROM RENTAL WHERE RENTAL.ain=new.ain AND RENTAL.custid=new.custid)
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT="The vehicle and customer to not match";
	
    ELSEIF (destdc<>DOCK.capcity)
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT="This dock is at max capacity";
    
    ELSE DELETE FROM RENTAL WHERE RENTAL.ain = new.ain;
	SELECT * FROM RENTAL WHERE RENTAL.ain=new.ain AND RENTAL.custid=new.custid;
	INSERT INTO COMPLETEDRENTAL(ain,custid,destdc,cost,origdc,inittime,endtime) 
		VALUES (new.ain,new.custid,new.destdc,new.cost,RENTAL.origdc,RENTAL.inittime,endtime=now());
    END IF;
END//
DELIMITER ;