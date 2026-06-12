import os
import pymysql
from utils.writeLog import writeLog
import config

def getDB(dbUser,dbName,password):

    try:

        conn = pymysql.connect(host="127.0.0.1",database=dbName,user=dbUser,password=password,charset="utf8mb4")
        cursor = conn.cursor()
        cursor.execute("SET SQL_SAFE_UPDATES = 0")
        conn.commit()
        return {"success":True,"message":"Bağlantı kuruldu.","data":{"cursor":cursor,"conn":conn}}
    
    except Exception as e:

        writeLog(config.CONNECTION_LOG_PATH,type(e).__name__,str(e))
        return {"success":False,"message":"Bir hata oluştu!"}


def closeConnection(conn):

    try:
        
        conn.close()
        return {"success":True,"message":"Bağlantı kapatıldı."}
    
    except Exception as e:

        writeLog(config.CONNECTION_LOG_PATH,type(e).__name__,str(e))
        return {"success":False,"message":"Bir hata oluştu!"}