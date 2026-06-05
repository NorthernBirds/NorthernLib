CREATE DATABASE IF NOT EXISTS library CHARACTER SET utf8mb4 COLLATE utf8mb4_turkish_ci;
USE library;

CREATE USER 'admin'@'127.0.0.1' IDENTIFIED BY 'Kutuphane@Yonetim#2026!';
GRANT ALL PRIVILEGES ON library.* TO 'admin'@'127.0.0.1';

CREATE USER 'admin'@'10.156.231.0' IDENTIFIED BY 'Kutuphane@Yonetim#2026!';
GRANT ALL PRIVILEGES ON library.* TO 'admin'@'10.156.231.0';

FLUSH PRIVILEGES;

SET SQL_SAFE_UPDATES = 0;

CREATE TABLE libraries(id INT AUTO_INCREMENT PRIMARY KEY,
libName VARCHAR(20),
libPassword VARCHAR(255));





INSERT INTO users (userName,userPassword,userRole) VALUES ('admin admin','$2b$12$Eol3G1ux.SoqOse7DYwEt.aiPCqExmsaYddIuLn8HZmJlMlQS1QTi','admin');
INSERT INTO importantValues (situationValue,valueStatus) VALUES ('App Is Locked',FALSE);




