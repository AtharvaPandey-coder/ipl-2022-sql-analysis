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
| 1 | How many matches were played in each city? | (add insight) |
| 2 | Which 5 venues hosted the most matches? | (add insight) |
| 3 | Which team won the most matches? | (add insight) |
| 4 | Who won the most Player of the Match awards? | (add insight) |
| 5 | Which 10 batters scored the most runs? | (add insight) |
| 6 | Which 10 bowlers took the most wickets? | (add insight) |
| 7 | How many matches were won by runs vs wickets? | Balanced season: 37 wins by runs and 37 by wickets |
| 8 | What percentage of matches were won by the toss winner? | Toss winners won 36 of 74 matches (48.65%), so winning the toss gave no real edge in 2022. |
## SQL concepts practiced
`GROUP BY`, `COUNT`, `SUM`, `COUNT(DISTINCT)`, `CASE WHEN`, `ORDER BY`, `LIMIT`,percentage calculation.
Coming next: JOINs, CTEs and window functions.

## Notes
- Q5 and Q6 use `COUNT(DISTINCT ID)` for matches, because `deliveries` has one row per ball.
- Q6 counts only dismissals credited to the bowler (bowled, caught, caught and bowled, lbw, stumped, hit wicket). Run-outs and retirements are excluded.
- Q8 uses `100.0 * SUM(CASE WHEN TossWinner = WinningTeam THEN 1 ELSE 0 END) / COUNT(*)` to get the percentage. The `100.0` stops SQL from rounding down to a whole number.
## How to run
1. Run `schema.sql` to create the database and the two tables.
2. Load the Kaggle data into `matches` and `deliveries`.
3. Run `queries.sql`.
