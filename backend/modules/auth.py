import config
from utils.writeLog import writeLog
import bcrypt
import secrets
import random
import time
from utils.setupSQL import setup

def durationHeartbeat():

    while True:
        
        try:

            tokens = list(config.session.keys())
            
            for t in tokens:

                config.session[t]["duration"] += 1

                if config.session[t]["duration"] >= 3600:

                    config.session[t]["dbValues"]["conn"].close()
                    del config.session[t]

            time.sleep(1)
        
        except Exception as e:

            pass

def resetDuration(token:str):

    if token in config.session.keys():
        config.session[token]["duration"] = 0

class Auth:

    def __init__(self,conn,cursor):
        
        self.conn = conn
        self.cursor = cursor
    
    def signUp(self,dbName:str,license:str):

        try:
            
            if not dbName.strip() or not license.strip():
                return {"success":False,"message":"Lütfen boş bırakmayın!"}

            for i in ["'",'"',"*","/","\\","?","<",">","|",":"," "]:
                if i in dbName.strip():
                    return {"success":False,"message":"Kütüphane adı geçersiz karakter içeriyor!"}
                
            self.cursor.execute("SELECT * FROM libraries WHERE libName = %s",(dbName.strip(),))
            result = self.cursor.fetchone()

            if result is not None or dbName == config.db_name:
                return {"success":False,"message":"Bu kütüphane adı zaten var!"}
            
            self.cursor.execute("SELECT id,isActive FROM licenseKeys WHERE licenseKey = %s",(license.strip(),))
            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"Lisans anahtarı bulunamadı!"}

            if bool(result[1]) == False:
                return {"success":False,"message":"Lisans aktif değil veya süresi dolmuş!"}

            self.cursor.execute("SELECT libName FROM libraries WHERE licenseID = %s",(result[0],))
            result2 = self.cursor.fetchone()

            if result2:
                return {"success":False,"message":"Bu lisans anahtarı başka bir kütüphane tarafından kullanılıyor!"}

            dbPassword,adminPassword = "",""

            specialChars = ["!","+","/","?"]

            for i in range(7):
                r = random.choice(["upperCaseLetter","number","lowerCaseLetter"])
                if r == "upperCaseLetter":
                    dbPassword = dbPassword + chr(random.randint(65,90))
                    adminPassword = adminPassword + chr(random.randint(65,90))
                elif r == "lowerCaseLetter":
                    dbPassword = dbPassword + chr(random.randint(97,122))
                    adminPassword = adminPassword + chr(random.randint(97,122))
                else:
                    dbPassword = dbPassword + str(random.randint(0,9))
                    adminPassword = adminPassword + str(random.randint(0,9))

            dbPassword = dbPassword + random.choice(specialChars)
            adminPassword = adminPassword + random.choice(specialChars)

            result = setup(name=dbName.strip(),password=dbPassword,conn=self.conn,cursor=self.cursor,adminPassword=adminPassword,licenseID=result[0])
            if result["success"]:
                return {"success":True,"message":"Kayıt olundu.","data":{"dbPassword":dbPassword,"adminPassword":adminPassword}}

            return result
        
        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
            

    def signInDB(self,dbName:str,dbPassword:str):
        
        try:

            if not dbName.strip() or not dbPassword.strip():
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            self.cursor.execute("SELECT * FROM libraries WHERE libName = %s",(dbName.strip(),))
            result1 = self.cursor.fetchone()

            if result1 is None or dbName == config.db_name:
                return {"success":False,"message":"Bu kütüphane adı bulunamadı!"}

            self.cursor.execute("SELECT isActive FROM licenseKeys WHERE id = %s",(result1[3],))
            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"Lisans anahtarı bulunamadı!"}

            if bool(result[0]) == False:
                return {"success":False,"message":"Lisans aktif değil veya süresi dolmuş!"}

            passwordCorrect = bcrypt.checkpw(dbPassword.strip().encode(),result1[2].encode())

            if passwordCorrect != True:
                return {"success":False,"message":"Hatalı şifre!"}
            
            return {"success":True,"message":"Giriş yapıldı.","data":{"dbName":dbName.strip(),"dbPassword":dbPassword.strip()}}
        
        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}


    def signIn(self,userName:str,password:str):

        try:

            rolesDict = {
                "Öğretmen":"teacher",
                "Öğrenci":"student_staff",
                "admin":"admin"
            }

            if not userName.strip() or not password.strip():
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            self.cursor.execute("SELECT * FROM users WHERE userName = %s",(userName.strip(),))
            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"Hatalı kullanıcı adı!"}

            passwordCorrect = bcrypt.checkpw(password.strip().encode(),result[2].encode())

            if passwordCorrect != True:
                return {"success":False,"message":"Hatalı şifre!"}
            
            token = secrets.token_hex(32)
                    
            return {
                "success":True,
                "message":"Giriş yapıldı.",
                "token":token,
                "userName":result[1],
                "role":rolesDict[result[3]]
            }

        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
        
    
    def signOut(self,token:str):
        
        try:

            if token in config.session.keys():
                
                config.session[token]["dbValues"]["conn"].close()
                del config.session[token]
                return {"success":True,"message":"Çıkış yapıldı."}
    
            return {"success":False,"message":"Hatalı kullanıcı verisi!"}
        
        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    
    def lockTheApp(self):

        try:

            self.cursor.execute("UPDATE importantvalues SET valueStatus = %s WHERE id = 1",(True,))
            self.conn.commit()

        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}

    def verifyUserToken(self,token:str):

        try: 

            if token not in config.session:
                return {"success":False,"realMessage":"401 Unauthorized!","message":"Oturumunuz zaman aşımına uğradı. Lütfen tekrar giriş yapın."}
        
            return {"success":True}

        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}

    def verifyAppToken(self,appToken:str,withLock:bool):

        try:

            if appToken != config.APP_KEY:
                if withLock:
                    self.lockTheApp()
                return {"success":False,"realMessage":"403 Forbidden!","message":"Hatalı uygulama anahtarı!"}
            
            return {"success":True}
        
        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    
    def verifyLock(self):

        try:

            self.conn.commit()
            self.cursor.execute("SELECT * FROM importantvalues WHERE id = 1")
            result = self.cursor.fetchone()
            if bool(result[2]):
                return {"success":False,"message":"Bu ktütüphane kilitli. Lütfen yönetici ile iletişime geçin."}
            
            return {"success":True}
        
        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}




            
                
    
            


    
