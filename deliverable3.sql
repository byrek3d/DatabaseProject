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


--Query 5 RIP

--Query 6
WITH COUNTER AS (
SELECT COUNT(R.review_id) as lala, L.id, H.host_id, H.host_name
FROM Reviewed R, LISTING L,Host H
WHERE  H.host_id = L.host_id AND R.id = L.id
GROUP BY L.id
)
SELECT COUNT(*)
FROM COUNTER C
GROUP BY C.host_id
ORDER BY

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
    select  count(distinct a.id) as occupiedNr, l1.neighbourhood as occupiedN
    from available_at a, host h,Listing l1
    where a.date >= '2019-01-01' and  a.date <= '2019-12-31'  and h.host_id= l1.host_id and a.id=l1.id and h.host_since >= '2017-06-01' and l1.city='Madrid'
    group by l1.neighbourhood having  a.available='t') ,

    (Select count( distinct l2.id) as totalNr, l2.neighbourhood as N
    from Listing l2
    where l2.city='Madrid'
    group by l2.neighbourhood)
where occupiedN=N and occupiedNr >= totalNr/2;