from writeLog import writeLog
import config

def setup(name,password,conn,cursor):

    try:

        cursor.execute("CREATE DATABASE IF NOT EXISTS "+name)
        conn.commit()
        cursor.execute("CREATE USER 'admin'@'127.0.0.1' IDENTIFIED BY '"+password+"'")
        conn.commit()
        cursor.execute("GRANT ALL PRIVILEGES ON " + name + ".* TO 'admin'@'127.0.0.1'")
        conn.commit()
        cursor.execute("FLUSH PRIVILEGES")
        conn.commit()
        cursor.execute("SET SQL_SAFE_UPDATES = 0")
        conn.commit()
        cursor.execute("CREATE TABLE users(id INT AUTO_INCREMENT PRIMARY KEY, userName VARCHAR(20) NOT NULL UNIQUE, userPassword VARCHAR(60) NOT NULL, userRole ENUM('admin','teacher','student_staff') NOT NULL)")
        conn.commit()
        cursor.execute("CREATE TABLE books(id INT AUTO_INCREMENT PRIMARY KEY,bookName VARCHAR(50) NOT NULL, writer VARCHAR(50) NOT NULL, publisher VARCHAR(20) NOT NULL, pageCount INT NOT NULL CHECK(pageCount <= 99999), category ENUM('Roman','Hikaye','Şiir','Biyografi','Otobiyografi','Tarih','Bilim','Kişisel Gelişim','Ders Kitabı','Ansiklopedi','Çizgi Roman') NOT NULL,isTaken BOOLEAN DEFAULT FALSE,whoAdded VARCHAR(20) NOT NULL)")
        conn.commit()
        cursor.execute("CREATE TABLE categories(id INT AUTO_INCREMENT PRIMARY KEY,categoryName ENUM('Roman','Hikaye','Şiir','Biyografi','Otobiyografi','Tarih','Bilim','Kişisel Gelişim','Ders Kitabı','Ansiklopedi','Çizgi Roman') NOT NULL,whoAdded VARCHAR(20) NOT NULL)")
        conn.commit()
        cursor.execute("CREATE TABLE loans(id INT AUTO_INCREMENT PRIMARY KEY,studentID INT NOT NULL,bookID INT NOT NULL,borrowDate DATE DEFAULT (CURRENT_DATE),returnDate VARCHAR(20),returnedAt VARCHAR(20),loanStatus ENUM('returned','not returned') DEFAULT 'not returned',whoAdded VARCHAR(20) NOT NULL)")
        conn.commit()
        cursor.execute("CREATE TABLE importantValues(id INT AUTO_INCREMENT PRIMARY KEY,situationValue TEXT NOT NULL, valueStatus BOOLEAN NOT NULL)")
        conn.commit()
        cursor.execute("INSERT INTO users (userName,userPassword,userRole) VALUES ('admin admin','$2b$12$Eol3G1ux.SoqOse7DYwEt.aiPCqExmsaYddIuLn8HZmJlMlQS1QTi','admin')")
        conn.commit()
        cursor.execute("INSERT INTO importantValues (situationValue,valueStatus) VALUES ('App Is Locked',FALSE)")
        conn.commit()
        return {"success":True}
    
    except Exception as e:

        writeLog(config.SETUPSQL_LOG_PATH,type(e).__name__,str(e))
        return {"success":False,"message":"Bir hata oluştu!"}