

#Query A: All roles performed by an individual named "Pat Indria" (each role should be displayed only once!)
SELECT DISTINCT Role 
FROM CREDIT, PROFESSIONAL 
WHERE CREDIT.SAGID = PROFESSIONAL.SAGID AND PROFESSIONAL.Name = 'Pat Indria';

#Query B: The total compensation paid to professionals who worked on the set of the movie titled "Sources Beneath"
SELECT SUM(Compensation) 
FROM CREDIT, MOVIE 
WHERE CREDIT.ProdID = MOVIE.ProdID AND TITLE = 'Sources Beneath';

#Query C: The name of every professional who is working on a movie that has not yet been released
SELECT DISTINCT PROFESSIONAL.SAGID, Name 
FROM PROFESSIONAL, CREDIT, MOVIE 
WHERE ReleaseDate IS NULL AND CREDIT.ProdID = MOVIE.ProdID AND CREDIT.SAGID = PROFESSIONAL.SAGID; 

#Query D: The count of all professionals who worked on the set of the movie with the title "Martian War" -- professional can have multiple roles in a production.
SELECT Count(DISTINCT SAGID) 
FROM CREDIT,MOVIE 
WHERE CREDIT.ProdID = MOVIE.ProdID AND MOVIE.TITLE = 'Martian War';

#Query E: The names of all professionals who refuse to work with an individual by the name "Melvin Thomas" (you can assume only one SAGID is registered to this name)
SELECT PNL.SAGID, PNL.Name
FROM PROFESSIONAL PNL, PROFESSIONAL PRE, NOLIST 
WHERE NOLIST.NLID = PNL.SAGID AND PRE.SAGID = NOLIST.RefuseID AND PRE.Name = 'Melvin Thomas';