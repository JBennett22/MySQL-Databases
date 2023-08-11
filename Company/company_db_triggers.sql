DELIMITER $$
CREATE TRIGGER depcheck_del
BEFORE DELETE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF ((SELECT COUNT(*) FROM EMPLOYEE WHERE DNo = OLD.DNo) = 1)
    OR (OLD.Ssn IN (SELECT Mgr_Ssn FROM EMPLOYEE JOIN DEPARTMENT ON Dno = Dnumber WHERE DNo = OLD.DNo))
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot empty a department or remove its manager (DEL).';
    END IF;
END $$

CREATE TRIGGER depcheck_upd
BEFORE UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF  (OLD.Dno<>NEW.Dno) AND
        (((SELECT COUNT(*) FROM EMPLOYEE WHERE DNo = OLD.DNo) = 1)
    OR (OLD.Ssn IN (SELECT Mgr_Ssn FROM EMPLOYEE JOIN DEPARTMENT ON Dno = Dnumber WHERE DNo = OLD.DNo)))
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot empty a department or remove its manager (UPD).';
    END IF;
END $$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER re_add
AFTER INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF  (NEW.Dno=5) THEN SET @RDE_BALANCE = @RDE_BALANCE+1;
    END IF;
END $$

CREATE TRIGGER re_del
AFTER DELETE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF  (OLD.Dno=5) THEN SET @RDE_BALANCE = @RDE_BALANCE-1;
    END IF;
END $$

CREATE TRIGGER re_upd
BEFORE UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF  (NEW.Dno=5) THEN SET @RDE_BALANCE = @RDE_BALANCE+1;
    END IF;
    IF  (OLD.Dno=5) THEN SET @RDE_BALANCE = @RDE_BALANCE-1;
    END IF;
END $$
DELIMITER ;
