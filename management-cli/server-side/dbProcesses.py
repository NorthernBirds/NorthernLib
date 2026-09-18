import pymysql
import config
import random
from writeLog import writeLog

def connect():

    try:

        conn = pymysql.connect(host="127.0.0.1",password=config.password,database=config.dbName,user=config.userName)

        return {"success":True,"data":{"conn":conn}}

    except Exception as e:

        writeLog(config.dbProcessesLogPath,error=type(e).__name__,message=e)
        return {"success":False,"message":"Bir hata oluştu!"}
    
class Process:

    def __init__(self,conn:pymysql.connect):

        self.conn = conn
        self.cursor = conn.cursor()

    def listLibs(self):

        try:

            libraries = []

            self.cursor.execute("SELECT * FROM libraries")
            result = self.cursor.fetchall()

            if not result:
                return {"success":False,"message":"Sonuç bulunamadı!"}

            for r in result:
                libraries.append({"id":r[0],"libName":r[1],"libPass":r[2],"licenseID":r[3]})

            return {"success":True,"data":libraries}

        except Exception as e:
            writeLog(config.dbProcessesLogPath,error=type(e).__name__,message=e)
            return {"success":False,"message":"Bir hata oluştu!"}

    def terminateLib(self,lid:int):

        try:

            if lid <= 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}

            self.cursor.execute("SELECT libName,licenseID FROM libraries WHERE id = %s",(lid,))
            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"Kütüphane bulunamadı!"}

            userName = "admin_" + result[0]

            self.cursor.execute("DELETE FROM libraries WHERE id = %s",(lid,))
            self.cursor.execute("SELECT id FROM information_schema.processlist WHERE USER = %s",(userName,))
            result1 = self.cursor.fetchall()

            if result1:
                for r in result1:
                    self.cursor.execute(f"KILL {r[0]}")

            self.cursor.execute(f"DROP DATABASE IF EXISTS {result[0]}")
            self.cursor.execute(f"DROP TABLESPACE tablespace_{result[0]}")
            self.cursor.execute(f"DROP USER IF EXISTS {userName}@'127.0.0.1'")

            self.cursor.execute("UPDATE licenseKeys SET isActive = %s WHERE id = %s",(False,result[1]))
            self.conn.commit()

            return {"success":True}

        except Exception as e:
            writeLog(config.dbProcessesLogPath,error=type(e).__name__,message=e)
            self.conn.rollback()
            return {"success":False,"message":"Bir hata oluştu!"}

    def addLicense(self,count:int):

        try:

            if count <= 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}

            for c in range(count):
                newLicenseKey = ""

                for i in range(32):
                    r = random.choice(["upperCaseLetter","number","lowerCaseLetter"])
                    if r == "upperCaseLetter":
                        newLicenseKey = newLicenseKey + chr(random.randint(65,90))
                    elif r == "lowerCaseLetter":
                        newLicenseKey = newLicenseKey + chr(random.randint(97,122))
                    else:
                        newLicenseKey = newLicenseKey + str(random.randint(0,9))
                
                self.cursor.execute("INSERT INTO licenseKeys (licenseKey) VALUES (%s)",(newLicenseKey,))
                self.conn.commit()

            return {"success":True}

        except Exception as e:
            writeLog(config.dbProcessesLogPath,error=type(e).__name__,message=e)
            self.conn.rollback()
            return {"success":False,"message":"Bir hata oluştu!"}

    def activateLicense(self,lcid:int):

        try:

            if lcid <= 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}

            self.cursor.execute("SELECT isActive FROM licenseKeys WHERE id = %s",(lcid,))
            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"Lisans bulunamadı!"}

            if bool(result[0]):
                return {"success":False,"message":"Bu lisans zaten aktif!"}

            self.cursor.execute("UPDATE licenseKeys SET isActive = %s WHERE id = %s",(True,lcid))
            self.conn.commit()

            return {"success":True}

        except Exception as e:
            writeLog(config.dbProcessesLogPath,error=type(e).__name__,message=e)
            self.conn.rollback()
            return {"success":False,"message":"Bir hata oluştu!"}

    def disableLicense(self,lcid:int):

        try:

            if lcid <= 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}

            self.cursor.execute("SELECT isActive FROM licenseKeys WHERE id = %s",(lcid,))
            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"Lisans bulunamadı!"}

            if bool(result[0]) == False:
                return {"success":False,"message":"Bu lisans zaten aktif değil!"}

            self.cursor.execute("UPDATE licenseKeys SET isActive = %s WHERE id = %s",(False,lcid))
            self.conn.commit()

            return {"success":True}

        except Exception as e:
            writeLog(config.dbProcessesLogPath,error=type(e).__name__,message=e)
            self.conn.rollback()
            return {"success":False,"message":"Bir hata oluştu!"}

    def listLicenses(self):

        try:

            licenses = []

            self.cursor.execute("SELECT * FROM licenseKeys")
            result = self.cursor.fetchall()

            if not result:
                return {"success":False,"message":"Sonuç bulunamadı!"}

            for r in result:
                licenses.append({"id":r[0],"licenseKey":r[1],"isActive":"Aktif" if r[2] else "Pasif"})

            return {"success":True,"data":licenses}

        except Exception as e:
            writeLog(config.dbProcessesLogPath,error=type(e).__name__,message=e)
            return {"success":False,"message":"Bir hata oluştu!"}
    
    def giveUserData(self,userName:str):

        try:

            self.cursor.execute("SELECT id,userPassword FROM users WHERE userName = %s",(userName,))
            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"Kullanıcı bulunamadı!"}

            return {"success":True,"data":result}

        except Exception as e:
            writeLog(config.dbProcessesLogPath,error=type(e).__name__,message=e)
            return {"success":False,"message":"Bir hata oluştu!"}

    def addSession(self,userID:int,token:str):

        try:

            self.cursor.execute("INSERT INTO sessions (userID,token) VALUES (%s,%s)",(userID,token))
            self.conn.commit()

            return {"success":True}

        except Exception as e:
            writeLog(config.dbProcessesLogPath,error=type(e).__name__,message=e)
            self.conn.rollback()
            return {"success":False,"message":"Bir hata oluştu!"}

    def verifyUserTokenDB(self,token:str):

        try:

            if token.replace(" ","") == "":
                return {"success":False,"message":"401 Unauthorized!"}

            self.cursor.execute("SELECT id FROM sessions WHERE token = %s",(token,))
            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"401 Unauthorized!"}

            return {"success":True}

        except Exception as e:
            writeLog(config.dbProcessesLogPath,error=type(e).__name__,message=e)
            return {"success":False,"message":"Bir hata oluştu!"}

    def giveUserRoleByToken(self,token:str):

        try:

            self.cursor.execute("SELECT userID FROM sessions WHERE token = %s",(token,))
            result = self.cursor.fetchone()

            self.cursor.execute("SELECT userRole FROM users WHERE id = %s",(result[0]))
            result = self.cursor.fetchone()

            return {"success":True,"data":{"role":result[0]}}

        except Exception as e:
            writeLog(config.dbProcessesLogPath,error=type(e).__name__,message=e)
            return {"success":False,"message":"Bir hata oluştu!"}

    def deleteSession(self,token):

        try:

            self.cursor.execute("SELECT id FROM sessions WHERE token = %s",(token,))
            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"Oturum bulunamadı!"}

            self.cursor.execute("DELETE FROM sessions WHERE token = %s",(token,))
            self.conn.commit()

            return {"success":True}

        except Exception as e:
            writeLog(config.dbProcessesLogPath,error=type(e).__name__,message=e)
            self.conn.rollback()
            return {"success":False,"message":"Bir hata oluştu!"}

    def listProcesses(self):

        try:

            processes = []

            self.cursor.execute("SELECT * FROM information_schema.processlist WHERE USER != 'event_scheduler'")
            result = self.cursor.fetchall()

            if not result:
                return {"success":False,"message":"Sonuç bulunamadı!"}

            for r in result:
                processes.append({"id":r[0],"userName":r[1],"host":r[2],"db":r[3],"command":r[4],"time":r[5],"state":r[6],"info":r[7]})

            return {"success":True,"data":processes}

        except Exception as e:
            writeLog(config.dbProcessesLogPath,error=type(e).__name__,message=e)
            self.conn.rollback()
            return {"success":False,"message":"Bir hata oluştu!"}

    def killProcess(self,pid):

        try:

            self.cursor.execute("SELECT ID FROM information_schema.processlist WHERE ID = %s and WHERE USER != 'event_scheduler'",(pid,))
            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"Bu PID'ye ait işlem bulunamadı!"}

            self.cursor.execute(f"KILL {pid}")
            self.conn.commit()

            return {"success":True}

        except Exception as e:
            writeLog(config.dbProcessesLogPath,error=type(e).__name__,message=e)
            self.conn.rollback()
            return {"success":False,"message":"Bir hata oluştu!"}

    def signOut(self,token:str):

        try:

            self.cursor.execute("DELETE FROM sessions WHERE token = %s",(token,))
            self.conn.commit()

            return {"success":True}

        except Exception as e:
            writeLog(config.dbProcessesLogPath,error=type(e).__name__,message=e)
            self.conn.rollback()
            return {"success":False,"message":"Bir hata oluştu!"}
                    



            
        


    
        
            

