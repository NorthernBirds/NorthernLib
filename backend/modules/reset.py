import backend.config
from backend.utils.writeLog import writeLog

class Reset:

    def __init__(self,conn,cursor):
        self.conn = conn
        self.cursor = cursor

def reset(self,books,categories,loans,users):

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
        

        return {"success":True,"message":"Sıfırlandı."}
    
    except Exception as e:

        writeLog(backend.config.RESET_LOG_PATH,type(e).__name__,str(e))
        return {"success":False,"message":"Bir hata oluştu!"}

        
        