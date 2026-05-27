import config
from utils.writeLog import writeLog

def reset(conn,cursor,books,categories,loans,users):

    try:

        if books == True:
            cursor.execute("TRUNCATE TABLE books")
            conn.commit()
        elif books == False:
            pass
        else:
            return {"success":False,"message":"Lütfen boş bırakmayın!"}
        
        if categories == True:
            cursor.execute("TRUNCATE TABLE categories")
            conn.commit()
        elif categories == False:
            pass
        else:
            return {"success":False,"message":"Lütfen boş bırakmayın!"}
        
        if loans == True:
            cursor.execute("TRUNCATE TABLE loans")
            conn.commit()
        elif loans == False:
            pass
        else:
            return {"success":False,"message":"Lütfen boş bırakmayın!"}
        
        if users == True:
            cursor.execute("DELETE FROM users WHERE userRole = 'student_staff' OR userRole = 'teacher'")
            conn.commit()
        elif users == False:
            pass
        else:
            return {"success":False,"message":"Lütfen boş bırakmayın!"}
        

        return {"success":True,"message":"Sıfırlandı."}
    
    except Exception as e:

        writeLog(config.RESET_LOG_PATH,type(e).__name__,str(e))
        return {"success":False,"message":"Bir hata oluştu!"}

        
        