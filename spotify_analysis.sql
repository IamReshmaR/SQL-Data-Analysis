USE spotify_db;
-- Advanced SQL Project -- Spotify Data Analysis using SQL--


-- Create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    Artist VARCHAR(255),
    Track VARCHAR(255),
    Album VARCHAR(255),
    Album_type VARCHAR(50),
    Danceability FLOAT,
    Energy FLOAT,
    Loudness FLOAT,
    Speechiness FLOAT,
    Acousticness FLOAT,
    Instrumentalness FLOAT,
    Liveness FLOAT,
    Valence FLOAT,
    Tempo FLOAT,
    Duration_min FLOAT,
    Title VARCHAR(255),
    Channel VARCHAR(255),
    Views FLOAT,
    Likes FLOAT,
    Comments FLOAT,
    Licensed BOOLEAN,
    official_video BOOLEAN,
    Stream FLOAT,
    EnergyLiveness FLOAT,
    most_playedon VARCHAR(50)
);

LOAD DATA LOCAL INFILE '/path/to/cleaned_dataset_no_special_chars.csv'
INTO TABLE spotify
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Artist, Track, Album, Album_type, Danceability, Energy, Loudness, Speechiness,
 Acousticness, Instrumentalness, Liveness, Valence, Tempo, Duration_min, Title, 
 Channel, Views, Likes, Comments, Licensed, official_video, Stream, EnergyLiveness, 
 most_playedon);


SHOW VARIABLES LIKE 'secure_file_priv';

ALTER DATABASE spotify_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE spotify CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
SET NAMES 'utf8mb4';
ALTER TABLE spotify CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
DESCRIBE spotify;

SELECT *
FROM spotify;

-- EDA--
SELECT COUNT(*)
FROM spotify;


-- Create table
DROP TABLE IF EXISTS spotify_new;
CREATE TABLE spotify_new (
    Artist VARCHAR(255),
    Track VARCHAR(255),
    Album VARCHAR(255),
    Album_type VARCHAR(50),
    Danceability FLOAT,
    Energy FLOAT,
    Loudness FLOAT,
    Speechiness FLOAT,
    Acousticness FLOAT,
    Instrumentalness FLOAT,
    Liveness FLOAT,
    Valence FLOAT,
    Tempo FLOAT,
    Duration_min FLOAT,
    Title VARCHAR(255),
    Channel VARCHAR(255),
    Views FLOAT,
    Likes FLOAT,
    Comments FLOAT,
    Licensed VARCHAR(255),
    official_video VARCHAR(255),
    Stream FLOAT,
    EnergyLiveness FLOAT,
    most_playedon VARCHAR(50)
);


SELECT COUNT(*)
FROM spotify_new;

SELECT *
FROM spotify_new;


SELECT COUNT(DISTINCT Artist) 
FROM spotify_new;

SELECT COUNT(DISTINCT Album) 
FROM spotify_new;

SELECT DISTINCT Album_type
FROM spotify_new;

SELECT MAX(Duration_min)
FROM spotify_new;

SELECT MIN(Duration_min)
FROM spotify_new;

SELECT COUNT(DISTINCT Channel)
FROM spotify_new;

SELECT DISTINCT( most_playedon)
FROM spotify_new;

/*
------------------------------------------
-- Data Analysis-- Easy Category--
------------------------------------------

1.Retrieve the names of all tracks that have more than 1 billion streams.
2. List all albums along with their respective artists.
3. Get the total number of comments for tracks where licensed = TRUE.
4. Find all tracks that belong to the album type single.
5. Count the total number of tracks by each artist.
*/


-- tracks that have more than 1 billion streams.
SELECT Track
FROM spotify_new
WHERE Stream > 1000000000;



-- albums along with their respective artists
SELECT Album, Artist
FROM spotify_new;

SELECT DISTINCT Album, Artist
FROM spotify_new;

-- total number of comments for tracks where licensed = TRUE.
SELECT SUM(Comments)
FROM spotify_new
WHERE licensed = "TRUE";


-- all tracks that belong to the album type single.
SELECT Track
FROM spotify_new
WHERE Album_type  = 'single';
-- Total number of tracks by each artist.

SELECT COUNT(Track), Artist
FROM spotify_new
GROUP BY Artist;


/*
------------------------------------------
-- Data Analysis-- Medium Category--
------------------------------------------

1. Calculate the average danceability of tracks in each album.
2. Find the top 5 tracks with the highest energy values.
3. List all tracks along with their views and likes where official_video = TRUE.
4. For each album, calculate the total views of all associated tracks.
5. Retrieve the track names that have been streamed on Spotify more than YouTube.
*/

-- Q1--
SELECT AVG(Danceability) AS avg_danceability, Album
FROM spotify_new
GROUP BY Album
ORDER BY  1 DESC;


-- Q2 --
SELECT  Track , MAX(Energy)
FROM spotify_new
GROUP BY Track
ORDER BY 2 DESC
LIMIT 5;



WITH RankedTracks AS (
    SELECT 
        Track, 
        Energy,
        RANK() OVER (ORDER BY Energy DESC) AS Rnk
    FROM spotify_new
)

SELECT 
    Track, 
    Energy,
    Rnk
FROM RankedTracks
WHERE Rnk <= 5
ORDER BY Rnk, Track;

-- Q3 -- all tracks along with their views and likes where official_video = TRUE.
SELECT Track, SUM(Views) AS total_views, SUM(Likes) AS total_likes
FROM spotify_new
WHERE official_video = "TRUE"
GROUP BY Track
ORDER BY SUM(Views) DESC;

-- Q4 -- For each album, calculate the total views of all associated tracks.

SELECT Album, Track, SUM(Views) AS total_views
FROM spotify_new
GROUP BY Album, Track
ORDER BY 3 DESC;


-- Q5 -- Retrieve the track names that have been streamed on Spotify more than YouTube.


SELECT *
FROM(
SELECT Track, 
       COALESCE(SUM(CASE WHEN most_playedon = 'Youtube' THEN Stream END),0) AS streamed_on_YT,
       COALESCE(SUM(CASE WHEN most_playedon = 'Spotify' THEN Stream END),0) AS streamed_on_Spotify
FROM spotify_new
GROUP BY 1) AS t1
WHERE streamed_on_Spotify > streamed_on_YT AND streamed_on_YT <> 0 ;

/*
------------------------------------------
-- Data Analysis-- Advanced Category--
------------------------------------------

1. Find the top 3 most-viewed tracks for each artist using window functions.
2.Write a query to find tracks where the liveness score is above the average.
3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

*/


-- Q1 --  top 3 most-viewed tracks for each artist using window functions
WITH CTE AS (SELECT Artist, Track, Views,
       DENSE_RANK() OVER(PARTITION BY Artist ORDER BY Views DESC) AS rnk
FROM spotify_new)

SELECT * 
FROM CTE
WHERE rnk <= 3;

WITH CTE AS (SELECT Artist, Track, SUM(Views) AS total_views,
       DENSE_RANK() OVER(PARTITION BY Artist ORDER BY SUM(Views) DESC) AS rnk
FROM spotify_new
GROUP BY Artist,Track
ORDER BY Artist,total_views)

SELECT * 
FROM CTE
WHERE rnk <= 3;

-- Q2 -- To find tracks where the liveness score is above the average.

WITH CTE AS (SELECT AVG(Liveness) AS avg_liveness
FROM spotify_new)

SELECT Track, liveness
FROM spotify_new
WHERE  Liveness >  (SELECT avg_liveness FROM CTE );
    
-- Q3 -- calculate the difference between the highest and lowest energy values for tracks in each album.
WITH cte AS (
             SELECT Album,
                    MAX(Energy) AS highest_energy,
                    MIN(Energy) AS lowest_energy
			 FROM spotify_new
             GROUP BY Album)
SELECT Album,
       highest_energy - lowest_energy AS energy_diff
FROM cte
ORDER BY energy_diff DESC;


-- Q4 -- Find tracks where the energy-to-liveness ratio is greater than 1.2.

SELECT Track, energy, liveness, energy / liveness AS energy_liveness_ratio
FROM spotify_new
WHERE energy / liveness > 1.2
ORDER BY energy_liveness_ratio;

-- Q5 -- Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

SELECT 
    Track,
    Views,
    Likes,
    SUM(Likes) OVER (
        ORDER BY Views DESC
    ) AS CumulativeLikes
FROM spotify_new;





-- Query Optimization -- 
EXPLAIN ANALYZE 
SELECT artist, track, views
FROM spotify_new
WHERE artist = 'Gorillaz' AND most_playedon = 'Youtube'
ORDER BY stream DESC 
LIMIT 25;

-- AFTER INDEXING --

CREATE INDEX idx_artist ON spotify_new (artist);

EXPLAIN ANALYZE 
SELECT artist, track, views
FROM spotify_new
WHERE artist = 'Gorillaz' AND most_playedon = 'Youtube'
ORDER BY stream DESC 
LIMIT 25;