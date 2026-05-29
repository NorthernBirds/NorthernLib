import config
from utils.writeLog import writeLog,writeCriticalWarning
from utils.sendEMail import sendEMail
import bcrypt
import secrets
from backend import session,APP_KEY

class Auth:

    def __init__(self,conn,cursor):
        
        self.conn = conn
        self.cursor = cursor

    
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
                return {"success":False,"message":"Hatalı kullanıcı adı veya şifre!"}
            else:

                passwordCorrect = bcrypt.checkpw(
                    password.encode(),
                    result[2].encode()
                )

                if passwordCorrect != True:
                    return {"success":False,"message":"Hatalı kullanıcı adı veya şifre!"}
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

            del session[token]
            return {"success":True,"message":"Çıkış yapıldı."}
        
        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    
    def lockTheApp(self):

        try:

            self.cursor.execute("UPDATE importantvalues SET valueStatus = %s WHERE id = 1",(True,))
            self.conn.commit()
            self.cursor.execute("UPDATE importantvalues SET valueStatus = %s WHERE id = 1",(True,))
            self.conn.commit()
            sendEMail(subject="403 Forbidden at library system.",message="A user attempted to breach the system using a tool similar to Postman.")
            writeCriticalWarning(config.AUTH_LOG_PATH,"403 Forbidden","A user attempted to breach the system using a tool similar to Postman.")

        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}

    def verifyToken(self,token,appToken):

        try:
            
            self.cursor.execute("SELECT * FROM importantvalues WHERE id = 1")
            result = self.cursor.fetchone()
            if bool(result[2]) == True:
                return {"success":False,"message":"The app is locked!"}
            else:
                
                if appToken != APP_KEY:
                    self.lockTheApp()
                    return {"success":False,"message":"403 Forbidden!"}
                else:

                    if token not in session:
                        return {"success":False,"message":"401 Unauthorized!"}
                    else:

                        return {"success":True}

        except Exception as e:

            writeLog(config.AUTH_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    
            


    
