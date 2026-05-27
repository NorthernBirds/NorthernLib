import pymysql
from utils.writeLog import writeLog
import config
import base64
import json

def getDB():

    try:

        with open("config.json","r") as DB_DATA:
            data = json.load(DB_DATA)

        db_host = base64.b64decode(data["DB_HOST"]).decode("utf-8")
        db_name = base64.b64decode(data["DB_NAME"]).decode("utf-8")
        db_user = base64.b64decode(data["DB_USER"]).decode("utf-8")
        db_password = base64.b64decode(data["DB_PASSWORD"]).decode("utf-8")

        conn = pymysql.connect(host=db_host,database=db_name,user=db_user,password=db_password,charset="utf8mb4")
        cursor = conn.cursor()
        cursor.execute("SET SQL_SAFE_UPDATES = 0")
        conn.commit()
        return cursor, conn
    
    except Exception as e:

        writeLog(config.CONNECTION_LOG_PATH,type(e).__name__,str(e))
        return None,None


def closeConnection(conn):

    try:
        
        conn.close()
    
    except Exception as e:

        writeLog(config.CONNECTION_LOG_PATH,type(e).__name__,str(e))
        return None,None