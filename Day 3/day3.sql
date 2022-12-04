DROP TABLE IF EXISTS backpacks;

-- Part 1

CREATE  TABLE  backpacks (
  content text,
  elf int generated always as IDENTITY
);

CREATE FUNCTION mapLetters (inpLetter varchar(1)) RETURNS int AS
    $$
    --Create the Priority representation
    WITH rosetta AS (
        SELECT *
        FROM unnest(string_to_array('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'::text,NULL)) WITH ORDINALITY AS alphabet(letter,val)
    )
    SELECT val
    FROM rosetta as r
    WHERE r.letter = inpLetter
    $$ LANGUAGE sql IMMUTABLE ;

WITH splitArray AS (
-- divide string and convert it to array
SELECT string_to_array("left"(content,length(content)/2),NULL) as left,
       string_to_array("right"(content,length(content)/2),NULL) as right
FROM backpacks as b),

findDuplicates AS (
SELECT array_agg(intersct) as duplicates
FROM splitArray as sA, Lateral (
    --With lateral we can do one row at a time
    --Intersect does provide the duplicated Bag Contents
    SELECT leftSide.leftSide
    FROM unnest(sA.left) AS leftSide(leftSide)
    INTERSECT
    SELECT rightSide.rightSide
    FROM unnest(sA.right) AS rightSide(rightSide)
    ) AS intrsct(intersct))
-- Sum up the aggregated missing letters
SELECT sum(mapLetters(letter))
FROM findDuplicates,unnest(findDuplicates.duplicates) AS dublicates(letter);

-- Part 2
WITH groupElfs AS (
SELECT ceil(elf::float/3) as elfgroup, array_agg(content) as contents
FROM backpacks
GROUP BY ceil(elf::float/3)),
splitElfgroup as (
SELECT elfgroup,
       --Bring it to a similar form like in part 1
       string_to_array(contents[1],NULL) as firstElf,
       string_to_array(contents[2],NULL) as secondElf,
       string_to_array(contents[3],NULL) as thirdElf
FROM groupElfs as gE),
badges AS (
SELECT array_agg(intersct) as badges
FROM splitElfgroup as sE, Lateral (
    SELECT firstElf.firstElf
    FROM unnest(firstElf) AS firstElf(firstElf)
    INTERSECT
    SELECT secondElf.secondElf
    FROM unnest(secondElf) AS secondElf(secondElf)
    INTERSECT
    SELECT thirdElf.thirdElf
    FROM unnest(thirdElf) AS thirdElf(thirdElf)
    ) AS intrsct(intersct))
SELECT sum(mapLetters(letter))
FROM badges,unnest(badges.badges) AS badge(letter);

