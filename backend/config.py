import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

CONNECTION_LOG_PATH = os.path.join(BASE_DIR,"logs", "connection.log")
USERS_LOG_PATH = os.path.join(BASE_DIR,"logs", "users.log")
AUTH_LOG_PATH = os.path.join(BASE_DIR,"logs", "auth.log")
BOOKS_LOG_PATH = os.path.join(BASE_DIR,"logs", "books.log")
CATEGORIES_LOG_PATH = os.path.join(BASE_DIR,"logs", "categories.log")
LOANS_LOG_PATH = os.path.join(BASE_DIR,"logs", "loans.log")
BACKEND_LOG_PATH = os.path.join(BASE_DIR, "logs", "backend.log")
RESET_LOG_PATH = os.path.join(BASE_DIR,"logs", "reset.log")
SETUPSQL_LOG_PATH = os.path.join(BASE_DIR,"logs", "setupSQL.log")

BOOK_CATEGORIES = ["Roman","Hikaye","Şiir","Biyografi","Otobiyografi","Tarih","Bilim","Kişisel Gelişim","Ders Kitabı","Ansiklopedi","Çizgi Roman"]

CONFIG_JSON_PATH_FOR_SENDEMAIL = os.path.join(BASE_DIR,"db", "config.json")

CERTIFICATE = "LibrarySystem.pem"
KEY = "LibrarySystem.key"
