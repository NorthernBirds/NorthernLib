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
                
                else:
                    pass

            time.sleep(1)
        
        except Exception as e:

            pass

def resetDuration(token:str):

    if token in config.session.keys():
        config.session[token]["duration"] = 0
    else:
        pass

class Auth:

    def __init__(self,conn,cursor):
        
        self.conn = conn
        self.cursor = cursor
    
    def signUp(self,dbName:str):

        try:

            letters = [
            "a", "A", "b", "B", "c", "C", "d", "D", "e", "E", 
            "f", "F", "g", "G", "h", "H", "i", "I", "j", "J", 
            "k", "K", "l", "L", "m", "M", "n", "N", "o", "O", 
            "p", "P", "q", "Q", "r", "R", "s", "S", "t", "T", 
            "u", "U", "v", "V", "w", "W", "x", "X", "y", "Y", 
            "z", "Z"
            ]


            if dbName == "":
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            else:

                self.cursor.execute("SELECT * FROM libraries WHERE libName = %s",(dbName,))

                result = self.cursor.fetchone()

                if result is not None or dbName == "adminlibrary":
                    return {"success":False,"message":"Bu kütüphane adı zaten var!"}
                else:

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

            if dbName == "" or dbPassword == "":
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            else:
                self.cursor.execute("SELECT * FROM libraries WHERE libName = %s",(dbName,))

                result = self.cursor.fetchone()

                if result is None or dbName == "adminlibrary":
                    return {"success":False,"message":"Bu kütüphane adı bulunamadı!"}
                else:

                    passwordCorrect = bcrypt.checkpw(
                        dbPassword.encode(),
                        result[2].encode()
                    )

                    if passwordCorrect != True:
                        return {"success":False,"message":"Hatalı şifre!"}
                    else:

                        return {"success":True,"message":"Giriş yapıldı.","data":{"dbName":dbName,"dbPassword":dbPassword}}
        
        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}


    def signIn(self,userName:str,password:str):

        try:

            if userName == "" or password == "":
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            else:

                self.cursor.execute(
                    "SELECT id,userName,userPassword,userRole FROM users WHERE userName = %s",
                    (userName,)
                )

            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"Hatalı kullanıcı adı!"}
            else:

                passwordCorrect = bcrypt.checkpw(
                    password.encode(),
                    result[2].encode()
                )

                if passwordCorrect != True:
                    return {"success":False,"message":"Hatalı şifre!"}
                else:

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
            else:

                return {"success":False,"message":"Lütfen boş bırakmayın!"}
        
        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    
    def lockTheApp(self):

        try:

            self.cursor.execute("UPDATE importantvalues SET valueStatus = %s WHERE id = 1",(True,))
            self.conn.commit()
            writeCriticalWarning(config.AUTH_LOG_PATH,"403 Forbidden","A user attempted to breach the system using a tool similar to Postman.")

        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}

    def verifyUserToken(self,token:str):

        try: 

            if token not in config.session:
                return {"success":False,"message":"401 Unauthorized!"}
            else:

                return {"success":True}

        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}

    def verifyAppToken(self,appToken:str,withLock:bool):

        try:

            if appToken != config.APP_KEY:
                if withLock == True:
                    self.lockTheApp()
                return {"success":False,"message":"403 Forbidden!"}
            else:
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
                return {"success":False,"message":"The app is locked!"}
            else:

                return {"success":True}
        
        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}




            
                
    
            


    
