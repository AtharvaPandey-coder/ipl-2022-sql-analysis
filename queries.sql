USE ipl;

-- Q1: How many matches were played in each city?
SELECT City, COUNT(ID) AS matches
FROM matches
GROUP BY City
ORDER BY matches DESC;

-- Q2: Which 5 venues hosted the most matches?
SELECT Venue, COUNT(ID) AS matches
FROM matches
GROUP BY Venue
ORDER BY matches DESC
LIMIT 5;

-- Q3: Which team won the most matches?
SELECT WinningTeam AS team, COUNT(ID) AS matches_won
FROM matches
WHERE WinningTeam <> 'NA'
GROUP BY WinningTeam
ORDER BY matches_won DESC;

-- Q4: Who won the most Player of the Match awards? (top 5)
SELECT Player_of_Match AS player, COUNT(ID) AS awards
FROM matches
GROUP BY Player_of_Match
ORDER BY awards DESC
LIMIT 5;

-- Q5: Which 10 batters scored the most runs?
-- COUNT(DISTINCT ID) counts matches, because deliveries has one row per ball
SELECT batter,
       SUM(batsman_run) AS runs,
       COUNT(DISTINCT ID) AS matches
FROM deliveries
GROUP BY batter
ORDER BY runs DESC
LIMIT 10;

-- Q6: Which 10 bowlers took the most wickets?
-- Only dismissals credited to the bowler count; run-outs and retirements are excluded
SELECT bowler,
       SUM(CASE WHEN kind IN ('caught', 'caught and bowled', 'bowled', 'stumped', 'lbw', 'hit wicket')
                THEN 1 ELSE 0 END) AS wickets,
       COUNT(DISTINCT ID) AS matches
FROM deliveries
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 10;

-- Q7: How many matches were won by runs and how many by wickets?
SELECT WonBy, COUNT(ID) AS matches
FROM matches
GROUP BY WonBy;
-- Result: 37 by wickets and 37 by runs