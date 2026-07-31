import bcrypt
import config
from utils.writeLog import writeLog


def setup(name, password, conn, cursor, adminPassword):

    try:

        tablespace = f"tablespace_{name}"
        hashed_db_pass = bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode("utf-8")
        cursor.execute("INSERT INTO libraries (libName,libPassword) VALUES (%s,%s)", (name, hashed_db_pass))

        cursor.execute("CREATE TABLESPACE `" + tablespace + "` ADD DATAFILE '" + name + "_datafile.ibd' MAX_SIZE 10G ENGINE = InnoDB;")

        cursor.execute("CREATE SCHEMA `" + name + "` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_turkish_ci ;")

        cursor.execute("USE `" + name + "`")

        cursor.execute("SET SQL_SAFE_UPDATES = 0")

        cursor.execute("CREATE TABLE users(id INT AUTO_INCREMENT PRIMARY KEY, userName VARCHAR(20) NOT NULL UNIQUE, userPassword VARCHAR(60) NOT NULL, userRole ENUM('admin','teacher','student_staff') NOT NULL) TABLESPACE `" + tablespace + "`")
        cursor.execute("CREATE TABLE books(id INT AUTO_INCREMENT PRIMARY KEY,bookName VARCHAR(50) NOT NULL, writer VARCHAR(50) NOT NULL, publisher VARCHAR(20) NOT NULL, pageCount INT NOT NULL CHECK(pageCount <= 99999), category VARCHAR(20) NOT NULL,isTaken ENUM('Alindi','Alinmadi') DEFAULT 'Alinmadi',whoAdded VARCHAR(20) NOT NULL) TABLESPACE `" + tablespace + "`")
        cursor.execute("CREATE TABLE categories(id INT AUTO_INCREMENT PRIMARY KEY,categoryName VARCHAR(20) NOT NULL,whoAdded VARCHAR(20) NOT NULL) TABLESPACE `" + tablespace + "`")
        cursor.execute("CREATE TABLE loans(id INT AUTO_INCREMENT PRIMARY KEY,studentID INT NOT NULL,bookID INT NOT NULL,borrowDate DATE DEFAULT (CURRENT_DATE),returnDate VARCHAR(20) NOT NULL,returnedAt VARCHAR(20) DEFAULT 'Kitap Geri Gelmedi',loanStatus ENUM('returned','not returned') DEFAULT 'not returned',whoAdded VARCHAR(20) NOT NULL) TABLESPACE `" + tablespace + "`")
        cursor.execute("CREATE TABLE importantValues(id INT AUTO_INCREMENT PRIMARY KEY,situationValue TEXT NOT NULL, valueStatus BOOLEAN NOT NULL) TABLESPACE `" + tablespace + "`")

        hashed_admin_pass = bcrypt.hashpw(adminPassword.encode(), bcrypt.gensalt()).decode("utf-8")
        cursor.execute("INSERT INTO users (userName,userPassword,userRole) VALUES (%s,%s,%s)", ("admin admin", hashed_admin_pass, "admin"))

        cursor.execute("INSERT INTO importantValues (situationValue,valueStatus) VALUES ('App Is Locked',FALSE)")

        db_user = f"admin_{name}"
        cursor.execute(f"DROP USER IF EXISTS '{db_user}'@'127.0.0.1'")

        cursor.execute(f"CREATE USER '{db_user}'@'127.0.0.1' IDENTIFIED BY %s", (password,))

        cursor.execute(f"GRANT ALL PRIVILEGES ON `{name}`.* TO '{db_user}'@'127.0.0.1'")

        cursor.execute("FLUSH PRIVILEGES")

        cursor.execute("USE library")

        conn.commit()

        return {"success": True}

    except Exception as e:

        conn.rollback()
        writeLog(config.SETUPSQL_LOG_PATH, type(e).__name__, str(e))
        return {"success": False, "message": "Bir hata oluştu!"}