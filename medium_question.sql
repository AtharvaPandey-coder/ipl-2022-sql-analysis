-- =====================================================
-- IPL 2022 SQL Analysis: Medium questions
-- Q12 (bowler economy rate) skipped: same pattern as Q11
-- =====================================================
USE ipl;

-- -----------------------------------------------------
-- Q8: What percentage of matches were won by the toss winner?
-- -----------------------------------------------------
SELECT SUM(CASE WHEN TossWinner = WinningTeam THEN 1 ELSE 0 END) AS toss_winner_won,
       COUNT(*) AS total_matches,
       ROUND(100.0 * SUM(CASE WHEN TossWinner = WinningTeam THEN 1 ELSE 0 END) / COUNT(*), 2) AS win_pct
FROM matches;
-- Result: toss winners won 36 of 74 matches (48.65%)
-- Insight: winning the toss gave no real edge in 2022
-- Pattern: percentage = 100.0 * SUM(CASE WHEN condition THEN 1 ELSE 0 END) / COUNT(*)

-- -----------------------------------------------------
-- Q9: After winning the toss, do teams bat or field,
--     and which choice won more often?
-- -----------------------------------------------------
SELECT TossDecision,
       COUNT(*) AS times_chosen,
       SUM(CASE WHEN TossWinner = WinningTeam THEN 1 ELSE 0 END) AS toss_winner_won,
       ROUND(100.0 * SUM(CASE WHEN TossWinner = WinningTeam THEN 1 ELSE 0 END) / COUNT(*), 2) AS win_pct
FROM matches
GROUP BY TossDecision;
-- Result: field 59 times (29 wins, 49.15%); bat 15 times (7 wins, 46.67%)
-- Insight: teams chose to field in 80% of matches; neither choice showed a clear edge
-- Pattern: same CASE WHEN percentage, now with GROUP BY to compare two groups

-- -----------------------------------------------------
-- Q10: At which venues did chasing teams win more often
--      than teams batting first?
-- -----------------------------------------------------
SELECT Venue,
       SUM(CASE WHEN WonBy = 'Wickets' THEN 1 ELSE 0 END) AS chasing_wins,
       SUM(CASE WHEN WonBy = 'Runs' THEN 1 ELSE 0 END) AS batting_first_wins,
       COUNT(*) AS total_matches
FROM matches
GROUP BY Venue
HAVING chasing_wins > batting_first_wins
ORDER BY chasing_wins DESC;
-- Result: Wankhede Stadium, Mumbai 13 vs 8 (21 matches); Narendra Modi Stadium 2 vs 0 (2 matches)
-- Insight: Wankhede is the real finding; Narendra Modi has too few matches to read much into
-- Pattern: WHERE filters rows before grouping; HAVING filters groups after SUM/COUNT

-- -----------------------------------------------------
-- Q11: Which batters have the best strike rate
--      (minimum 100 balls faced)?
-- -----------------------------------------------------
SELECT batter,
       SUM(batsman_run) AS runs,
       SUM(CASE WHEN extra_type <> 'wides' THEN 1 ELSE 0 END) AS balls_faced,
       ROUND(100.0 * SUM(batsman_run)
             / SUM(CASE WHEN extra_type <> 'wides' THEN 1 ELSE 0 END), 2) AS strike_rate
FROM deliveries
GROUP BY batter
HAVING balls_faced >= 100
ORDER BY strike_rate DESC
LIMIT 10;
-- Result: KD Karthik 183.33 (330 runs off 180 balls), LS Livingstone 182.08, AD Russell 174.48
-- Insight: wides are not balls faced; HAVING keeps tiny samples from topping the list
-- Pattern: rate = 100.0 * SUM(numerator) / SUM(CASE WHEN condition THEN 1 ELSE 0 END)

-- -----------------------------------------------------
-- Q13: Which team scored the most total runs, and what is
--      each team's average runs per match?
-- -----------------------------------------------------
SELECT BattingTeam,
       SUM(total_run) AS total_runs,
       COUNT(DISTINCT ID) AS matches,
       ROUND(SUM(total_run) / COUNT(DISTINCT ID), 2) AS avg_runs_per_match
FROM deliveries
GROUP BY BattingTeam
ORDER BY total_runs DESC;
-- Result: Rajasthan Royals 2943 runs in 17 matches (avg 173.12); Gujarat Titans 166.44;
--         Royal Challengers Bangalore 164.50; Lucknow Super Giants 169.87; Punjab Kings 167.36
-- Insight: compare averages, not totals, because teams played 14 to 17 matches
-- Pattern: average per group = SUM(value) / COUNT(DISTINCT id)

-- -----------------------------------------------------
-- Q14: What percentage of each team's runs came from
--      fours and sixes?
-- -----------------------------------------------------
SELECT BattingTeam,
       SUM(total_run) AS total_runs,
       SUM(CASE WHEN batsman_run IN (4, 6) THEN batsman_run ELSE 0 END) AS boundary_runs,
       ROUND(100.0 * SUM(CASE WHEN batsman_run IN (4, 6) THEN batsman_run ELSE 0 END)
             / SUM(total_run), 2) AS boundary_pct
FROM deliveries
GROUP BY BattingTeam
ORDER BY boundary_pct DESC;
-- Result (top rows): Kolkata Knight Riders 62.35%, Punjab Kings 62.31%,
--                    Delhi Capitals 62.20%, Rajasthan Royals 62.05%, Chennai Super Kings 59.18%
-- Insight: about 62% of runs came from boundaries for the top teams
-- Pattern: repeat the full SUM expressions in the percentage; never use aliases inside the same SELECT