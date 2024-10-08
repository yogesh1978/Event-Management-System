/* Dropping the tables */

DROP TABLE Service_Reservation CASCADE CONSTRAINTS;
DROP TABLE Event_Reservation CASCADE CONSTRAINTS;
DROP TABLE Guest CASCADE CONSTRAINTS;
DROP TABLE Service_Type CASCADE CONSTRAINTS;
DROP TABLE Event_Type CASCADE CONSTRAINTS;
DROP TABLE Available_Room_per_hotel CASCADE CONSTRAINTS;
DROP TABLE Room_Type CASCADE CONSTRAINTS;
DROP TABLE Hotel CASCADE CONSTRAINTS;

--------------------------------------------------------------------------------------------------------------------------------------------

/* Creating and inserting values in the tables */

CREATE TABLE Hotel (
  Hotel_ID int not null,
  Hotel_Name varchar(50) not null,
  Hotel_Address varchar(100),
  State varchar(50) not null,
  Zip_Code varchar(30),
  Website varchar(255),
  Phone varchar(30),
  PRIMARY KEY (Hotel_ID)
);

--------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Room_Type (
  Room_ID int not null,
  Room_Size varchar(30), 
  Room_Capacity number,  --maximum number of people
  Room_Price number,     --daily rates of each room_size
  PRIMARY KEY (Room_ID),
  CONSTRAINT room_size_ck CHECK (Room_Size in ('small_hall' , 'medium_hall' , 'large_hall' )) 
);

INSERT INTO Room_Type
VALUES (101, 'small_hall', 100, 500);

INSERT INTO Room_Type
VALUES (102, 'medium_hall', 250, 1000);

INSERT INTO Room_Type
VALUES (103, 'large_hall', 500, 2000);

--------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Available_Room_per_hotel (
	Available_Room_ID int not null,
	Hotel_ID int not null,
	Room_ID int not null,
	Total_Room int,
	Available_Room int,
	PRIMARY KEY (Available_Room_ID),
	FOREIGN KEY (Hotel_ID) REFERENCES Hotel (Hotel_ID),
	FOREIGN KEY (Room_ID) REFERENCES Room_Type (Room_ID)
);

--------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Event_Type (
  Event_ID int not null,
  Event_Name varchar(50) not null,
  PRIMARY KEY (Event_ID)
);

INSERT INTO Event_Type
VALUES (1, 'Birthday'); 

INSERT INTO Event_Type
VALUES (2, 'Wedding');

INSERT INTO Event_Type
VALUES (3, 'Conference');

INSERT INTO Event_Type
VALUES (4, 'Workshop');

INSERT INTO Event_Type
VALUES (5, 'University Admission');

INSERT INTO Event_Type
VALUES (6, 'Hackathon');

--------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Service_Type (
  Service_ID int not null,
  Service_Name varchar(30) not null,
  Service_Applies varchar(30), 
  Service_Amount number,
  PRIMARY KEY (Service_ID)
);

INSERT INTO Service_Type
VALUES (1, 'Breakfast', 'per_person', 10);

INSERT INTO Service_Type
VALUES (2, 'Lunch', 'per_person', 20);

INSERT INTO Service_Type
VALUES (3, 'DJ', 'per_event', 500);

INSERT INTO Service_Type
VALUES (4, 'Singer', 'per_event', 2000);

INSERT INTO Service_Type
VALUES (5, 'Pop band', 'per_event', 10000);

--------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Guest (
  Guest_ID int not null,
  Guest_Name varchar(50),
  Guest_Phone varchar(30),
  Guest_Email varchar(255),
  CONSTRAINT guest_email_uk UNIQUE(Guest_Email),
  PRIMARY KEY (Guest_ID)
);

INSERT INTO Guest
VALUES (1, 'Harish Shah', '+1 860-610 (8162)','harishr1@umbc.edu');

INSERT INTO Guest
VALUES (2, 'Mrs. Brown', '+1 431-567 (7891)', 'brown3@yahoo.com');

INSERT INTO Guest
VALUES (3, 'Mr. Zero', '+1 433-567 (7891)', 'zero13@yahoo.com');

INSERT INTO Guest
VALUES (4, 'Mr. Cyber', '+1 436-567 (7891)', 'cyber13@yahoo.com');

--------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Event_Reservation(
  Event_Reservation_ID int not null,
  Guest_ID int not null,
  Hotel_ID int not null,
  Event_ID int not null,
  Start_Date date,
  End_Date date,
  Room_ID int not null,
  Room_Quantity int not null,
  Room_Invoice number,
  Date_Of_Reservation date,
  No_Of_People number,
  Status int,
  CONSTRAINT status_ck CHECK (Status in(1,2,3)),  -- 1=Reserved, 2=Cancelled, 3=Finished
  PRIMARY KEY (Event_Reservation_ID),
  FOREIGN KEY (Guest_ID) REFERENCES Guest (Guest_ID),
  FOREIGN KEY (Hotel_ID) REFERENCES Hotel (Hotel_ID),
  FOREIGN KEY (Event_ID) REFERENCES Event_Type (Event_ID),
  FOREIGN KEY (Room_ID) REFERENCES Room_Type (Room_ID)
);


--------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Service_Reservation (
  Service_Reservation_ID int not null,
  Event_Reservation_ID int not null,
  Service_ID int not null,
  Service_date date,
  PRIMARY KEY (Service_Reservation_ID),
  FOREIGN KEY (Event_Reservation_ID) REFERENCES Event_Reservation (Event_Reservation_ID),
  FOREIGN KEY (Service_ID) REFERENCES Service_Type (Service_ID)
);

--------------------------------------------------------------------------------------------------------------------------------------------

/* Selecting the tables*/

SELECT * FROM Room_Type;
SELECT * FROM Event_Type;
SELECT * FROM Service_Type;
SELECT * FROM Guest;
SELECT * FROM Event_Reservation;
SELECT * FROM Service_Reservation;

--------------------------------------------------------------------------------------------------------------------------------------------



