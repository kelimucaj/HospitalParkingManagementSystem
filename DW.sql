CREATE DATABASE hospital_parking_dw;
USE hospital_parking_dw;

SET FOREIGN_KEY_CHECKS=0;


CREATE TABLE parking_fact (
  id INT PRIMARY KEY,
  time_id INT NOT NULL,
  user_id INT NOT NULL,
  vehicle_id INT NOT NULL,
  parking_spot_id INT NOT NULL,
  payment_method_id INT NOT NULL,
  duration_minutes INT NOT NULL,
  ticket_count INT NOT NULL,
  reservation_count INT NOT NULL,
  FOREIGN KEY (time_id) REFERENCES time_dim(id),
  FOREIGN KEY (user_id) REFERENCES user_dim(id),
  FOREIGN KEY (vehicle_id) REFERENCES vehicle_dim(id),
  FOREIGN KEY (parking_spot_id) REFERENCES parking_spot_dim(id),
  FOREIGN KEY (payment_method_id) REFERENCES payment_method_dim(id)
);

CREATE TABLE time_dim (
  id INT PRIMARY KEY,
  date DATE NOT NULL,
  hour INT NOT NULL,
  minute INT NOT NULL
);

CREATE TABLE user_dim (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  role_id INT NOT NULL,
  FOREIGN KEY (role_id) REFERENCES role(id)
);

CREATE TABLE vehicle_dim (
  id INT PRIMARY KEY,
  brand VARCHAR(255) NOT NULL,
  license_plate VARCHAR(255) NOT NULL,
  user_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES user_dim(id)
);

CREATE TABLE parking_spot_dim (
  id INT PRIMARY KEY,
  location VARCHAR(255) NOT NULL,
  status VARCHAR(255) NOT NULL,
  vehicle_id INT,
  FOREIGN KEY (vehicle_id) REFERENCES vehicle_dim(id)
);

CREATE TABLE payment_method_dim (
  id INT PRIMARY KEY,
  method_name VARCHAR(255) NOT NULL
);

-- ETL for loading data

INSERT INTO user_dim (id, name, email, role_id)
SELECT id, name, email, role_id FROM user;


INSERT INTO parking_spot_dim (id, location, status, vehicle_id)
SELECT id, location, status, vehicle_id FROM parking_spot;

INSERT INTO payment_method_dim (id, method_name)
SELECT id, method_name FROM payment_method;


-- SELECT statements
-- number of parking reservations made by user role
SELECT user_dim.role_id, COUNT(parking_fact.reservation_count) as reservation_count
FROM parking_fact
JOIN user_dim ON parking_fact.user_id = user_dim.id
GROUP BY user_dim.role_id;

-- average duration of parking spot usage by location and status
SELECT parking_spot_dim.location, parking_spot_dim.status, AVG(parking_fact.duration_minutes) as avg_usage_duration
FROM parking_fact
JOIN parking_spot_dim ON parking_fact.parking_spot_id = parking_spot_dim.id
GROUP BY parking_spot_dim.location, parking_spot_dim.status;

