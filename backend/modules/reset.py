import config
from utils.writeLog import writeLog


class Reset:

    def __init__(self,conn,cursor):
        
        self.conn = conn
        self.cursor = cursor

    def reset(self,books:bool,categories:bool,loans:bool,users:bool):

        try:

            if books == True:
                self.cursor.execute("TRUNCATE TABLE books")
            
            if categories == True:
                self.cursor.execute("TRUNCATE TABLE categories")
            
            if loans == True:
                self.cursor.execute("TRUNCATE TABLE loans")
            
            if users == True:
                self.cursor.execute("DELETE FROM users WHERE userRole = 'student_staff' OR userRole = 'teacher'")

            self.conn.commit()
            
            return {"success":True,"message":"Sıfırlandı."}
        
        except Exception as e:

            self.conn.rollback()
            writeLog(config.RESET_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}

        
        