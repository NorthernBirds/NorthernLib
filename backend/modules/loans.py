from utils.writeLog import writeLog
import config
from datetime import datetime

class Loan:

    def __init__(self,conn,cursor):
        
        self.conn = conn
        self.cursor = cursor
    
    def borrowBook(self,bookID,studentID,returnDate,activeUserName):

        try:

            if bookID == 0 or studentID == 0 or returnDate == "":
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            else:

                self.cursor.execute("SELECT * FROM books WHERE id = %s",(bookID,))
                result = self.cursor.fetchone()
                
                if result is None:
                    return {"success":False,"message":"Kitap bulunamadı!"}
                else:

                    if result[6] == True:
                        return {"success":False,"message":"Bu kitap zaten alınmış!"}
                    else:

                        self.cursor.execute("INSERT INTO loans (studentID,bookID,returnDate,whoAdded) VALUES (%s,%s,%s,%s)",(studentID,bookID,returnDate,activeUserName))
                        self.conn.commit()
                        self.cursor.execute("UPDATE books SET isTaken = %s WHERE id = %s",(True,bookID))
                        self.conn.commit()
                        return {"success":True,"message":"Kitap ödünç alındı."}
        
        except Exception as e:

            writeLog(config.LOANS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    

    def returnBook(self,bookID):

        try:

            if bookID == 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            else:

                self.cursor.execute("SELECT * FROM books WHERE id = %s",(bookID,))
                result = self.cursor.fetchone()

                if result is None:
                    return {"success":False,"message":"Kitap bulunamadı!"}
                else:

                    if result[6] == False:
                        return {"success":False,"message":"Bu kitap zaten ödünç alınmamış!"}
                    else:

                        self.cursor.execute("UPDATE loans SET loanStatus = %s,returnedAt = %s WHERE bookID = %s",("returned",datetime.now().strftime("%d/%m/%Y"),bookID))
                        self.conn.commit()
                        self.cursor.execute("UPDATE books SET isTaken = %s WHERE id = %s",(False,bookID))
                        self.conn.commit()
                        return {"success":True,"message":"Kitap geri verildi."}
        
        except Exception as e:

            writeLog(config.LOANS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    
    def listLoans(self,filterValue,filterType,isWithFilter):

        try:

            sendData = True
            IDs,studentIDs,bookIDs,borrowDates,returnDates,returnedAts,statuses,whoAddeds = [],[],[],[],[],[],[],[]

            def add(rV):
                IDs.append(rV[0])
                studentIDs.append(rV[1])

                self.cursor.execute("SELECT * FROM books WHERE id = %s",(rV[2],))
                result = self.cursor.fetchone()
                bookIDs.append(result)

                borrowDates.append(rV[3])
                returnDates.append(rV[4])
                returnedAts.append(rV[5])
                statuses.append(rV[6])
                whoAddeds.append(rV[7])

            if isWithFilter == True:

                if filterValue == "" or filterType == "":
                    return {"success":False,"message":"Lütfen boş bırakmayın!"}
                else:

                    if len(filterValue.strip()) < 2:
                        return {"success":False,"message":"Arama en az 2 karakter olmalıdır!"}

                    self.cursor.execute("SELECT * FROM loans")
                    result = self.cursor.fetchall()

                    if not result:
                        pass
                    else:
                        
                        for r in result:

                            for i,j in zip(
                                range(0,8),
                                ["id","studentID","bookID","borrowDate","returnDate","returnedAt","status","whoAddeds"]
                            ):

                                if filterType == j:

                                    parsed_name = str(r[i]).lower()

                                    if filterValue.lower() in parsed_name:
                                        add(rV=r)
                                
            elif isWithFilter == False:

                self.cursor.execute("SELECT * FROM loans")
                result2 = self.cursor.fetchall()

                if not result2:
                    pass
                else:
                    for r2 in result2:
                        add(rV=r2)
            
            else:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            if sendData == True:
                if len(IDs) == 0:
                    return {"success":False,"message":"Sonuç bulunamadı!"}
                else:

                    return {
                        "success":True,
                        "data":{
                            "ids":IDs,
                            "studentIDs":studentIDs,
                            "bookIDs":bookIDs,
                            "borrowDates":borrowDates,
                            "returnDates":returnDates,
                            "returnedAts":returnedAts,
                            "statuses":statuses,
                            "whoAddeds":whoAddeds
                        }
                    }
            else:
                pass
                    

        except Exception as e:
            
            writeLog(config.LOANS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}



        
    

