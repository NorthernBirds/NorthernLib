import config
from utils.writeLog import writeLog
from processes import addProcess

class Reset:

    def __init__(self,conn,cursor):
        self.conn = conn
        self.cursor = cursor

    def reset(self,books,categories,loans,users,processes,activeUserName):

        try:

            if books == True:
                self.cursor.execute("TRUNCATE TABLE books")
                self.conn.commit()
            elif books == False:
                pass
            else:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            if categories == True:
                self.cursor.execute("TRUNCATE TABLE categories")
                self.conn.commit()
            elif categories == False:
                pass
            else:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            if loans == True:
                self.cursor.execute("TRUNCATE TABLE loans")
                self.conn.commit()
            elif loans == False:
                pass
            else:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            if users == True:
                self.cursor.execute("DELETE FROM users WHERE userRole = 'student_staff' OR userRole = 'teacher'")
                self.conn.commit()
            elif users == False:
                pass
            else:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}

            if processes == True:
                self.cursor.execute("TRUNCATE TABLE processes")
                self.conn.commit()
            elif processes == False:
                pass
            else:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            addProcess(userName=activeUserName,process=f"Kütüphane sistemi sıfırlandı. (books:{books}, categories:{categories}, loans:{loans}, users:{users}, processes:{processes})")
            return {"success":True,"message":"Sıfırlandı."}
        
        except Exception as e:

            writeLog(config.RESET_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}

        
        