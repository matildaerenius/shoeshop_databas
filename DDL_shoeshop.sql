DROP DATABASE IF EXISTS shoeshop;
CREATE DATABASE shoeshop;
USE shoeshop;

/* Customer innehåller inga FK så att man kan skapa upp en ny kund utan att behöva
förlita sig på annan data 
*/
CREATE TABLE customer (
id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
first_name varchar(50) NOT NULL,
last_name varchar(50) NOT NULL,
city varchar(50) NOT NULL);


INSERT INTO customer(first_name,last_name,city) VALUES
('Rose','Philipsen','Solna'),
('Matilda','Erenius','Stockholm'),
('Sandra','Lindqvist','Nacka'),
('Magnus','Eriksson','Huddinge'),
('Emil','Svensson','Sundbyberg'),
('Kevin','Hamilton','Bromma');


/* FK finns med för att varje beställning ska kopplas till en kund. Jag har valt att 
inte sätta FK som ON DELETE SET NULL eller ON DELETE CASCADE, utan jag vill 
att en kund inte ska kunna tas bort efter lagt order utan existerar så länge 
ordern finns kvar.
Detta för historikens syfte, en order måste vara kopplad till en fysisk kund 
*/
CREATE TABLE orders (
id int NOT NULL AUTO_INCREMENT PRIMARY KEY ,
date date NOT NULL,
customer_id int NOT NULL,
FOREIGN KEY (customer_id) REFERENCES customer (id)
);

INSERT INTO orders(date,customer_Id) VALUES
('2024-12-24',1),
('2025-01-01',1),
('2025-01-06',2),
('2024-12-31',3),
('2025-01-03',5),
('2025-01-05',6);


/* Ingen FK finns för att enkelt kunna lägga till fler produkter i framtiden */
CREATE TABLE product (
id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
size int NOT NULL,
color varchar(50) NOT NULL,
brand varchar(50) NOT NULL,
price int NOT NULL,
stock int NOT NULL);


INSERT INTO product(size,color,brand,price,stock) VALUES
(40,'White','Timberland',599,200),
(38,'Black','Ecco',1299,250),
(44,'Red','Nike',1599,300),
(42,'Pink','Reebok',299,450),
(35,'Black','Vans',399,200),
(39,'Brown','Puma',799,210),
(36,'Blue','Converse',899,190),
(37,'White','Adidas',1799,210);


/* En order kan bestå av flera produkter, därav en Order_details som då kopplar ihop
ett Order_Id och Product_Id. En order kan förekomma flera gånger i denna table
så att en customer kan beställa olika varor i samma beställning. Jag har valt
att sätta ON DELETE CASCADE på orders_id då raderingen av en order även då ska 
radera dess order_details, då det känns rimligt. 
Jag har dock valt att inte sätta någonting på product_id, då jag vill att om
en produkt ingår i en order ska den inte kunna tas bort pga av historikskäl. 
Jag hade kunnat sätta den som ON DELETE SET NULL, men jag kände att jag ville
ha kvar hela produkten och då således inte sätta produkten till null.
 */ 
CREATE TABLE order_details (
id int NOT NULL AUTO_INCREMENT PRIMARY KEY ,
orders_id int NOT NULL,
product_id int NOT NULL,
quantity int NOT NULL,
FOREIGN KEY (orders_id) REFERENCES orders (id) ON DELETE CASCADE,
FOREIGN KEY (product_id) REFERENCES product (id)
);

INSERT INTO order_details(quantity,product_id,orders_id) VALUES
(3,1,1),
(2,2,1),
(1,2,4),
(1,4,3),
(1,8,6),
(2,6,2);


CREATE TABLE category (
id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
name varchar(50) NULL);


INSERT INTO category(name) VALUES
('Running'),
('Sandals'),
('Winter'),
('Women'),
('Men'),
('Kids');


/* FK finns för att koppla ihop varje produkt med en eller flera kategorier, 
jag har gjort båda FK unika eftersom att det inte ska gå att samma produkt
hamnar i samma kategori två gånger. Har satt ON DELETE CASCADE på båda FK 
eftersom jag anser det rimligast, att raderar man en kategori eller produkt
ska även kopplingen raderas, då den inte längre är meningsfull eftersom det
är en kopplingstabell
*/
CREATE TABLE product_category (
id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
product_id int NOT NULL,
category_id int NOT NULL,
UNIQUE KEY (product_id, category_id),
FOREIGN KEY (category_id) REFERENCES category (id) ON DELETE CASCADE,
FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE
);

INSERT INTO product_category(product_id,category_id) VALUES
(5,4),
(2,2),
(1,3),
(3,5),
(4,4),
(8,1),
(6,2),
(7,6);


/* Jag har valt att implementera index så att man lätt kan 
   söka på en kunds namn och en produkt av ett visst märke */
CREATE INDEX ix_first_name ON customer (first_name);

CREATE INDEX ix_brand ON product(brand);

