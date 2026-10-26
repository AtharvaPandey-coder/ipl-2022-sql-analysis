CREATE DATABASE IF NOT EXISTS ipl;
USE ipl;

CREATE TABLE matches (
    ID               INT PRIMARY KEY,
    City             VARCHAR(50),
    date_match       VARCHAR(20),
    Season           INT,
    MatchNumber      VARCHAR(20),
    Team1            VARCHAR(60),
    Team2            VARCHAR(60),
    Venue            VARCHAR(120),
    TossWinner       VARCHAR(60),
    TossDecision     VARCHAR(10),
    SuperOver        VARCHAR(5),
    WinningTeam      VARCHAR(60),
    WonBy            VARCHAR(20),
    Margin           VARCHAR(10),
    method           VARCHAR(20),
    Player_of_Match  VARCHAR(60),
    Team1Players     TEXT,
    Team2Players     TEXT,
    Umpire1          VARCHAR(60),
    Umpire2          VARCHAR(60)
);

CREATE TABLE deliveries (
    ID                INT,
    innings           INT,
    overs             INT,
    ballnumber        INT,
    batter            VARCHAR(60),
    bowler            VARCHAR(60),
    non_striker       VARCHAR(60),
    extra_type        VARCHAR(30),
    batsman_run       INT,
    extras_run        INT,
    total_run         INT,
    non_boundary      INT,
    isWicketDelivery  INT,
    player_out        VARCHAR(60),
    kind              VARCHAR(40),
    fielders_involved VARCHAR(200),
    BattingTeam       VARCHAR(60),
    INDEX idx_id (ID)
);