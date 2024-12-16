# SQL-Data-Analysis
This project analyzes a Spotify dataset of tracks, albums, and artists using SQL, involving dataset normalization, complex queries, and performance optimization to enhance SQL skills and extract insights.

# Spotify Data Analysis and Query Optimization using SQL
Dataset link:https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset
![spot2](https://github.com/user-attachments/assets/557dc97e-4565-4df7-b97a-b2b6edbeca2a)

# Overview
This project focuses on analyzing a Spotify dataset containing detailed attributes of tracks, albums, and artists using SQL. It encompasses the complete workflow, starting with normalizing a denormalized dataset, executing SQL queries of varying complexity (ranging from basic to advanced), and optimizing query performance. The primary objectives are to refine advanced SQL skills and extract meaningful insights from the dataset.

```sql
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
```

# Project Steps
## 1. Data Exploration

Before diving into SQL analysis, it's essential to understand the structure and attributes of the dataset. The dataset includes the following key fields:

- **`artist`**: The name of the performer or band.  
- **`track`**: The title of the song.  
- **`album`**: The album to which the track belongs.  
- **`album_type`**: The category of the album (e.g., single or full album).  
- Various track-level metrics:  
    - **`danceability`**: How suitable a track is for dancing.  
    - **`energy`**: The intensity and activity level of the track.  
    - **`loudness`**: The overall volume of the track.  
    - **`speechiness`**: The presence of spoken words in the track.  
    - **`acousticness`**: How acoustic the track is.  
    - **`liveness`**: The likelihood that the track was recorded live.  
    - **`valence`**: The musical positiveness conveyed by the track.  
    - **`tempo`**: The speed of the track (measured in BPM).  
    - **`duration_min`**: The length of the track in minutes.  
- **Engagement metrics**:  
    - **`views`**: Number of views.  
    - **`likes`**: Number of likes.  
    - **`comments`**: Number of comments.  
    - **`stream`**: Number of streams.  
- **Boolean Indicators**:  
    - **`licensed`**: Indicates whether the track is licensed.  
    - **`official_video`**: Indicates if the track has an official video.  
- **`most_played_on`**: The platform where the track is most played.

This exploration provides a solid foundation for analyzing trends, patterns, and insights in the dataset.


## 4. Querying the Data

Once the data has been inserted into the database, a variety of SQL queries can be written to explore and analyze it. The queries are organized into three difficulty levels to progressively enhance SQL skills:

### **Easy Queries**
- Basic data retrieval using `SELECT`.
- Filtering data with `WHERE` clauses.
- Simple aggregations using functions like `COUNT()`, `SUM()`, and `AVG()`.

### **Medium Queries**
- Grouping data with `GROUP BY` and applying aggregate functions.
- Filtering grouped data using `HAVING`.
- Combining tables using `JOIN` operations.

### **Advanced Queries**
- Implementing nested subqueries for complex filtering and calculations.
- Utilizing window functions like `RANK()`, `ROW_NUMBER()`, and `SUM() OVER`.
- Using Common Table Expressions (CTEs) for better query readability.
- Optimizing query performance with indexing and efficient query design.

## 5. Query Optimization

At advanced stages, the focus shifts to enhancing query performance. Key optimization strategies include:

- **Indexing**: Adding indexes to frequently queried columns to speed up data retrieval.
- **Query Execution Plan**: Leveraging `EXPLAIN` or `EXPLAIN ANALYZE` to analyze query execution paths and identify areas for improvement.

# Query Optimization Process

This document outlines the steps taken to optimize the performance of a SQL query.

## Initial Query Performance Analysis Using EXPLAIN

The process began with an analysis of the query's performance using the `EXPLAIN` function. The query was designed to retrieve tracks based on the `artist` column. The initial performance metrics were as follows:

- **Execution Time (E.T.):** 5.7 ms  
- **Planning Time (P.T.):** 0.162 ms 

Below is a screenshot of the `EXPLAIN` result prior to optimization:  

![1](https://github.com/user-attachments/assets/bb4650b6-34b2-4652-b327-6611cd92398c)


## Optimization Process

Further steps for optimizing the query were implemented to improve these metrics.

### Index Creation on the artist Column
To improve query performance, an index was created on the artist column. This allows for faster row retrieval when filtering by the artist column.

The SQL command used to create the index is as follows:

```sql
CREATE INDEX idx_artist ON spotify_new (artist);
```

### Performance Analysis After Index Creation

After creating the index, the same query was executed again, resulting in significant performance improvements.

- **Execution Time (E.T.):** 0.153ms  
- **Planning Time (P.T.):** 0.152ms

Below is a screenshot of the EXPLAIN result after the optimization:
![2](https://github.com/user-attachments/assets/85010f27-40cb-47c4-9e46-1a8453f3eb67)

### Graphical Performance Comparison
A graph illustrating the comparison between the initial query execution time and the optimized query execution time after index creation.
![3](https://github.com/user-attachments/assets/78ec0ea6-9418-4ae4-b6a0-34ddd74bc155)
![4](https://github.com/user-attachments/assets/1229cc28-aee3-4521-a737-cb47b3b225b8)

This optimization demonstrates how indexing can significantly reduce query execution time, enhancing the overall performance of database operations in the Spotify project.

## Technology Stack
**Database:** MySQL  
**SQL Queries:** DDL, DML, Aggregations, Joins, Subqueries, Window Functions  
**Tools:** MySQL Workbench, MySQL (installed via Homebrew, Docker, or direct installation)  

### Steps to Set Up and Work with the Database in MySQL

1. **Install MySQL and MySQL Workbench**  
   - Install MySQL and MySQL Workbench if they are not already installed.  
   - Use Homebrew, Docker, or download directly from the MySQL website.  

2. **Set Up the Database Schema and Tables**  
   - Use the provided normalization structure to create the database schema and tables.  

3. **Insert Sample Data**  
   - Populate the respective tables with the sample data.  

4. **Execute SQL Queries**  
   - Run SQL queries to solve the listed problems.  

5. **Explore Query Optimization Techniques**  
   - Apply query optimization techniques to improve performance for large datasets.  
   - Techniques include indexing, analyzing query plans, and ensuring proper normalization.




