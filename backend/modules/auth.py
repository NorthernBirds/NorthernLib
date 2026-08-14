import config
from utils.writeLog import writeLog,writeCriticalWarning
from utils.setupSQL import setup
import bcrypt
import secrets
import random
import time

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
    
    def signUp(self,dbName:str,developerPassword:str):

        try:

            letters = [
            "a", "A", "b", "B", "c", "C", "d", "D", "e", "E", 
            "f", "F", "g", "G", "h", "H", "i", "I", "j", "J", 
            "k", "K", "l", "L", "m", "M", "n", "N", "o", "O", 
            "p", "P", "q", "Q", "r", "R", "s", "S", "t", "T", 
            "u", "U", "v", "V", "w", "W", "x", "X", "y", "Y", 
            "z", "Z"
            ]


            if dbName.replace(" ","") == "":
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            self.cursor.execute("SELECT * FROM libraries WHERE libName = %s",(dbName,))
            result = self.cursor.fetchone()

            if result is not None or dbName == "library":
                return {"success":False,"message":"Bu kütüphane adı zaten var!"}
            
            if developerPassword != config.developer_password:
                return {"success":False,"message":"Hatalı yönetici şifresi!"}

            dbPassword = ""
            adminPassword = ""

            for i in range(4):
                dbPassword = dbPassword + str(random.randint(0,9)) + str(random.choice(letters))
                adminPassword = adminPassword + str(random.randint(0,9)) + str(random.choice(letters))
                            
            setup(name=dbName,password=dbPassword,conn=self.conn,cursor=self.cursor,adminPassword=adminPassword)
            return {"success":True,"message":"Kayıt olundu.","data":{"dbPassword":dbPassword,"adminPassword":adminPassword}}
        
        
        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
            

    def signInDB(self,dbName:str,dbPassword:str):
        
        try:

            if dbName.replace(" ","") == "" or dbPassword.replace(" ","") == "":
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            self.cursor.execute("SELECT * FROM libraries WHERE libName = %s",(dbName,))
            result = self.cursor.fetchone()

            if result is None or dbName == "library":
                return {"success":False,"message":"Bu kütüphane adı bulunamadı!"}

            passwordCorrect = bcrypt.checkpw(dbPassword.encode(),result[2].encode())

            if passwordCorrect != True:
                return {"success":False,"message":"Hatalı şifre!"}
            
            return {"success":True,"message":"Giriş yapıldı.","data":{"dbName":dbName,"dbPassword":dbPassword}}
        
        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}


    def signIn(self,userName:str,password:str):

        try:

            if userName.replace(" ","") == "" or password.replace(" ","") == "":
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            self.cursor.execute("SELECT id,userName,userPassword,userRole FROM users WHERE userName = %s",(userName,))
            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"Hatalı kullanıcı adı!"}

            passwordCorrect = bcrypt.checkpw(password.encode(),result[2].encode())

            if passwordCorrect != True:
                return {"success":False,"message":"Hatalı şifre!"}
            
            token = secrets.token_hex(32)
                    
            return {
                "success":True,
                "message":"Giriş yapıldı.",
                "token":token,
                "userName":result[1],
                "role":result[3]
            }

        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
        
    
    def signOut(self,token:str):
        
        try:

            if token in config.session.keys():
                
                config[token]["dbValues"]["conn"].close()
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
            if bool(result[2]) == True:
                return {"success":False,"message":"Bu ktütüphane kilitli. Lütfen yönetici ile iletişime geçin."}
            
            return {"success":True}
        
        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}




            
                
    
            


    
