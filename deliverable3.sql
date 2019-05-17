SELECT
(
 (SELECT MAX(Score) FROM
   (SELECT TOP 50 PERCENT Score FROM Posts ORDER BY Score) AS BottomHalf)
 +
 (SELECT MIN(Score) FROM
   (SELECT TOP 50 PERCENT Score FROM Posts ORDER BY Score DESC) AS TopHalf)
) / 2 AS Median

SELE



WITH RankedTable AS (
    SELECT neigbourhood, rewiew, 
        ROW_NUMBER() OVER (PARTITION BY neighbourhod ORDER BY score) AS rank,
        COUNT(*) OVER (PARTITION BY neighbourhhod) AS number_total
    FROM (SELECT L.neigbourhood, S.score
		  FROM Listing L, Score S
		  WHERE L.id=S.id )
)

SELECT TOP(5) R.neigbourhood
FROM RankedTable R
WHERE R.rank = R.number_total / 2 + 1  #change it 
ORDER BY R.rewiew DESC

SELECT host_id
FROM Listing L
GROUP BY host_id
ORDER BY COUNT (L.id) DESC

SELECT AVG(L
FROM Listing L, Available_at AV, Score S, verified_by V
WHERE L.city='Berlin' AND L.beds >=2 AND S.scores_location >=8 AND S.id= L.id
	  AND L.cancellation_policy = 'flexible' AND L.host_id=V.host_id 
	  AND (V.host_verifications='government_id' OR V.host_verifications='offline_government_id')
	  AND 't'=ALL(SELECT AV1.available
		          FROM Available_at AV1 
                  WHERE L.id=AV1.id AND AV1.date BETWEEN '2019-03-01' AND '2019-04-30' )
	  
				  
				  
				  
SELECT 
FROM Listing L
WHERE 't'= 	  