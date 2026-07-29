import config
from utils.writeLog import writeLog


class Leader:

    def __init__(self, conn, cursor):
        self.conn = conn
        self.cursor = cursor

    def listLeaders(self, pageNumber:int, limit:int):

        try:
            
            self.cursor.execute("SELECT COUNT(DISTINCT studentID) FROM loans WHERE status = 'returned';")
            totalLeaders = self.cursor.fetchone()[0]
            
            if totalLeaders is not None:
                pageCount = totalLeaders // limit
                if totalLeaders % limit != 0:
                    pageCount += 1
                offset = ((pageNumber - 1) * limit)

            self.cursor.execute("SELECT studentID, COUNT(*) AS readBooks FROM loans WHERE loanStatus = 'returned' GROUP BY studentID ORDER BY readBooks DESC LIMIT %s OFFSET %s;", (limit, offset))
            result = self.cursor.fetchall()
                
            if result:
                studentIDs, readBooks = [], []
                for r in result:
                    studentIDs.append(r[0])
                    readBooks.append(r[1])
                
                
                return {"success": True, "message": f"{totalLeaders} lider kaydından yalnızca {offset + 1} - {(offset + limit) + 1} arası liderler listeleniyor.", "data": {"studentIDs": studentIDs, "readBooks": readBooks, "pageCount": pageCount}}

            else:

                return {"success": False, "message": "Sonuç bulunamadı!"}
            
        except Exception as e:

            writeLog(config.LEADERS_LOG_PATH, type(e).__name__, str(e))
            return {"success": False, "message": "Bir hata oluştu!"}