USE shoeshop;

/* Vilka kunder har köpt svarta sandaler i storlek 38 av märket Ecco? Lista deras namn och
använd inga hårdkodade id-nummer i din fråga */
SELECT DISTINCT CONCAT(c.first_name, ' ',c.last_name) AS 'fullname' 
FROM customer c
JOIN orders o 
	ON c.id = o.customer_id
JOIN order_details od 
	ON o.id = od.orders_id
JOIN product p 
	ON od.product_id = p.id
JOIN product_category pc 
	ON p.id = pc.product_id
JOIN category cat 
	ON pc.category_id = cat.id
WHERE p.brand = 'Ecco' 
	AND p.size = 38 
	AND p.color = 'Black' 
	AND cat.name = 'Sandals';


-- Lista antalet produkter per kategori. Listningen ska innehålla kategori-namn och antalet produkter 
SELECT cat.name, count(pc.product_id) AS 'quantity' 
FROM category cat
LEFT JOIN product_category pc 
	ON cat.id = pc.category_id
GROUP BY cat.id 
ORDER BY quantity DESC;


/*Skapa en kundlista med den totala summanpengar som varje kund har handlat för. 
Kundens för-och efternamn, samt det totala värdet som varje person har shoppats för, skall visas.*/
SELECT CONCAT(c.first_name,' ',c.last_name) AS 'fullname', 
		IFNULL(SUM(p.price*od.quantity), 0) AS 'total_spent' 
FROM customer c
LEFT JOIN orders o 
	ON c.id = o.customer_id
LEFT JOIN order_details od 
	ON o.id = od.orders_id 
LEFT JOIN product p 
	ON od.product_id = p.id
GROUP BY c.id, 
		c.first_name,
		c.last_name;


/*Skriv ut en lista på det totala beställningsvärdet per ort där beställningsvärdet är större än
1000 kr. Ortnamn och värde ska visas. (det måste finnas orter i databasen där det har
handlats för mindre än 1000 kr för att visa att frågan är korrekt formulerad) */
SELECT c.city, SUM(p.price*od.quantity) AS 'order_value' 
FROM customer c
JOIN orders o 
	ON c.id = o.customer_id
JOIN order_details od 
	ON o.id = od.orders_id 
JOIN product p 
	ON od.product_id = p.id
GROUP BY c.city
HAVING SUM(p.price*od.quantity) > 1000;


-- Skapa en topp-5 lista av de mest sålda produkterna. 
SELECT  
	p.brand, 
	p.size, 
	p.color, 
	p.price, 
	SUM(od.quantity) AS 'total_sold' 
FROM product p 
JOIN order_details od 
	ON p.id = od.product_id
GROUP BY p.id
ORDER BY SUM(od.quantity) DESC
LIMIT 5;


/* Vilken månad hade du den största försäljningen? (det måste finnas data som anger
försäljning för mer än en månad i databasen för att visa att frågan är korrekt formulerad) */
SELECT YEAR(date) AS 'year', 
		MONTH(date) AS 'month',
		SUM(p.price * od.quantity) AS 'order_sum' 
FROM orders o
JOIN order_details od 
	ON o.id = od.orders_id
JOIN product p 
	ON od.product_id = p.id
GROUP BY YEAR(date), MONTH(date)
ORDER BY SUM(p.price * od.quantity) DESC
LIMIT 1;


