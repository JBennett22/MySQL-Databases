#a.      List all TID and TDesc of TASKs associated with the COMPUTER with AID value of 20211007.
SELECT TID,TDesc
FROM COMPUTER NATURAL JOIN TASK
WHERE AID=20211007;

#b.      List the AIDs of all “heavy-core” computers.  A “heavy-core” computer must have a minimum of 100 CPU Cores and 10000 GPU Cores.
SELECT AID
FROM COMPUTER JOIN CPU ON CSN = CPU.SERIALN JOIN GPU ON GSN = GPU.SERIALN
WHERE (CPU.CORES>=100) AND (GPU.CORES>=10000);

#c.       Pair the SerialN of every CPU with the AID of every COMPUTER in which it has been a component; if a CPU has no matching COMPUTER there should be a 
#		  single return for its SerialN paired with NULL.
SELECT SerialN, AID
FROM CPU LEFT JOIN COMPUTER ON SerialN = CSN;

#d.       List all attributes of each COMPUTER that is an “expensive assembly.”  An expensive assembly is one whose AssemblyCost is at least 10% of the sum of 
#         its component prototype (CPU and GPU) costs.
SELECT * FROM 
COMPUTER JOIN CPU ON CSN = CPU.SERIALN JOIN GPU ON GSN = GPU.SERIALN
WHERE AssemblyCost > 0.1*(CPU.Cost + GPU.COST);

#e.      List the SerialN of all GPU never used in a task.  This doesn’t imply the GPU cannot have been used as a COMPUTER component – it just requires none of 
#		 these COMPUTERs have an associated TASK.   
SELECT SerialN 
FROM GPU
WHERE NOT EXISTS (  SELECT *
				FROM COMPUTER NATURAL JOIN TASK
                WHERE SerialN = GSN);
#f.        List the AIDs of any every COMPUTER that has executed or is executing 2 or more tasks simultaneously.  Simultaneous tasks on a given COMPUTER must 
#     	   have some overlap during time of execution.  Hint: task A overlaps earlier task B if 1. A’s StartTime is later than the B’s StartTime and 
#          2. B’s EndTime is either later than A’s StartTime or is ongoing.   Each AID must appear at most once.
SELECT DISTINCT AID 
FROM COMPUTER NATURAL JOIN TASK
WHERE TID IN (
			SELECT T1.TID
			FROM COMPUTER NATURAL JOIN TASK T1, TASK T2
			WHERE (T1.AID = T2.AID) AND (T1.TID <> T2.TID) AND (T1.StartTime<=T2.StartTime)
					AND ((T1.EndTime IS NULL) OR (T1.EndTime>T2.StartTime)));
