--Query 1
EXPLAIN QUERY PLAN SELECT COUNT(DISTINCT  L.host_id), N.city
FROM Neighbourhood N, Listing L, Described_Description D
WHERE L.id = D.id AND L.neighbourhood = N.neighbourhood AND D.square_feet <> -1
GROUP BY N.city
ORDER BY N.city ASC;

--Query 2
WITH RankedTable AS(
    SELECT neighbourhood, review_scores_rating,
        ROW_NUMBER() OVER (PARTITION BY neighbourhood ORDER BY review_scores_rating) AS rank,
        COUNT(*) OVER (PARTITION BY neighbourhood) AS number_total
    FROM (SELECT L.neighbourhood, S.review_scores_rating
		  FROM Listing L, Score S
		  WHERE L.id=S.id AND L.city = 'Madrid')
)
SELECT R.neighbourhood
FROM RankedTable R
WHERE R.rank = R.number_total / 2 + 1
ORDER BY R.review_scores_rating DESC LIMIT 5;

--Query 3
SELECT L.host_id, H.host_name
FROM Listing L, Host H
WHERE L.host_id = H.host_id
GROUP BY L.host_id
HAVING COUNT(*) = (SELECT COUNT(L.id) as max_listings
FROM Listing L
GROUP BY host_id
ORDER BY COUNT (L.id) DESC limit 1)

--Query 4
SELECT AVG(AV.price)
FROM Listing L, Available_at AV, Score S, Verified_by V
WHERE L.city='Berlin' AND L.beds >= 2 AND S.review_scores_location >= 8 AND S.id= L.id
	  AND L.cancellation_policy = 'flexible' AND L.host_id = V.host_id
	  AND (V.host_verifications='government_id' OR V.host_verifications='offline_government_id')
	  AND L.id=AV.id AND AV.date >= '2019-03-01' AND AV.date <= '2019-04-30' AND AV.available = 't';


--Query 5
SELECT * from(
SELECT L.id, L.accommodates, ROW_NUMBER() OVER(
	PARTITION BY L.accommodates
	ORDER BY (SELECT S.review_scores_rating)
) rank_for_this_type
FROM Listing L, Score S
WHERE L.id = S.id and S.review_scores_rating >= 0
AND 2 >= (SELECT COUNT (*)
FROM Provides P
WHERE P.id=L.id
AND(P.amenities='Wifi' OR P.amenities='Internet'
    OR P.amenities='TV'OR P.amenities='Free street parking'))
)
WHERE rank_for_this_type <= 5;

--Query 6
SELECT * FROM(
    SELECT  L.host_id, H.host_name, L.id, L.name, ROW_NUMBER() OVER (
        PARTITION BY L.host_id
        ORDER BY (SELECT COUNT(R.review_id))
    )rank
    FROM Listing L, Reviewed R, Host H
    WHERE R.id=L.id AND H.host_id = L.host_id
    GROUP BY L.id
)
WHERE rank <= 3


--Query 7
SELECT nc.neighbourhood, cc.city, amenities
FROM (
	SELECT  ROW_NUMBER () OVER (
        PARTITION BY  n.neighbourhood
        ORDER BY count(lp.id) DESC
    )AS c,
 	n.neighbourhood, lp.amenities, count(*)
 	FROM Provides lp JOIN Listing l ON l.ID = lp.id
	JOIN NEIGHBOURHOOD n ON n.neighbourhood = l.neighbourhood
	WHERE n.city IN
	(SELECT City.city FROM City WHERE city = 'Berlin') and l.room_type = 'Private room'
	GROUP BY  n.neighbourhood, lp.amenities
	ORDER BY count(lp.id) DESC
)a
JOIN NEIGHBOURHOOD nc on a.neighbourhood = nc.neighbourhood
JOIN CITY cc ON cc.city = nc.city
WHERE a.c < 4
ORDER BY nc.neighbourhood, amenities DESC;


--Query 8
SELECT *
FROM(
  (SELECT H.host_id AS ID1, COUNT(V.host_verifications) AS N1, AVG(S.review_scores_communication) AS AV1
  FROM Verified_by V, Host H,Listing L, SCORE S
  WHERE V.host_id = H.host_id and L.host_id=h.host_id AND S.id = L.id
  GROUP BY H.host_id
  ORDER BY COUNT(host_verifications) DESC LIMIT 1),

  (SELECT H2.host_id AS ID2, COUNT(V2.host_verifications) AS N2, AVG(S2.review_scores_communication) AS AV2
  FROM Verified_by V2, Host H2, Listing L2, SCORE S2
  WHERE V2.host_id = H2.host_id and L2.host_id=h2.host_id AND S2.id = L2.id
  AND S2.review_scores_communication != -1 --
  GROUP BY H2.host_id
  ORDER BY COUNT(host_verifications) ASC LIMIT 1));

--Query 9
select city
From (
    Select count(r.id) as reviews ,listing.city as city
    From Listing listing, Reviewed r,
         (
        Select rt
        From (
        Select avg(l.accommodates)as avg, l.room_type as rt
        From Listing l
        GROUP BY l.room_type)
        where avg>3)
    where r.id=listing.id and listing.room_type=rt
    group by listing.city)
order by reviews desc limit 1;

--Query 10 (problematic, no results)
Select *
From(
    select count(distinct a.id) as occupiedNr, l1.neighbourhood as occupiedN
    from available_at a, host h, Listing l1

    where L1.id in (
      SELECT  L3.id as occupiedId
      FROM Listing L3, available_at A3
      WHERE L3.id = A3.id AND A3.date >= '2019-01-01' and A3.date <= '2019-12-31'
      GROUP BY L3.id
      HAVING COUNT(A3.available = 'f') >= 1
    ) and h.host_id= l1.host_id and a.id=l1.id and h.host_since < '2017-06-01' and l1.city='Madrid'
    group by l1.neighbourhood),

    (Select count( distinct l2.id) as totalNr, l2.neighbourhood as N
    from Listing l2
    where l2.city='Madrid'
    group by l2.neighbourhood)
where occupiedN=N and occupiedNr >= totalNr / 2;

--Query 11
SELECT CC1
FROM
(select L.country_code AS CC1, count(DISTINCT L.id) AS CA
From  Listing L
Where L.id in(
  select A.id
  from  available_at A
  where  A.date >= '2018-01-01' AND A.date <= '2018-12-31'
   GROUP BY A.id
    HAVING COUNT(A.available = 't') >= 1
)
group by L.country_code),

(select L1.country_code AS CC2, count(DISTINCT L1.id) AS CTOT
From  Listing L1
Where L1.id in(
  select A1.id
  from  available_at A1
  where  A1.date >= '2018-01-01' AND A1.date <= '2018-12-31'
   GROUP BY A1.id
)
group by L1.country_code)
WHERE CC1 = CC2 AND CA >= CTOT / 5

--Query 12
SELECT NE1 FROM
(SELECT L.neighbourhood AS NE1, COUNT(DISTINCT L.id) AS COUNT1
FROM Neighbourhood N, Listing L
WHERE L.cancellation_policy = 'strict_14_with_grace_period' AND N.city = 'Barcelona' AND L.neighbourhood = N.neighbourhood
GROUP BY L.neighbourhood),

(SELECT L1.neighbourhood AS NE2, COUNT(DISTINCT L1.id) AS COUNT2
FROM Neighbourhood N1, Listing L1
WHERE N1.city = 'Barcelona' AND L1.neighbourhood = N1.neighbourhood
GROUP BY L1.neighbourhood)
WHERE NE1 = NE2 AND COUNT1 > COUNT2 / 20
