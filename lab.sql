CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer as c
JOIN rental as r 
ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

CREATE TEMPORARY TABLE customer_total_payments AS
SELECT 
    crs.customer_id,
    crs.full_name,
    crs.email,
    crs.rental_count,
    SUM(p.amount) AS total_paid
FROM customer_rental_summary as crs
JOIN payment as p 
ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id, crs.full_name, crs.email, crs.rental_count;

WITH customer_rental_payment_summary AS (
    SELECT 
        crs.full_name,
        crs.email,
        crs.rental_count,
        ctp.total_paid
    FROM 
        customer_rental_summary crs
    JOIN 
        customer_total_payments ctp ON crs.customer_id = ctp.customer_id
)
SELECT 
    full_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS Average_payment_per_rental
FROM 
    customer_rental_payment_summary;
