
# Q.1. Who is the senior most employee based on job title?

select * from employee
order by levels Desc
limit 1;

# Q.2. Which countries have the most Invoices?

 select count(*) As Total_Invoices , billing_country from invoice
 group by billing_country
 order by total_invoices desc;
 
 # Q.3. What are top 3 values of total invoice?
 
 select total from invoice
 order by total desc
 limit 3;
 
# Q.4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
#	   Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice  totals
		
 select billing_city As City , sum(total) As Total_Invoicess from invoice
 group by billing_city
 order by Total_Invoicess desc
 limit 1;
 
 
# Q.5. Who is the best customer? The customer who has spent the most money will be declared the best customer.
# 	 Write a query that returns the person who has spent the  most money
 
SELECT customer.customer_id, MAX(first_name) AS first_name, last_name, SUM(total) AS total_spending
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id, last_name
ORDER BY total_spending DESC
LIMIT 1;

# Q.2.1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners.
#	   Return your list ordered alphabetically by email starting with A

select distinct c.email, c.first_name , c.last_name,g.name as Genre from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join genre g on t.genre_id = g.genre_id
where g.name = "Rock" 
order by email;

# 2.2 . Let's invite the artists who have written the most rock music in our dataset. 
# 		Write a query that returns the Artist name and total track count of the top 10 rock bands


SELECT ar.name AS Artist, COUNT(*) AS TrackCount FROM artist ar
JOIN album2 al ON ar.artist_id = al.artist_id
JOIN track t ON al.album_id = t.album_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY ar.name	
ORDER BY TrackCount DESC
LIMIT 10;


# 3. Return all the track names that have a song length longer than the average song length. 
# 	 Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first


select track.name As Name , milliseconds As Length from track 
where milliseconds > (SELECT AVG(milliseconds) FROM track)
order by milliseconds Desc;

# 3.1 1 Find how much amount spent by each customer on artists? Write a query to return  customer name, artist name and total spent


SELECT customer.first_name  As Customer_FName, customer.last_name AS Customer_Name, artist.name AS Artist_Name, SUM(invoice.total) AS Total_Spent
FROM customer  
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN album2 ON track.album_id = album2.album_id
JOIN artist ON album2.artist_id = artist.artist_id
GROUP BY Customer_FName, Customer_Name, Artist_Name
ORDER BY Total_Spent DESC;


# 2. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. 
# 	 Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres

										# Using Common table expression (CTE) 
WITH popular_genre AS  																			
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1;

# 3. Write a query that determines the customer that has spent the most on music for each country.
# 	 Write a query that returns the country along with the top customer and how much they spent. 
#	 For countries where the top amount spent is shared, provide all customers who spent this amount

WITH Customter_with_country AS (
		SELECT billing_country As Country ,customer.customer_id,first_name,last_name,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 					
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1

/* Project by : https://www.linkedin.com/in/prathmesh-pophale-4429221ba */
/* Thank You */