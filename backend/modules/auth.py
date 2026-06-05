import config
from utils.writeLog import writeLog,writeCriticalWarning
from utils.sendEMail import sendEMail
from utils.setupSQL import setup
import bcrypt
import secrets
from backend import session,APP_KEY
import random

class Auth:

    def __init__(self,conn,cursor):
        
        self.conn = conn
        self.cursor = cursor
    
    def signUp(self,dbName):

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

                if result is not None:
                    return {"success":False,"message":"Hatalı bu kütüphane adı zaten var!"}
                else:

                    dbPassword = ""
                    adminPassword = ""

                    for i in range(4):
                        dbPassword = dbPassword + str(random.randint(0,9)) + str(random.choice(letters))
                        adminPassword = adminPassword + str(random.randint(0,9)) + str(random.choice(letters))
                    
                    setup(name=dbName,password=bcrypt.hashpw(dbPassword.encode(),bcrypt.gensalt()).decode("utf-8"),conn=self.conn,cursor=self.cursor,adminPassword=bcrypt.hashpw(adminPassword.encode(),bcrypt.gensalt()).decode("utf-8"))
                    return {"success":True,"message":"Kayıt olundu.","data":{"dbPassword":dbPassword,"adminPassword":adminPassword}}
        
        
        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
            

    def signInDB(self,dbName,dbPassword):
        
        try:

            if dbName == "" or dbPassword == "":
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            else:
                self.cursor.execute("SELECT * FROM libraries WHERE libName = %s",(dbName,))

                result = self.cursor.fetchone()

                if result is None:
                    return {"success":False,"message":"Hatalı kütüphane adı!"}
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


    def signIn(self,userName,password):

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
        
    
    def signOut(self,token):
        
        try:

            if token in session.keys():
                del session[token]
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
            sendEMail(subject="403 Forbidden at library system.",message="A user attempted to breach the system using a tool similar to Postman.")
            writeCriticalWarning(config.AUTH_LOG_PATH,"403 Forbidden","A user attempted to breach the system using a tool similar to Postman.")

        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}

    def verifyUserToken(self,token):

        try: 

            if token not in session:
                return {"success":False,"message":"401 Unauthorized!"}
            else:

                return {"success":True}

        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}

    def verifyAppToken(self,appToken):

        try:

            if appToken != APP_KEY:
                self.lockTheApp()
                return {"success":False,"message":"403 Forbidden!"}
            else:
                return {"success":True}
        
        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    
    def verifyLock(self):

        try:

            self.cursor.execute("SELECT * FROM importantvalues WHERE id = 1")
            result = self.cursor.fetchone()
            if bool(result[2]) == True:
                return {"success":False,"message":"The app is locked!"}
            else:

                return {"success":True}
        
        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}




            
                
    
            


    
