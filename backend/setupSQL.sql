CREATE DATABASE IF NOT EXISTS library CHARACTER SET utf8mb4 COLLATE utf8mb4_turkish_ci;
USE library;

CREATE USER 'admin'@'127.0.0.1' IDENTIFIED BY 'Kutuphane@Yonetim#2026!';
GRANT ALL PRIVILEGES ON library.* TO 'admin'@'127.0.0.1';

CREATE USER 'admin'@'10.156.231.0' IDENTIFIED BY 'Kutuphane@Yonetim#2026!';
GRANT ALL PRIVILEGES ON library.* TO 'admin'@'10.156.231.0';

FLUSH PRIVILEGES;

SET SQL_SAFE_UPDATES = 0;

CREATE TABLE users(id INT AUTO_INCREMENT PRIMARY KEY, 
userName VARCHAR(20) NOT NULL UNIQUE, 
userPassword VARCHAR(60) NOT NULL, 
userRole ENUM('admin','teacher','student_staff') NOT NULL);

CREATE TABLE books(id INT AUTO_INCREMENT PRIMARY KEY,
bookName VARCHAR(50) NOT NULL, 
writer VARCHAR(50) NOT NULL, 
publisher VARCHAR(20) NOT NULL, 
pageCount INT NOT NULL CHECK(pageCount <= 99999), 
category ENUM('Roman','Hikaye','Şiir','Biyografi','Otobiyografi','Tarih','Bilim','Kişisel Gelişim','Ders Kitabı','Ansiklopedi','Çizgi Roman') NOT NULL,
isTaken BOOLEAN DEFAULT FALSE,
whoAdded VARCHAR(20) NOT NULL);

CREATE TABLE categories(id INT AUTO_INCREMENT PRIMARY KEY,
categoryName ENUM('Roman','Hikaye','Şiir','Biyografi','Otobiyografi','Tarih','Bilim','Kişisel Gelişim','Ders Kitabı','Ansiklopedi','Çizgi Roman') NOT NULL,
whoAdded VARCHAR(20) NOT NULL);

CREATE TABLE loans(id INT AUTO_INCREMENT PRIMARY KEY,
studentID INT NOT NULL,
bookID INT NOT NULL,
borrowDate DATE DEFAULT (CURRENT_DATE),
returnDate VARCHAR(20),
returnedAt VARCHAR(20),
loanStatus ENUM('returned','not returned') DEFAULT 'not returned',
whoAdded VARCHAR(20) NOT NULL);

CREATE TABLE importantValues(id INT AUTO_INCREMENT PRIMARY KEY,
situationValue TEXT NOT NULL, valueStatus BOOLEAN NOT NULL);

INSERT INTO users (userName,userPassword,userRole) VALUES ('admin admin','your_admin_user_password','admin');
INSERT INTO importantValues (situationValue,valueStatus) VALUES ('App Is Locked',FALSE);




