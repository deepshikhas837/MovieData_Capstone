# MovieData_Capstone

## Movie Data Analysis & Predictions

## Overview
This project aims to analyze movie data to gain insights into various aspects of movie performance, including budget, revenue, genre, language, and demographic preferences. Using statistical and machine learning techniques, we predict the box office success of movies before their release, focusing on factors like cast, crew, budget, and more.

## Project Structure

- **Data Files**:  
  - `movies.csv`: Contains details about movies such as budget, revenue, genres, etc.
  - `production_companies.csv`: Information about production companies.
  - `actors.csv`: Details about actors involved in movies.
  - `directors.csv`: Details about directors of the movies.
  - `genres.csv`: Lists movie genres.
  - `movie_actors.csv`: Relationship between movies and actors.
  - `movie_companies.csv`: Relationship between movies and production companies.
  - `movie_genres.csv`: Relationship between movies and genres.

## Key Focus Areas

1. **Budget & Revenue Correlation**:  
   Analyzing how budget impacts movie success by studying the correlation between budget, revenue, and profitability. This includes identifying optimal budget ranges for maximizing return on investment.

2. **Language & Market Reach**:  
   Analyzing how the language of a movie influences its international success and revenue. This includes evaluating the performance of non-English movies and how different languages impact audience reach and genre preferences.

3. **Viewer Demographics & Preferences**:  
   Using clustering techniques (e.g., K-Means) to understand how demographic preferences (genre, runtime) influence movie success and target audience identification.

4. **Predictive Modeling for Box Office Success**:  
   Developing machine learning models (KNN, Random Forest, etc.) to predict a movie’s revenue before release. This includes identifying the most influential predictors of success, such as genre, cast, and director.

## Business Objectives

1. **Find the Ideal Budget Range for Profit Maximization**  
   Analyze if there is a specific budget range where the return on investment (ROI) is maximized.

2. **Analyze the Influence of Language on Movie Revenue**  
   Investigate whether non-English language movies perform well at the global box office.

3. **Develop Predictive Models for Movie Success**  
   Create models that predict a movie’s potential revenue before its release based on historical data.

## Technologies Used

- **Python**:  
  - Pandas for data manipulation
  - Scikit-learn for machine learning models (KNN, Random Forest)
  - Statsmodels for statistical analysis
  - K-Means clustering for demographic analysis

- **MySQL**:  
  - SQL queries to analyze relationships between movie data (joins, subqueries, etc.)

- **Tableau**:  
  - Data visualization and reporting

## Methods

- **Exploratory Data Analysis (EDA)**:  
  Investigating the data through descriptive statistics, visualizations, and correlation matrices.

- **Statistical Testing**:  
  Using Z-tests, T-tests, and other statistical methods to test hypotheses.

- **Machine Learning Models**:  
  - KNN and Random Forestfor predicting revenue based on movie features.
