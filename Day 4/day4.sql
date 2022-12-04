

CREATE TABLE sectionAssignments (
    elf1 text,
    elf2 text,
    id int GENERATED ALWAYS AS IDENTITY
);

WITH readableSections AS (
SELECT id,
       split_part(elf1,'-',1)::int as startElf1,
       split_part(elf2,'-',1)::int as startElf2 ,
       split_part(elf1,'-',2)::int as endElf1,
       split_part(elf2,'-',2)::int as endElf2
FROM sectionAssignments as sA
)
SELECT count(*)
FROM readableSections
WHERE
    -- Elf 1 sections fully contain sections of Elf 2
    startElf1 <= startElf2 AND endElf1 >= endElf2
    OR
    -- Elf 2 sections fully contain sections of Elf 1
    startElf2 <= startElf1 AND endElf2 >= endElf1
    ;

-- Part 2

table sectionAssignments;


WITH readableSections AS (
SELECT id,
       split_part(elf1,'-',1)::int as startElf1,
       split_part(elf2,'-',1)::int as startElf2 ,
       split_part(elf1,'-',2)::int as endElf1,
       split_part(elf2,'-',2)::int as endElf2
FROM sectionAssignments as sA
)
SELECT 1000 - count(*)
FROM readableSections
WHERE
    -- Find section pairings that do not intersect
    startElf1 > endElf2
    OR
    startElf2 > endElf1
    OR
    endElf1 < startElf2
    OR
    endElf2 < startElf1



