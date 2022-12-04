-- Day 1: Part 1
--DROP TABLE IF EXISTS calories ;

CREATE TABLE calories (
    index int GENERATED ALWAYS AS IDENTITY,
    calories int
);

WITH findEmpty as (
SELECT c.index,
       Case
           WHEN c.calories IS NOT NULL
           THEN 0
           ELSE 1
       END
           as isnextelf,
       c.calories
FROM calories as c),
divideElfs as (
SELECT  index,
        sum(isnextelf) OVER filter as elf,
        calories
FROM findEmpty as fE
WINDOW filter as (ORDER BY index)
)
SELECT elf,sum(calories) as calories
FROM divideElfs as dE
GROUP BY elf
ORDER BY calories DESC
LIMIT 1;


-- Part 2

WITH findEmpty as (
SELECT c.index,
       Case
           WHEN c.calories IS NOT NULL
           THEN 0
           ELSE 1
       END
           as isnextelf,
       c.calories
FROM calories as c),
divideElfs as (
SELECT  index,
        sum(isnextelf) OVER filter as elf,
        calories
FROM findEmpty as fE
WINDOW filter as (ORDER BY index)
),
topthree as (
SELECT elf,sum(calories) as calories
FROM divideElfs as dE
GROUP BY elf
ORDER BY calories DESC
LIMIT 3)
SELECT sum(calories)
FROM topthree as tt;
