#sql #postgres

Source:  
[Learn PostgreSQL Tutorial - Full Course for Beginners](https://www.youtube.com/watch?v=qw--VYLpxG4)  
  
## Intro  
  
Database: place you can store, manipulate, and retrieve data  
Postgres: Database engine; the database  
SQL: Structured Query Language  
* allows interactions with databases  
* manage data held in *relational* database  
  
Data is stored in tables made of columns and rows:  
* columns headers attributes  
* rows are entries  
  
Relational DB: multiple tables have relationships; corresponding columns.  
PostgreSQL: open source object-relational database management system  
  
**`sudo -u postgres psql` is the command that helps me connect to psql as user postgres on AWS!**  
  
## psql general commands  
`psql`:  
* `help` for help with SQL commands  
* `\?` for help with psql commands  
* `\password` set new password for user  
* `\l` to list databases  
* `\d` displays tables, sequences, etc.  
* `\x` expanded display of tables, sequences, etc.  
* `\df` display functions. Can pattern match.  
* `\dt` display just tables  
* `\d "table"` to display "table"  
* `\i path/to/file.sql` execute commands from file  
* `\q` to quit  
  
```sql
show all; -- Show all run-time paramters  
```
  
## `CREATE DATABASE`  
(Prefer uppercase for SQL commands)  
```sql
CREATE DATABASE "database";
show data_directory; -- /var/lib/pgsql/data  
```
  
This configuration file is important for managing how connections are made to the database. I set all connection methods to `password` (probably overkill) to get the application working.  
```sql
show hba_conf;
```
  
## `\connect` to Database  
`psql --help` is useful  
`psql -h host -U username database`, ex: `psql -h localhost -U amigoscode test`  
or in psql: `\c database`  
`\c "database"` allows easy switching between databases!  
  
## Data Types  
[Documentation](https://www.postgresql.org/docs/9.5/datatype.html)  
  
## `CREATE TABLE`
  
```sql
CREATE TABLE table_name (  
    <Column name + data type + constraints if any>  
)  
```
  
```sql
CREATE TABLE "person" (  
    id int,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(6),
    date_of_birth TIMESTAMP,
);
```
  
Create table with fields `NOT NULL`-able  
```sql
CREATE TABLE "person" (  
    id BIGSERIAL NOT NULL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(7) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(150)  
);
```
  
## `INSERT INTO` table `VALUES` of new record
  
You don't need to specify the ID column as `BIGSERIAL` autoincrements  
  
```sql
INSERT INTO "person" (  
    first_name,
    last_name,
    gender,
    date_of_birth  
) VALUES ('Anne', 'Smith', 'FEMALE', DATE '1988-01-09');
```
  
```sql
INSERT INTO "person" (  
    first_name,
    last_name,
    gender,
    date_of_birth,
    email  
) VALUES ('Jake', 'Jones', 'MALE', DATE '1990-01-10', 'jake@gmail.com');
```
  
## Select  
  
Display all attributes for all entries from a table   
```sql
SELECT * FROM "person";
```
  
Display select attributes for all entries from a table  
```sql
SELECT first_name, last_name FROM "person";
```
  
## `ORDER BY`
  
Default: sort ascending order  
`ASC` ascending  
`DESC` descending  
  
```sql
SELECT * FROM "person" ORDER BY country_of_birth; 
```
Entries sorted by country ascending order  
  
Sort descending order  
```sql
SELECT * FROM "person" ORDER BY country_of_birth DESC; 
```
  
Sort descending order by multiple columns (NOT RECOMMENDED)  
```sql
SELECT * FROM "person" ORDER BY id, email DESC; 
```
  
## `DISTINCT`: get unique values  
  
```sql
SELECT DISTINCT FROM "person" ORDER BY country_of_birth; 
```
  
## `WHERE`: filter data based on conditions  
  
Returns 0 rows if nothing matches  
  
```sql
SELECT * FROM "person" WHERE gender = 'Female'; 
```
  
```sql
SELECT * FROM "person" WHERE gender = 'Female' AND country_of_birth = 'Poland';
```
  
```sql
SELECT * FROM "person"   
WHERE gender = 'Female'  
AND (country_of_birth = 'Poland' OR country_of_birth = 'China'); 
```
  
## Comparison operators  
  
See list of operators in Documentation  
  
This returns 1 row of `t` true under a column `?column?`  
```sql
SELECT 1 = 1;
```
  
## `LIMIT` and `OFFSET` and `FETCH`  
  
Only return first 10 rows  
```sql
SELECT * FROM "person" LIMIT 10; 
```
  
Returns rows 6 through 10  
```sql
SELECT * FROM "person" OFFSET 5 LIMIT 5; 
```
  
Same thing as above but works for more flavors of SQL  
```sql
SELECT * FROM "person" OFFSET 5 FETCH FIRST 5 ROW ONLY; 
```
  
## `IN`: makes conditional queries more succinct
  
```sql
SELECT * FROM "person"   
WHERE gender = 'Female'   
AND country_of_birth = 'China'  
OR country_of_birth = 'France'  
OR country_of_birth = 'Brazil'; 
```
  
```sql
SELECT * FROM "person"   
WHERE gender = 'Female'   
AND country_of_birth IN ('China', 'Brazil', 'France');
```
  
## `BETWEEN`
  
```sql
SELECT * FROM "person" WHERE date_of_birth BETWEEN DATE '2000-01-01' AND '2015-01-01';
```
  
## `LIKE` and `ILIKE`  
  
`%` is the wild card for matching 1 or more characters  
  
```sql
SELECT * FROM "person"   
WHERE email LIKE '%.com';
```
  
`_` is the wild card for matching 1 character  
  
Matches email where name is 8 characters  
```sql
SELECT * FROM "person"
WHERE email LIKE '________@%';
```
  
Ignore case  
```sql
SELECT * FROM "person"
WHERE country_of_birth ILIKE 'p%';
```
## `GROUP BY` and `GROUP BY HAVING`  
  
Can find aggregate functions (like `COUNT()`) on the Documentation  
  
```sql
SELECT country_of_birth, COUNT(*) FROM "person"
GROUP BY country_of_birth
ORDER BY country_of_birth;
```
  
```sql
SELECT country_of_birth, COUNT(*) FROM "person"
GROUP BY country_of_birth HAVING COUNT(*) > 5
ORDER BY country_of_birth;
```
  
## `MIN()`, `MAX()`, and `AVG()`  
  
```sql
SELECT MAX(price) FROM car;
```
  
```sql
SELECT MIN(price) FROM car;
```
  
```sql
SELECT ROUND(AVG(price)) FROM car;
```
  
```sql
SELECT make, model, MIN(price) FROM car GROUP BY make, model;
```
  
## `SUM()`
  
```sql
SELECT SUM(price) FROM car;
```
  
```sql
SELECT make, SUM(price) FROM car GROUP BY make;
```
  
## Basic arithmetic operators
  
See documentation for full list.
  
Returns result `12` in 1 row in column `?column?`.
```sql
SELECT 10 + 2;
```
  
Returns `100`  
```sql
SELECT 10 ^ 2;
```
  
Returns factorial `5!` which is `120`  
```sql
SELECT 5!;
```
  
## `ROUND()`
  
```sql
SELECT id, make, model, price, ROUND(price * 0.10, 2) FROM car;
```
  
## `AS`

By default, postgres will name new columns after functions applied or `?column?`  
  
```sql
SELECT id, make, model, price, ROUND(price * 0.10, 2) AS value_ten_percent FROM car;
```
  
## `COALESCE()`
  
If the first argument is not present, try the next one, and so on. Good for handling `NULL` values.  
```sql
SELECT COALESCE(1) AS number;
SELECT COALESCE(null, 1) AS number;
SELECT COALESCE(null, null, 1) AS number;
SELECT COALESCE(null, null, 1, 10) AS number;
```
  
Replace all `NULL` with 'Email not provided'
```sql
SELECT COALESCE(email, 'Email not provided') FROM car;
```
  
## `NULLIF()`
  
Divide by zero error.  
```sql
SELECT 10 / 0;
```
  
Returns `NULL`!  
```sql
SELECT 10 / NULL;
```
  
Set to `NULL` if values match  
```sql
SELECT NULLIF(100, 100);
```
  
Returns `5`  
```sql
SELECT 10 / NULLIF(2, 9);
```
  
Returns `NULL`
```sql
SELECT 10 / NULLIF(0, 0);
```
  
Returns `0`!
```sql
SELECT COALESCE(10 / NULLIF(0, 0), 0);
```
  
## Timestamps and Dates
  
```sql
SELECT NOW();
SELECT NOW()::DATE;
SELECT NOW()::TIME;
SELECT NOW() - INTERVAL '1 YEAR';
SELECT (NOW() - INTERVAL '1 YEAR')::DATE;
```
  
## `EXTRACT()`
  
```sql
SELECT EXTRACT(YEAR FROM NOW());
```
  
## `AGE()`
  
```sql
SELECT first_name, last_name, gender, country_of_birth, date_of_birth, AGE(NOW(), date_of_birth) FROM "person";
```
Can use `EXTRACT()` to get the field.
  
## Primary keys
  
Primary keys (PK) are values in a column which uniquely identifies a record in any table  
  
Unique numbers are often used as the primary key. `BIGSERIAL` is fine.  
  
`\d "table"` can tell you the PKs under the Indexes:  
  
Cannot add entries with duplicate primary key  
Could if you do the following then try:  
```sql
ALTER TABLE "person" DROP CONSTRAINT person_pkey
```
  
```sql
DELETE FROM person WHERE id = 1;
```
  
(id) below is an array that theoretically you could add multiple columns to.  
```sql
ALTER TABLE "person" ADD PRIMARY KEY (id);
```
## Adding `UNIQUE` `CONSTRAINT` 
  
Reveals we have many `NULL` values and maybe some duplicates!  
```sql
SELECT email, COUNT(*) FROM person GROUP BY email HAVING COUNT(*) > 1;
```
  
Unique constraints prevent duplicate values for a column (as opposed to PKs preventing )  
Will give error if non-`NULL` duplicates! Will need to alter/delete duplicate entries  
```sql
ALTER TABLE person ADD CONSTRAINT unique_email_address UNIQUE (email);
```
Can view the unique constraint created under `\d "table"`.  
  
Can also add during table creation:  
```sql
CREATE TABLE person (  
    id BIGSERIAL NOT NULL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    ...  
    car_id BIGINT REFERENCES car (id),
    UNIQUE(car_id)  
);
```
  
To drop:  
```sql
ALTER TABLE person DROP CONSTRAINT unique_email_address;
```
  
## Adding `CHECK` `CONSTRAINT`  
  
Reveals we have an anomalous label, `Hello`!  
```sql
SELECT DISTINCT gender FROM person;
```
  
Can prevent acceptance of values with a check constraint!  
First need to alter or delete the row with the anomalous value!  
```sql
ALTER TABLE person ADD CONSTRAINT gender_constraint CHECK (gender = 'Female' OR gender = 'Male');
```
  
## `DELETE` rows  
  
Recommended, always include `WHERE`  
  
Deletes everything from the table  
```sql
DELETE FROM person;
```
  
```sql
DELETE FROM person WHERE gender = 'Female';
```
  
## `UPDATE`  
  
Recommended, always include `WHERE`  
  
```sql
UPDATE person SET email = 'omar@gmail.com' WHERE id = 2011;
```
  
```sql
UPDATE person SET first_name = 'Omar', last_name = 'Montana', email = 'omar.montana@gmail.com' WHERE id = 2011;
```
  
## `ON CONFLICT`, `DO NOTHING`  
  
Inserting duplicate entry into table results in error! If you want to handle this conflict then use `ON CONFLICT`  
  
Only works on a column with unique/exclusion constraint  
```sql
INSERT INTO person (id, first_name, last_name, gender, email, date_of_birth, country_of_birth)  
VALUES(2017, 'Russ', 'Ruddoch', 'Male', 'rruddoch7@hhs.gov', DATE '1952-09-25', 'Norway')  
ON CONFLICT (id) DO NOTHING;
```
  
## Upsert  
  
In case of conflict replace email and first name with those from the entry you are trying to insert.  
```sql
INSERT INTO person (id, first_name, last_name, gender, email, date_of_birth, country_of_birth)  
VALUES(2017, 'Russ', 'Ruddoch', 'Male', 'rruddoch7@hhs.gov', DATE '1952-09-25', 'Norway')  
ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email, first_name = EXCLUDED.first_name;
```
  
## Foreign Keys & Joins  
  
In relational DB, want to have multiple tables, not just one which has everything, and you want to connect them together based on a foreign key.  
Foreign key references the primary key of another table.  
  
person table may have a "car_id" column which references the id column of the car table.  
A person can only have one car in this example.  
```sql
car_id BIGINT REFERENCES car(id) UNIQUE (car_id)  
```
  
## Updating Foreign Keys Columns  
  
Let's say car_id is `NULL` for a couple people and needs to be added:  
```sql
UPDATE person SET car_id = 2 WHERE id = 1;
UPDATE person SET car_id = 2 WHERE id = 2; -- Won't work because of UNIQUE constraint!  
UPDATE person SET car_id = 1 WHERE id = 2;
```
  
## Inner `JOIN`  
  
Join two tables if a foreign key present in both tables, making a third table that is the common columns between them.   
  
```sql
SELECT * FROM person  
JOIN car ON person.car_id = car.id;
```
  
Grab certain columns from each table:  
```sql
SELECT person.first_name, car.make, car.model, car.price FROM person  
JOIN car ON person.car_id = car.id;
```
  
## `LEFT JOIN`  
  
Join two tables making third table composed of all of A plus the intersection of A and B.  
  
Before the query would only include entires which had non-`NULL` car_id's!  
We can include all entries of person, including `NULL` car-values if we do a left join! AKA entries from the left table which don't have a foreign key relationship with the right table.  
```sql
SELECT * FROM person  
LEFT JOIN car ON car.id = person.car_id;
```
Get just `NULL` car-value entries  
```sql
SELECT * FROM person  
LEFT JOIN car ON car.id = person.car_id  
WHERE car.* IS NULL;
```
  
## Deleting records with Foreign Keys  
  
Won't work since this car is referenced in the person table!  
```sql
DELETE FROM car WHERE id = 13;
```
Need to remove this car_id from the entry in person. Can delete the person or update the person to remove this car_id.  
  
A cascade added upon table creation would ignore foreign key and would allow removal of all entries where this car_id is referenced. It's bad practice! Deleting data without thinking can be very costly!  
  
## Exporting query results to CSV  
  
```sql
\copy (  
    SELECT * FROM person  
    LEFT JOIN car ON car.id = person.car_id  
) TO '/path/to/save/results.csv' DELIMITER ',' CSV HEADER;
```

## `COPY` from CSV

```postgresql
CREATE TABLE persons (   id SERIAL,   first_name VARCHAR(50),   last_name VARCHAR(50),   dob DATE,   email VARCHAR(255),   PRIMARY KEY (id) )
```

The name and order of the columns must be the same as the ones in the CSV file. In case the CSV file contains all columns of the table, you don’t need to specify them explicitly, for example:
```postgresql
COPY persons(first_name, last_name, dob, email)
FROM 'C:\sampledb\persons.csv'
DELIMITER ','
CSV HEADER;`
```

Another example that uses `WITH (FORMAT csv)`:
```postgresql
CREATE TABLE zip_codes
(ZIP char(5), LATITUDE double precision, LONGITUDE double precision,
CITY varchar, STATE char(2), COUNTY varchar, ZIP_CLASS varchar);

COPY zip_codes
FROM '/path/to/csv/ZIP_CODES.txt'
WITH (FORMAT csv);
```
## Serials and Sequences  
  
In `\d` you can see that sequences reference an `<attribute>_seq` object.  
```sql
SELECT * FROM person_id_seq; -- Show's last_value, log_cnt, is_called  
SELECT nextval('person_id_seq'::regclass); -- Show's next value and last_value++.  
ALTER SEQUENCE person_id_seq RESTART WITH 1;
```
  
## Extensions  
  
Display extensions.  
```sql
SELECT * from pg_available_extensions;
```
  
Install  
```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```
  
## Universally Unique Identifiers  
  
Prevents collisions as every entry's ID in the database is unique!  
  
```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
\df -- Lists functions  
```
```sql
SELECT uuid_generate_v4(); -- generates a single UUID  
```
```sql
CREATE TABLE person (  
    person_uid UUID NOT NULL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    ...  
    car_uid UUID REFERENCES car (id),
    UNIQUE(car_uid),
    UNIQUE(email)  
);
INSERT INTO person(person_uid, first_name, last_name, gender, email, date_of_birth, country_of_birth)  
VALUES (uuid_generate_v4(), 'Fernanda', 'Beardon', 'Female', 'fernandab@is.gd', '1953-10-28', 'Comoros');
-- Insert a car into the new car table which has a car uuid.  
UPDATE person SET car_uid = '<car UUID>' WHERE person_uid = '<person UUID>'  
```
```sql
SELECT * FROM person JOIN car ON person.car_uid = car.car_uid;
SELECT * FROM person JOIN car USING car_uid; -- Equivalent, easier when have the same name!  
```

## `BEGIN`, `COMMIT`, and `ROLLBACK`

These three commands allows multiple commands to be run as a single, atomic series of transactions that can be committed upon success or reverted upon failure (handled conditionally or most unhandled errors).

`BEGIN` opens the transaction block while `COMMIT` ends it with having the DBMS apply the changes if successful. `ROLLBACK` can revert all changes made within the transaction block.
```postgresql
BEGIN;

-- Some SQL commands 
-- ...

COMMIT; -- Make all changes permanent
```

More complex example where `ROLLBACK` is used conditionally.
```postgresql
DO $$
BEGIN
    -- Start the transaction
    BEGIN;

    -- Assume we are transferring $100 from user with id=1 to user with id=2
    DECLARE
        user1_balance NUMERIC;
        transfer_amount NUMERIC := 100;
    BEGIN
        -- Check the balance of user 1
        SELECT balance INTO user1_balance FROM users WHERE id = 1;

        -- Check if user 1 has enough balance
        IF user1_balance < transfer_amount THEN
            RAISE EXCEPTION 'Insufficient balance';
        END IF;

        -- Deduct the amount from user 1
        UPDATE users SET balance = balance - transfer_amount WHERE id = 1;
        -- Add the amount to user 2
        UPDATE users SET balance = balance + transfer_amount WHERE id = 2;

        -- Commit the transaction
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            -- If any error occurs, roll back the transaction
            ROLLBACK;
            RAISE;
    END;
END;
$$;
```
