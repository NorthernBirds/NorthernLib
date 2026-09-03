CREATE DATABASE IF NOT EXISTS <your_db_name> CHARACTER SET utf8mb4 COLLATE utf8mb4_turkish_ci;
USE <your_db_name>;

DROP USER IF EXISTS '<your_db_user>'@'127.0.0.1';
CREATE USER '<your_db_user>'@'<127.0.0.1>' IDENTIFIED BY 'your_db_password';
GRANT ALL PRIVILEGES ON <your_db_name>.* TO '<your_db_user>'@'127.0.0.1';

FLUSH PRIVILEGES;

SET SQL_SAFE_UPDATES = 0;

CREATE TABLE libraries(id INT AUTO_INCREMENT PRIMARY KEY,
libName VARCHAR(20),
libPassword VARCHAR(255),
licenseID INT NOT NULL);

CREATE TABLE licenseKeys(id INT AUTO_INCREMENT PRIMARY KEY,
licenseKey VARCHAR(32) NOT NULL UNIQUE,
isActive BOOLEAN DEFAULT FALSE);

CREATE TABLE users(id INT AUTO_INCREMENT PRIMARY KEY,
userName VARCHAR(20) NOT NULL UNIQUE,
userPassword VARCHAR(60) NOT NULL,
userRole ENUM("admin","user"));

INSERT INTO users (userName,userPassword,userRole) VALUES ('<your_admin_username>',"<your_admin_password>","admin");

CREATE TABLE sessions(id INT AUTO_INCREMENT PRIMARY KEY,
userID INT,
token VARCHAR(64) NOT NULL UNIQUE,
duration INT);


