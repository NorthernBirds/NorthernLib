import config
from utils.writeLog import writeLog

class Leader:

    def __init__(self,conn,cursor):
        self.conn = conn
        self.cursor = cursor

    def listLeaders(self,pageNumber):

        try:

            self.cursor.execute("SELECT studentID, COUNT(*) AS readBooks FROM loans WHERE status = 'returned' GROUP BY studentID ORDER BY readBooks DESC LIMIT %s OFFSET %s;", (10, (pageNumber - 1) * 10))
            result = self.cursor.fetchall()
                
            if result:
                studentIDs,readBooks = [],[]
                for r in result:
                    studentIDs.append(r[0])
                    readBooks.append(r[1])
                
                return {"success":True,"data":{"studentIDs":studentIDs,"readBooks":readBooks}}

            else:

                return {"success":False,"message":"Sonuç bulunamadı!"}
            
        except Exception as e:

            writeLog(config.LEADERS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
