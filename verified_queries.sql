#Verified
SELECT AVG(P.price)
FROM Listing L, Pricing P
WHERE L.id=P.id AND L.beds=8 ;

#Verified
SELECT AVG(S.review_scores_cleanliness)
FROM Listing L, Amenities A, SCORE S, PROVIDES P
WHERE L.id=S.id AND P.id=L.id AND P.amenities='tv' ;

#Verified
SELECT DISTINCT L.host_id 
FROM Listing L, AVAILABLE_AT AV
WHERE AV.id=L.id AND AV.available='t' AV.date <= '2019-09-31' AND AV.date >= '2019-03-00' ;

#Verified
SELECT COUNT(*)
FROM Listing L1
WHERE EXISTS (SELECT L2.host_name
			  FROM Listing L2
			  WHERE L1.host_id < L2.host_id AND
			  L1.host_name = L2.host_name) ;

							 
SELECT DISTINCT AV.date
FROM Listing L, AVAILABLE_AT AV
WHERE L.host_name='Viajes Eco' AND AV.id= L.id AND AV.available='t' ;

SELECT DISTINCT (L.host_id, L.host_name)
FROM Listing L
GROUP BY (L.host_id)
HAVING COUNT (*) = 1 ;

#Verified
SELECT r1-r2
From (Select AVG(Pr2.price) As r2
      FROM Listing L2, PROVIDES P2, Pricing Pr2
      WHERE L2.id=P2.id AND P2.amenities<>'wifi' AND Pr2.id= L2.id),
     (select AVG(Pr1.price) as r1
      FROM Listing L1, PROVIDES P1, Pricing Pr1
      WHERE L1.id=P1.id AND P1.amenities='wifi' AND Pr1.id= L1.id);

#Verified
Select s1-s2
FROM(SELECT AVG(Pr1.price) AS s1
     FROM Listing L1, Pricing Pr1
     WHERE L1.city='Berlin' AND Pr1.id=L1.id
       AND L1.beds=8 ),
    (SELECT AVG(Pr2.price) AS s2
     FROM Listing L2, Pricing Pr2
     WHERE L2.city='Madrid' AND Pr2.id=L2.id
       AND L2.beds=8);

#Verified
SELECT DISTINCT L.host_id, H.host_name
FROM Listing L, Host H
WHERE L.country_code='ES' AND H.host_id = L.host_id
ORDER BY (SELECT COUNT(*)
		  FROM Listing L1
          WHERE L.host_id = L1.host_id AND L.id < L1.id) DESC
          LIMIT 10;


SELECT TOP (10) (L.id,L.name)
FROM Listing L, Score S
WHERE L.neighborhood='Barcelona' AND S.id=L.id 
ORDER BY (S.review_scores_cleanliness) DESC ;