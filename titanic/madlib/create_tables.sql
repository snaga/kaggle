DROP TABLE titanic_train;
DROP TABLE titanic_test;

CREATE TABLE titanic_train (
  PassengerId INTEGER,
  Survived INTEGER,
  Pclass INTEGER,
  Name TEXT,
  Sex TEXT,
  Age DOUBLE PRECISION,
  SibSp INTEGER,
  Parch INTEGER,
  Ticket TEXT,
  Fare DOUBLE PRECISION,
  Cabin TEXT,
  Embarked TEXT
);

\d titanic_train

\COPY titanic_train FROM 'train.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER true);

CREATE TABLE titanic_test (
  PassengerId INTEGER,
  Pclass INTEGER,
  Name TEXT,
  Sex TEXT,
  Age DOUBLE PRECISION,
  SibSp INTEGER,
  Parch INTEGER,
  Ticket TEXT,
  Fare DOUBLE PRECISION,
  Cabin TEXT,
  Embarked TEXT
);

\d titanic_test

\COPY titanic_test FROM 'test.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER true);


-- Age: 中央値で埋める
-- Embarked: もっとも多い 'S' で埋める
-- Cabin: 今回は使わないので無視
begin;
select count(*) from titanic_train where age is null;
with t as (
  select age,count(*) from titanic_train where age is not null group by age order by 2 desc
),
median_age as (
  select age from t limit 1
)
update titanic_train
   set age = (select age from median_age)
 where age is null;
select count(*) from titanic_train where age is null;

select count(*) from titanic_train where embarked is null;
update titanic_train
   set embarked = 'S'
 where embarked is null;
select count(*) from titanic_train where embarked is null;
commit;

-- Age: 中央値で埋める
-- Fare: 中央値で埋める
-- Cabin: 今回は使わないので無視
begin;
select count(*) from titanic_test where age is null;
with t as (
  select age,count(*) from titanic_test where age is not null group by age order by 2 desc
),
median_age as (
  select age from t limit 1
)
update titanic_test
   set age = (select age from median_age)
 where age is null;
select count(*) from titanic_test where age is null;

select count(*) from titanic_test where fare is null;
with t as (
  select fare,count(*) from titanic_test where fare is not null group by fare order by 2 desc
),
median_fare as (
  select fare from t limit 1
)
update titanic_test
   set fare = (select fare from median_fare)
 where fare is null;
select count(*) from titanic_test where fare is null;
commit;

-- Sex: 男性を0、女性を1に変換
-- Embarked: 出航地 Cherbourgを0、Queenstownを1、Southamptonを2に変換
DROP TABLE titanic_train_clean;

CREATE TABLE titanic_train_clean AS
SELECT
  PassengerId,
  Survived,
  Pclass,
  Name,
  CASE Sex
    WHEN 'male' THEN 0
    WHEN 'female' THEN 1
    ELSE NULL
  END Sex,
  Age,
  SibSp,
  Parch,
  Ticket,
  Fare,
  Cabin,
  CASE Embarked
    WHEN 'S' THEN 0
    WHEN 'C' THEN 1
    WHEN 'Q' THEN 2
  END Embarked
FROM
  titanic_train;

\d titanic_train_clean

SELECT
  *
FROM
  titanic_train
ORDER BY
  PassengerId
LIMIT 10;

SELECT
  *
FROM
  titanic_train_clean
ORDER BY
  PassengerId
LIMIT 10;
