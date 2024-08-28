# High-Growth Industry Analysis: Unicorn Companies

## Overview
This project analyzes trends in high-growth companies, focusing on identifying industries with the highest valuations and understanding the rate at which new high-value companies (unicorns) are emerging. The analysis provides competitive insights for an investment firm on how to structure its portfolio by leveraging data on unicorn companies from 2019 to 2021.

## Dataset Description
The analysis is based on four datasets, each provided as a CSV file:

1. **dates.csv**: Contains details about the date a company became a unicorn and its founding year.
    - `company_id`: Unique ID for the company
    - `date_joined`: Date the company became a unicorn
    - `year_founded`: Year the company was founded

2. **funding.csv**: Includes information about the company's valuation and funding details.
    - `company_id`: Unique ID for the company
    - `valuation`: Valuation of the company in US dollars
    - `funding`: Total funding raised in US dollars
    - `select_investors`: Key investors in the company

3. **industries.csv**: Describes the industry each company operates in.
    - `company_id`: Unique ID for the company
    - `industry`: Industry of the company

4. **companies.csv**: Provides details about the companies' names and locations.
    - `company_id`: Unique ID for the company
    - `company`: Name of the company
    - `city`: City where the company is headquartered
    - `country`: Country where the company is headquartered
    - `continent`: Continent where the company is headquartered

## SQL Analysis Approach

The analysis uses SQL queries to identify the top 3 industries with the most unicorn companies and calculates their average valuations between 2019 and 2021.

### Key SQL Queries
1. **Finding Top Industries by Number of Unicorns (2019-2021):**  
   A Common Table Expression (CTE) is used to find the top 3 industries with the highest number of unicorns.
   ```sql
   WITH best_industry AS (
       SELECT i.industry, COUNT(*) AS num_unicorns
       FROM industries AS i
       LEFT JOIN dates AS d
       USING(company_id)
       WHERE EXTRACT(year FROM d.date_joined) BETWEEN 2019 AND 2021
       GROUP BY i.industry
       ORDER BY num_unicorns DESC
       LIMIT 3
   ),
   ```

2. **Calculating Average Valuation for Top Industries:**  
   A second CTE calculates the average valuation in billions of USD for these industries for each year.
   ```sql
   second AS (
       SELECT i.industry,
              EXTRACT(year FROM d.date_joined) AS year,
              COUNT(*) AS num_unicorns,
              ROUND(AVG(f.valuation/1000000000), 2) AS average_valuation_billions
       FROM industries AS i
       LEFT JOIN dates AS d USING(company_id)
       LEFT JOIN funding AS f USING(company_id)
       WHERE EXTRACT(year FROM d.date_joined) BETWEEN 2019 AND 2021
       GROUP BY i.industry, year
       ORDER BY year DESC
   )
   ```

3. **Combining Results to Produce Final Output:**  
   The final query joins the two CTEs to present the results.
   ```sql
   SELECT s.industry,
          s.year,
          s.num_unicorns,
          s.average_valuation_billions
   FROM best_industry AS b
   JOIN second AS s
   ON b.industry = s.industry;
   ```

## Results and Insights
- Identified the top 3 industries with the most unicorns from 2019 to 2021.
- Calculated the average valuations of unicorn companies within these industries to help determine which industries are producing the highest valuations and the rate at which new unicorns are emerging.

## Setup and Usage
1. **Requirements:**
   - Database management system (DBMS) such as PostgreSQL or MySQL.
2. **Instructions:**
   - Load the CSV files into your DBMS.
   - Execute the provided SQL script to replicate the analysis.

## Conclusion and Future Work
This analysis provides insight into high-growth industries and their valuation trends, which can help in strategic investment decisions. Future work could involve analyzing more granular data, such as funding rounds or investor profiles.

## References
- **Data Source:** The dataset used in this project was sourced from a DataCamp project "Analyzing Unicorn Companies".
