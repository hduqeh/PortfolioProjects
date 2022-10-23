-- Create a new database called shirts_db
CREATE DATABASE shirts_db  -- But I just right clicked on database
USE shirts_db


-- Create a new table called shirts

CREATE TABLE shirts
(
	shirts_id INT NOT NULL IDENTITY PRIMARY KEY,
	article VARCHAR(100),
	color VARCHAR(100),
	shirt_size VARCHAR(100),
	last_worn INT
);



INSERT INTO shirts (article, color, shirt_size, last_worn)
VALUES ('t-shirt', 'white', 'S', 10),
('t-shirt', 'green', 'S', 200),
('polo shirt', 'black', 'M', 10),
('tank top', 'blue', 'S', 50),
('t-shirt', 'pink', 'S', 0),
('polo shirt', 'red', 'M', 5),
('tank top', 'white', 'S', 200),
('tank top', 'blue', 'M', 15);

SELECT * FROM shirts


-- I decided to add another row
-- Add a new shirt purple, polo shirt, size M, last worn 50 days ago

INSERT INTO shirts (article, color, shirt_size, last_worn)
VALUES ('polo shirt', 'purple', 'M', 50);


-- Next, SELECT all shirts but only print out article and color

SELECT article, color FROM shirts 



-- SELECT all medium shirts, print out everything but shirt_id

SELECT article, color, shirt_size, last_worn FROM shirts
WHERE shirt_size='M'



-- Update all polo shirts, change their size to L

UPDATE shirts 
SET shirt_size='L'
where article='polo shirt';

SELECT * FROM shirts



-- Update the shirt that was last worn 15 days ago, change last_worn to 0

UPDATE shirts
SET last_worn=0
WHERE last_worn=15



-- Update all white shirts, change size to 'XS' and color to 'off white'

Update shirts
SET shirt_size='XS' , color='off white'
WHERE color='white'



-- Delete all old shirts, last worn 200 days ago

DELETE FROM shirts
WHERE last_worn=200



-- Delete all tank tops from our database

DELETE FROM shirts
where article='tank top'



-- Delete all shirts

DELETE FROM shirts



-- Drop the entire shirts table

DROP TABLE shirts_db