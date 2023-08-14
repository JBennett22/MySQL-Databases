#a.	List every pairing of a player’s last name with those of his/her head coaches. (Note that a player can play on more than one team at his/her university!)
SELECT LName as PlayerLName, HeadCoachLName
FROM STUDENTATHLETE NATURAL JOIN PLAYSFOR NATURAL JOIN TEAM; 

#b.	List every player’s first name, last name, and team captainship(s) by TeamID.  Every player should appear a minimum of once – if he or she is not a team captain, a NULL should be returned in lieu of the TeamID.
SELECT FName, LName, Sport
FROM STUDENTATHLETE LEFT JOIN TEAM on SAID=CaptainSAID;

#c.	List any university in the database that has no sports teams at all, by university name.
SELECT UniversityName
FROM University U
WHERE NOT EXISTS
(SELECT * FROM TEAM T WHERE T.UCode = U.UCode);

#d.	Find the student athlete ID of any student playing on a team not at their current university (indicating either a transfer or a potential issue.)
SELECT SA.SAID
FROM STUDENTATHLETE AS SA NATURAL JOIN PLAYSFOR AS PF, TEAM T
WHERE PF.TeamID = T.TeamID AND SA.UCode <> T.UCode;

#e.	Find the first and last name of any player who was on the roster for at least one team that plays a game beginning on October 31, 2020.
SELECT DISTINCT FName, LName
FROM STUDENTATHLETE NATURAL JOIN PLAYSFOR NATURAL JOIN TEAM, GAME
WHERE StartDate<='2020-10-31' AND (EndDate>='2020-10-31' OR EndDate IS NULL) AND DATE(StartTime)='2020-10-31' AND (TeamID=HomeTID OR TeamID=VisTID);

#f.	List every cross-division game by GameID, StartTime, and  EndTime.
SELECT GID, StartTime, EndTime
FROM UNIVERSITY AS HU NATURAL JOIN TEAM JOIN GAME ON HomeTID=TEAMID, UNIVERSITY AS VU, TEAM as VT
WHERE VT.TEAMID=VisTID AND VU.UCode=VT.UCode and HU.Division <> VU.Division;

#g.	List all teams (by university name and sport) with at least three athletes on their rosters in the year 2020.
SELECT UniversityName, Sport
FROM UNIVERSITY NATURAL JOIN TEAM
WHERE TeamID IN
(SELECT TeamID
FROM PLAYSFOR
WHERE (YEAR(StartDate)<=2020 AND (YEAR(EndDate)>=2020 OR YEAR(EndDate) IS NULL))
GROUP BY TeamID
HAVING COUNT(*)>=3); 

#h.	Find the all-time Win/Loss record of the University of Louisville Foosball (not Football) team.  Don’t forget to consider that a team can be either home or visitor!
SELECT SUM(IF(ScoresRaw.OurScore>ScoresRaw.TheirScore,1,0)) AS 'W',
	   SUM(IF(ScoresRaw.OurScore<ScoresRaw.TheirScore,1,0)) AS 'L'FROM 
((SELECT HomeScore AS OurScore, VisScore AS TheirScore
FROM (UNIVERSITY NATURAL JOIN TEAM) JOIN GAME ON TeamID=HomeTID
WHERE UniversityName = 'Coridsville' AND Sport='Foosball' AND EndTime IS NOT NULL)
UNION ALL
(SELECT VisScore AS OurScore, HomeScore AS TheirScore
FROM (UNIVERSITY NATURAL JOIN TEAM) JOIN GAME ON TeamID=VisTID
WHERE UniversityName = 'Coridsville' AND Sport='Foosball' AND EndTime IS NOT NULL)) AS ScoresRaw;
