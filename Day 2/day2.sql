-- Day 2 Part 1

CREATE TYPE OpponentRPS AS ENUM (
    'A',
    'B',
    'C'
    );

CREATE TYPE ProtagonistRPS AS ENUM (
    'X',
    'Y',
    'Z'
    );

CREATE FUNCTION evalRPS (opp OpponentRPS, prot ProtagonistRPS) RETURNS int AS
    $$
    SELECT
        CASE
        WHEN opp = 'A' and prot = 'X' THEN 1+3
        WHEN opp = 'A' and prot = 'Y' THEN 2+6
        WHEN opp = 'A' and prot = 'Z' THEN 3+0
        WHEN opp = 'B' and prot = 'X' THEN 1+0
        WHEN opp = 'B' and prot = 'Y' THEN 2+3
        WHEN opp = 'B' and prot = 'Z' THEN 3+6
        WHEN opp = 'C' and prot = 'X' THEN 1+6
        WHEN opp = 'C' and prot = 'Y' THEN 2+0
        WHEN opp = 'C' and prot = 'Z' THEN 3+3
    END
    $$ LANGUAGE sql IMMUTABLE ;

CREATE TABLE RPSStrategy (
    opp OpponentRPS,
    prot ProtagonistRPS
);

SELECT sum(evalRPS(opp,prot)) As result
FROM rpsstrategy;

-- Part 2

CREATE FUNCTION planResult (opp OpponentRPS, prot ProtagonistRPS) RETURNS int AS
    $$
    SELECT
        CASE
        WHEN opp = 'A' and prot = 'X' THEN 3+0
        WHEN opp = 'A' and prot = 'Y' THEN 1+3
        WHEN opp = 'A' and prot = 'Z' THEN 2+6
        WHEN opp = 'B' and prot = 'X' THEN 1+0
        WHEN opp = 'B' and prot = 'Y' THEN 2+3
        WHEN opp = 'B' and prot = 'Z' THEN 3+6
        WHEN opp = 'C' and prot = 'X' THEN 2+0
        WHEN opp = 'C' and prot = 'Y' THEN 3+3
        WHEN opp = 'C' and prot = 'Z' THEN 1+6
    END
    $$ LANGUAGE sql IMMUTABLE ;

SELECT sum(planResult(opp,prot)) As result
FROM rpsstrategy;