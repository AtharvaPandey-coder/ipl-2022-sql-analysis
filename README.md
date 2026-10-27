# IPL 2022 SQL Analysis

Answering business questions about the 2022 IPL season using MySQL.

## Dataset
IPL 2022 Match Dataset by vora1011 on Kaggle (search the name on Kaggle).
- `matches`: 74 rows, one row per match
- `deliveries`: about 17,000 rows, one row per ball

The two tables join on `ID` (`deliveries.ID = matches.ID`).

## How the data was loaded
- **matches:** loaded with generated `INSERT` statements, one per match, run in MySQL Workbench. The Table Data Import Wizard crashed while reading this file, so I switched to SQL inserts. Example of the pattern:

```sql
INSERT INTO matches (ID, City, date_match, Season, ...)
VALUES ('1312200', 'Ahmedabad', '2022-05-29', '2022', ...);
```

- **deliveries:** loaded with the MySQL Workbench Table Data Import Wizard.
- Empty values in the source files are stored as the text `NA`, so queries use `<> 'NA'` instead of `IS NULL`.

## Questions solved so far

| # | Question | Insight |
|---|----------|---------|
| 1 | How many matches were played in each city? | Mumbai hosted 48 of the 74 matches (65%), followed by Pune (13) and Navi Mumbai (9). Kolkata and Ahmedabad hosted 2 each, which were the playoff games. |
| 2 | Which 5 venues hosted the most matches? | Four venues hosted 70 of 74 matches: Wankhede Stadium (21), Dr DY Patil Sports Academy (20), Brabourne Stadium (16) and the Maharashtra Cricket Association Stadium, Pune (13). Eden Gardens and Narendra Modi Stadium hosted 2 each. |
| 3 | Which team won the most matches? | Gujarat Titans won the most matches (12), ahead of Rajasthan Royals (10). Lucknow Super Giants and Royal Challengers Bangalore tied on 9. |
| 4 | Who won the most Player of the Match awards? | Kuldeep Yadav won the most awards (4), followed by JC Buttler (3). Several players tied on 2 awards, and only 5 rows are shown.
| 5 | Which 10 batters scored the most runs? | (add insight) |
| 6 | Which 10 bowlers took the most wickets? | (add insight) |
| 7 | How many matches were won by runs vs wickets? | Balanced season: 37 wins by runs and 37 by wickets |
| 8 | What percentage of matches were won by the toss winner? | Toss winners won 36 of 74 matches (48.65%), so winning the toss gave no real edge in 2022. |
| 9 | After winning the toss, do teams bat or field, and which choice won more often? | Teams chose to field first in 59 of 74 matches (80%). Toss winners won 49.15% of the time after fielding (29 of 59) and 46.67% after batting (7 of 15), so neither choice showed a clear edge. |
| 10 | At which venues did chasing teams win more often than teams batting first? | Only two venues favoured chasing teams. At Wankhede Stadium they won 13 of 21 matches (62%), while Narendra Modi Stadium showed 2 of 2 but on too small a sample to read much into. |
| 11 | Which batters have the best strike rate (minimum 100 balls faced)? | KD Karthik had the best strike rate (183.33 off 180 balls), narrowly ahead of LS Livingstone (182.08), who also scored the most runs of the top ten (437). |
| 12 | Which team scored the most total runs, and what is each team's average runs per match? | Rajasthan Royals scored the most runs in 2022 (2943 in 17 matches) and also had the highest average (173.12 per match). Lucknow Super Giants ranked below Gujarat and Bangalore on total runs but ahead of both on average (169.87), because they played fewer matches. |
| 13 | What percentage of each team's runs came from fours and sixes? | About 62% of runs came from fours and sixes for the top four teams, led by Kolkata Knight Riders (62.35%). Chennai Super Kings were lower at 59.18%. |
## SQL concepts practiced
`GROUP BY`, `COUNT`, `SUM`, `COUNT(DISTINCT)`, `CASE WHEN`, `ORDER BY`, `LIMIT`,percentage calculation.
Coming next: JOINs, CTEs and window functions.

## Notes
- Q5 and Q6 use `COUNT(DISTINCT ID)` for matches, because `deliveries` has one row per ball.
- Q6 counts only dismissals credited to the bowler (bowled, caught, caught and bowled, lbw, stumped, hit wicket). Run-outs and retirements are excluded.
- Q8 and Q9 use `100.0 * SUM(CASE WHEN TossWinner = WinningTeam THEN 1 ELSE 0 END) / COUNT(*)` for the percentage. The `100.0` stops SQL from rounding down to a whole number.
- Q11 excludes wides from balls faced, because a wide is not a ball the batter faces. A minimum of 100 balls faced (`HAVING`) keeps tiny samples from topping the list.
- Q12 divides total runs by `COUNT(DISTINCT ID)` to get the average per match, because teams played different numbers of matches (14 to 17, depending on playoffs), so total runs alone is not a fair comparison.
- Q13 counts boundary runs from `batsman_run` (fours and sixes) as a share of `total_run`. The share is slightly understated because total runs include extras. The percentage repeats the full `SUM` expressions, because an alias cannot be used inside the same `SELECT`.
## How to run
1. Run `schema.sql` to create the database and the two tables.
2. Load the Kaggle data into `matches` and `deliveries`.
3. Run `queries.sql`.
