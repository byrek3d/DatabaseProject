SELECT AVG(P.price)
FROM Listing L, Pricing P
WHERE L.id=P.id AND L.beds=8 ;

SELECT AVG(S.review_scores_cleanliness)
FROM Listing L, Amenities A, SCORE S, PROVIDES P
WHERE L.id=S.id AND P.id=L.id AND P.amenities='tv' ;

SELECT DISTINCT L.host_id FROM Listing L, AVAILABLE_AT AV WHERE AV.id=L.id AND AV.available='t' AND AV.date <= '2019-09-31' AND AV.date >= '2019-03-00' ;

SELECT COUNT(*)
FROM Listing L1
WHERE EXISTS (SELECT L2.host_name
					   FROM Listing L2
					   WHERE L1.host_id < L2.host_id AND
							 L1.host_name = L2.host_name) ;

							 
SELECT DISTINCT AV.date
FROM Listing L, AVAILABLE_AT AV
WHERE L.host_name='Viajes Eco' AND AV.id= L.id AND AV.available='t' ;

SELECT DISTINCT L.host_id, L.host_name
FROM Listing L
GROUP BY (L.host_id)
HAVING COUNT (*) = 1 ;

SELECT AVG(L1.price) - AVG(L2.price)
FROM Listing L1, Listing L2
WHERE L1.id IN (SELECT L3.id
				FROM Listing L3, PROVIDE P1
				WHERE L3.id=P1.id AND P1.amenities='wifi')
      AND L2.id NOT IN (SELECT L4.id
						FROM Listing L4, PROVIDE P2
						WHERE L4.id=P2.id AND P2.amenities='wifi') ;
						
SELECT AVG(L1.price) - AVG(L2.price)
FROM Listing L1, Listing L2
WHERE L1.neighborhood='Berlin' AND L2.neighborhood='Madrid'
	  AND L1.beds=L2.beds AND L1.beds=8 ;

SELECT TOP (10)
L.host_id,L.host_name
FROM Listing L
WHERE L.country='Spain'
ORDER BY (SELECT COUNT(*)
		  FROM Listing L1
          WHERE L.host_id = L1.host_id AND L.id < L1.id) DESC ;

SELECT TOP (10)
L.id,L.name
FROM Listing L, Score S
WHERE L.neighborhood='Barcelona', S.id=L.id 
ORDER BY (S.review_scores_cleanliness) DESC ;