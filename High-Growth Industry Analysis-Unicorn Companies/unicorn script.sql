-- The task will be broken down using two CTEs 
-- The best industry is found by counting the number of 'unicorns' in each industry and selecting the 3 highest ranking industries 

WITH best_industry AS (
 SELECT i.industry, 
		COUNT(*) AS num_unicorns -- counts the number of 'unicorns'
FROM industries AS i
LEFT JOIN dates AS d -- joins the dates table to the industries table
USING(company_id)
WHERE EXTRACT(year FROM d.date_joined) between 2019 AND 2021 -- filters for years 2019, 2020 and 2021
GROUP BY i.industry
ORDER BY num_unicorns DESC
LIMIT 3),

-- The average valuation for these industries are now calculated 

second AS (SELECT i.industry, 
		EXTRACT(year FROM d.date_joined) AS year,
		COUNT(*) AS num_unicorns,
		ROUND(AVG(f.valuation/1000000000),2) AS average_valuation_billions -- calculates the average valuations in billions and rounds it to two decimals
FROM industries AS i
LEFT JOIN dates AS d -- joins the dates table to the industries table
USING(company_id)
LEFT JOIN funding AS f -- joins the funding table to the industries table
USING(company_id)
WHERE EXTRACT(year FROM d.date_joined) between 2019 AND 2021
GROUP BY i.industry, year
ORDER BY year DESC)

-- Now the CTEs will be joined to produce the final result. 

SELECT 	s.industry,
		s.year,
		s.num_unicorns,
		s.average_valuation_billions
FROM best_industry AS b
JOIN second AS s
ON b.industry = s.industry; -- joins both CTEs