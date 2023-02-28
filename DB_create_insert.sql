CREATE database hospitalparking; 
USE hospitalparking; 

SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE parking_spot (
  id INT PRIMARY KEY,
  location VARCHAR(255) NOT NULL,
  status VARCHAR(255) NOT NULL,
  vehicle_id INT,
  FOREIGN KEY (vehicle_id) REFERENCES vehicle(id)
);

CREATE TABLE user (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  role_id INT,
  FOREIGN KEY (role_id) REFERENCES role(id)
);

CREATE TABLE vehicle (
  id INT PRIMARY KEY,
  make VARCHAR(255) NOT NULL,
  model VARCHAR(255) NOT NULL,
  license_plate VARCHAR(255) NOT NULL,
  user_id INT,
  FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE reservation (
  id INT PRIMARY KEY,
  user_id INT,
  parking_spot_id INT,
  vehicle_id INT,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  FOREIGN KEY (user_id) REFERENCES user(id),
  FOREIGN KEY (parking_spot_id) REFERENCES parking_spot(id),
  FOREIGN KEY (vehicle_id) REFERENCES vehicle(id)
);

CREATE TABLE role (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE parking_ticket (
  id INT PRIMARY KEY,
  parking_spot_id INT,
  vehicle_id INT,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  payment_id INT,
  FOREIGN KEY (parking_spot_id) REFERENCES parking_spot(id),
  FOREIGN KEY (vehicle_id) REFERENCES vehicle(id),
  FOREIGN KEY (payment_id) REFERENCES payment(id)
);

CREATE TABLE payment (
  id INT PRIMARY KEY,
  user_id INT,
  amount DECIMAL(10,2) NOT NULL,
  payment_time DATETIME NOT NULL,
  FOREIGN KEY (user_id) REFERENCES user(id)
);

ALTER TABLE parking_spot
ADD COLUMN vehicle_id INT;

-- Populating the Database 
-- Data for parking_spot table
INSERT INTO parking_spot (id, location, status, vehicle_id) VALUES
(1, 'Street A, Block 1, Lot 5', 'available', NULL),
(2, 'Street B, Block 2, Lot 10', 'occupied', 1),
(3, 'Street C, Block 3, Lot 15', 'available', NULL),
(4, 'Street D, Block 4, Lot 20', 'available', NULL),
(5, 'Street E, Block 5, Lot 25', 'occupied', 2);

-- Data for user table
INSERT INTO user (id, name, email, password, role_id) VALUES
(1, 'John Smith', 'john.smith@example.com', 'password123', 2),
(2, 'Jane Doe', 'jane.doe@example.com', 'password456', 1),
(3, 'Bob Johnson', 'bob.johnson@example.com', 'password789', 2);

-- Data for vehicle table
INSERT INTO vehicle (id, make, model, license_plate, user_id) VALUES
(1, 'Honda', 'Accord', 'ABC123', 2),
(2, 'Toyota', 'Camry', 'XYZ789', 1),
(3, 'Ford', 'Mustang', 'DEF456', 3);

-- Data for reservation table
INSERT INTO reservation (id, user_id, parking_spot_id, vehicle_id, start_time, end_time) VALUES
(1, 1, 1, NULL, '2022-05-19 10:00:00', '2022-05-01 11:00:00'),
(2, 2, 3, 2, '2022-05-20 13:00:00', '2022-05-02 15:00:00'),
(3, 3, 4, 3, '2022-05-21 09:00:00', '2022-05-03 12:00:00'),
(4, 3, 2, 5, '2023-02-23 10:00:00', '2023-02-23 12:00:00'),
(5, 5, 4, 7, '2023-02-24 09:00:00', '2023-02-24 11:00:00'),
(6, 2, 3, 8, '2023-02-25 08:00:00', '2023-02-25 10:00:00'),
(7, 1, 1, 6, '2023-02-25 12:00:00', '2023-02-25 14:00:00'),
(8, 4, 6, 9, '2023-02-26 13:00:00', '2023-02-26 15:00:00'),
(9, 1, 9, 10, '2023-02-27 10:00:00', '2023-02-27 12:00:00'),
(10, 2, 5, 11, '2023-02-27 14:00:00', '2023-02-27 16:00:00'),
(11, 3, 8, 12, '2023-02-28 11:00:00', '2023-02-28 13:00:00'),
(12, 4, 7, 13, '2023-02-28 14:00:00', '2023-02-28 16:00:00'),
(13, 5, 2, 14, '2023-03-01 09:00:00', '2023-03-01 11:00:00');

-- Data for role table
INSERT INTO role (id, name) VALUES
(1, 'Regular'),
(2, 'Admin');

-- Data for parking_ticket table
INSERT INTO parking_ticket (id, parking_spot_id, vehicle_id, start_time, end_time, payment_id) VALUES
(1, 2, 1, '2022-05-04 08:00:00', '2022-05-04 10:00:00', 1),
(2, 5, 2, '2022-05-05 12:00:00', '2022-05-05 15:00:00', 2),
(3, 1, 3, '2022-05-06 09:00:00', '2022-05-06 11:00:00', 3);

-- Data for payment table
INSERT INTO payment (id, user_id, amount, payment_time) VALUES
(1, 1, 5.00, '2022-05-04 10:00:00'),
(2, 2, 7.50, '2022-05-05 15:00:00'),
(3, 3, 10.00, '2022-05-06 11:00:00');

-- the occupancy rate of the parking lot for a specific day
SELECT COUNT(DISTINCT parking_spot_id) / COUNT(*) AS occupancy_rate
FROM reservation
WHERE start_time >= '2023-02-28 00:00:00' AND end_time <= '2023-02-28 23:59:00';

-- count of each parking spot based on the number of reservations made
SELECT parking_spot_id, COUNT(*) AS usage_count
FROM reservation
GROUP BY parking_spot_id
ORDER BY usage_count DESC;

-- counts the number of reservations for a specific time range
SELECT COUNT(*) AS reservation_count
FROM reservation
WHERE start_time >= '2023-02-01 00:00:00' AND end_time <= '2023-05-01  23:59:59';

-- ticket count for each vehicle that has parked in the parking lot
SELECT vehicle_id, COUNT(*) AS ticket_count
FROM parking_ticket
GROUP BY vehicle_id
ORDER BY ticket_count DESC;

-- total revenue generated by the parking lot for a specific time range
SELECT SUM(amount) AS revenue
FROM payment
WHERE payment_time >= '2022-02-01 00:00:0' AND payment_time <= '2023-05-01 00:00:00';

-- reservation count for each user who has made a reservation
SELECT user_id, COUNT(*) AS reservation_count
FROM reservation
GROUP BY user_id
ORDER BY reservation_count DESC;

-- retrieves the parking_spot_id and location for all available parking spots
SELECT id, location
FROM parking_spot
WHERE status = 'available';

-- number of vehicles parked in the parking lot on a specific day
SELECT COUNT(DISTINCT vehicle_id) AS parked_vehicle_count
FROM reservation
WHERE start_time >= '2023-02-28 00:00:00' AND end_time <= '2023-02-28 23:59:59';

-- role of each user
SELECT user.name, role.name AS role_name
FROM user
JOIN role ON user.role_id = role.id;


--  average duration of a parking reservation
SELECT AVG(TIMESTAMPDIFF(MINUTE, start_time, end_time)) as avg_duration
FROM reservation;

