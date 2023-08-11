# View that pairs all agents with raised alarms
CREATE VIEW MATCHEDALARMS AS SELECT AID, ACode
FROM AGENT LEFT JOIN ALARM ON AID = RBAID;

DELIMITER &&
CREATE TRIGGER auto_error
BEFORE INSERT ON ALARM
FOR EACH ROW
BEGIN	
    IF (SELECT COUNT(*)         
         FROM AGENT JOIN LOCATION ON SALID = LID
          WHERE (AID = NEW.RBAID) AND (LID<>NEW.LALID) 
          AND (Type = 'A'))>0
          THEN SIGNAL SQLSTATE '45000' 
              SET MESSAGE_TEXT="Automated system raised alarm in location other than its own.";
	 END IF;
  END&&
DELIMITER ;