# Aviation_Accidents_EDA
About Dataset:

Airplane Crashes and Fatalities:

- The aviation accident dataset (1980-2022) contains information about civil aviation 
accidents and selected incidents within the United States, its territories and possessions, and in 
international waters. Following thorough data cleaning and preprocessing, a revamped aviation 
accident database was established. Subsequently, an in-depth analysis was carried out using intricate 
query composition, and the findings were presented visually through the creation of an informative 
dashboard.
- Tools used: Integration of Excel, SQL and Tableau
- Key skills: Data cleaning, database modelling, exploratory data analysis, visualization, SQL functions (join, group by, cast, case statement and common table expressions)

- This dataset showcases Boeing 707 accidents that have occurred since 1948. The data includes information on the date, time, location, operator, flight number, route, type of aircraft, registration number, cn/In number of persons on board, fatalities, ground fatalities, and a summary of the accident.
- The dataset initally consisted of 88890 rows and 32 columns with n number of missing records. Imputed the missing records with "0" for numerical data and "unknown" for categorical data.
- Inorder to perform exploratory data analysis on this dataset using MySQL workbench, splited the dataset into 4 different tables and revamped it as a new Entity Relationship Model database.
- After creation of Aviation Analysis database in SQL, performed complex queries to extract data and insights regarding the Aviation accidents and investigation reports on the incident yearwise.

Sample Queries performed:
- Evaluating Total Passengers and fatalities in each flight
-  Looking at cases where Injuries were not recorded
-  Evaluating Percentage of Fatality in each flight and streamlining to Nigeria and Australia
-  Countries with highest number of accidents
-   Purpose of flight by number of accidents
-   Number of accidents recorded per year
-   Extent of Aircraft damage and fatality
-   Analysing the Causes of Accidents
-   Creating a view of data to be used later
-   Aircraft and carrier information
-   Create the virtual table with report status defined and export into csv file


- The above analysis performed in MySQL was later exported into Tableau visualization tool to visualise and created interactive dashboards to retrive further insights.
