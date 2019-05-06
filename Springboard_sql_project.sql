/* Q1: Some of the facilities charge a fee to members, but some do not. Please list the names of the facilities that do. */
SELECT 'name'
FROM 'Facilities'
WHERE 'membercost' >=0



￼/* Q2: How many facilities do not charge a fee to members? */ Q:
SELECT COUNT(`name`) FROM `Facilities`
WHERE `membercost` >0 LIMIT 0 , 30

/* Q3: How can you produce a list of facilities that charge a fee to members, 
where the fee is less than 20% of the facility's monthly maintenance cost? 
Return the facid, facility name, member cost, and monthly maintenance of the 
facilities in question. */

SELECT 'facid', 'name', 'membercost', 'monthlymaintenence'
FROM 'Facilities'
WHERE 'membercost' <= (.2 * 'monthlymaintenence)
LIMIT 0, 30



/* Q4: How can you retrieve the details of facilities with ID 1 and 5? 
Write the query without using the OR operator. */

SELECT *
FROM 'Facilities'
WHERE 'facid'
IN (1,5)
LIMIT 0, 30


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost 
is more than $100? Return the name and monthly maintenance of the facilities 
in question. */

SELECT 'name' , 'monthlymaintenence',
CASE WHEN 'monthlymaintenence' <= 100
THEN 'cheap'
ELSE 'expensive'
END AS cheap_or_expensive
FROM 'Facilities'
LIMIT 0, 30

/* Q6: You'd like to get the first and last name of the last member(s) who signed up. 
Do not use the LIMIT clause for your solution. */


SELECT `firstname` , `surname`
FROM `Members`
ORDER BY `joindate` DESC


/* Q7: How can you produce a list of all members who have used a tennis court? 
Include in your output the name of the court, and the name of the member formatted as a single column. 
Ensure no duplicate data, and order by the member name. */

SELECT CONCAT( m.firstname, ' ', m.surname ) AS name, 
CASE WHEN b.facid =0
THEN 'Court 1'
ELSE 'Court 2'
END AS court
FROM Members AS m
JOIN Bookings AS b ON m.memid = b.memid 
WHERE facid
IN ( 0, 1 )
ORDER BY name
LIMIT 0 , 30



/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30?
 Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the facility, the name of the member formatted as a single column, and the cost. 
Order by descending cost, and do not use any subqueries. */

SELECT CONCAT(m.firstname, ' ', m.surname) AS name, f.name AS fac_name,
CASE WHEN b.memid >= 0
THEN b.slots * f.membercost
ELSE b.slots * guestcost
END AS costFROM Members AS maintenance
JOIN Bookings AS b ON m.memid = b.memid
JOIN Facilities AS f ON f.facid= b.facid
WHERE CAST(b.starttime AS CHAR) LIKE '2012-09-14%'
ORDER BY cost DESCLIMIT 0, 14


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT CONCAT(m.firstname, ' ', m.surname) AS name, f.name AS fac_name, b.bookid,
CASE WHEN b.memid >= 0
THEN b.slots * f.membercost
ELSE b.slots * f.guestcost
END AS cost
FROM Members AS m
JOIN Bookings AS b ON m.memid = b.memid
JOIN Facilities AS f ON f.facid= b.facid
WHERE CAST(b.starttime AS CHAR) LIKE '2012-09-14%'
AND b.bookid
IN(
    SELECT b.bookid
    FROM Members AS m
    JOIN Bookings AS b ON m.memid = b.memid
    JOIN Facilities AS f ON f.facid= b.facid
    WHERE b.slots * f.membercost>= 30
    OR b.slots * f.guestcost>= 30
)
ORDER BY cost DESC
LIMIT 0, 14


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. 
Remember that there's a different cost for guests and members! */

SELECT f.name AS fac_name, SUM(
    CASE WHEN b.memid>=0
    THEN b.slots * f.membercost
    ELSE b.slots * guestcost
    END) AS revenue
    FROM Bookings AS b
    JOIN Facilities AS f ON f.facid = b.facid
    GROUP BY f.name
    ORDER BY revenueLIMIT 0, 3


