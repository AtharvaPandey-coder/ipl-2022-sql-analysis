USE ipl;

-- =========================================================
-- HARD QUESTION 1:
-- Show the total runs scored at each venue and the average
-- runs per match at each venue.
-- =========================================================

SELECT
    matches.Venue,
    SUM(delieveries.total_run) AS total_runs,
    COUNT(DISTINCT delieveries.ID) AS matches,
    ROUND(
        SUM(delieveries.total_run) / COUNT(DISTINCT delieveries.ID),
        2
    ) AS avg_runs_per_match
FROM matches
JOIN delieveries
    ON matches.ID = delieveries.ID
GROUP BY matches.Venue
HAVING COUNT(DISTINCT delieveries.ID) >= 10
ORDER BY avg_runs_per_match DESC;


-- =========================================================
-- HARD QUESTION 2:
-- Who are the top 3 run-scoring batters for each team in IPL 2022?
-- =========================================================

WITH batsman_runs AS (
    SELECT
        delieveries.batter,
        delieveries.BattingTeam,
        SUM(delieveries.batsman_run) AS runs
    FROM delieveries
    JOIN matches
        ON delieveries.ID = matches.ID
    WHERE matches.Season = '2022'
    GROUP BY delieveries.batter, delieveries.BattingTeam
),
ranked AS (
    SELECT
        batter,
        BattingTeam,
        runs,
        RANK() OVER (
            PARTITION BY BattingTeam
            ORDER BY runs DESC
        ) AS rnk
    FROM batsman_runs
)
SELECT
    batter,
    BattingTeam,
    runs,
    rnk
FROM ranked
WHERE rnk <= 3
ORDER BY BattingTeam, rnk;


-- =========================================================
-- HARD QUESTION 3:
-- In each match, find the top run scorer.
-- How often was that player also Player of the Match?
-- =========================================================

WITH batter_match_runs AS (
    SELECT
        ID,
        batter,
        SUM(batsman_run) AS runs
    FROM delieveries
    GROUP BY ID, batter
),
ranked AS (
    SELECT
        ID,
        batter,
        runs,
        RANK() OVER (
            PARTITION BY ID
            ORDER BY runs DESC
        ) AS rnk
    FROM batter_match_runs
),
top_scorrers AS (
    SELECT
        ID,
        batter
    FROM ranked
    WHERE rnk = 1
)
SELECT
    COUNT(DISTINCT top_scorrers.ID) AS matches,
    COUNT(DISTINCT CASE
        WHEN top_scorrers.batter = matches.Player_of_Match
        THEN top_scorrers.ID
    END) AS top_scorer_was_pom,
    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN top_scorrers.batter = matches.Player_of_Match
            THEN top_scorrers.ID
        END) / COUNT(DISTINCT top_scorrers.ID),
        2
    ) AS pct
FROM top_scorrers
JOIN matches
    ON top_scorrers.ID = matches.ID;
