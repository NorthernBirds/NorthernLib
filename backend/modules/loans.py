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
    

    def listLoans(self,filterValue,filterType,isWithFilter,pageNumber,limit):

        try:

            IDs,studentIDs,bookNames,borrowDates,returnDates,returnedAts,statuses,whoAddeds = [],[],[],[],[],[],[],[]
            self.cursor.execute("SELECT COUNT(*) FROM loans")
            totalLoans = self.cursor.fetchone()[0]
            if totalLoans is not None:
                pageCount = totalLoans // limit
                if totalLoans % limit != 0:
                    pageCount += 1
                offset = ((pageNumber - 1) * limit) + 1

            def add(rV):
                IDs.append(rV[0])
                studentIDs.append(rV[1])

                self.cursor.execute("SELECT bookName FROM books WHERE id = %s",(rV[2],))
                result = self.cursor.fetchone()
                
                if result:
                    bookNames.append(result[1])
                else:
                    bookNames.append("Bilinmeyen Kitap")

                borrowDates.append(rV[3])
                returnDates.append(rV[4])
                returnedAts.append(rV[5])
                statuses.append(rV[6])
                whoAddeds.append(rV[7])

            if isWithFilter == True:

                if filterValue == "" or filterType == "":
                    return {"success":False,"message":"Lütfen boş bırakmayın!"}
                else:

                    if filterType != "id" and filterType != "studentID" and filterType != "bookID":
                        if len(filterValue.strip()) < 2:
                            return {"success":False,"message":"Arama en az 2 karakter olmalıdır!"}

                    self.cursor.execute("SELECT * FROM loans LIMIT %s OFFSET %s", (limit, offset))
                    result = self.cursor.fetchall()

                    if not result:
                        pass
                    else:
                        
                        for r in result:

                            for i,j in zip(
                                range(0,8),
                                ["id","studentID","bookID","borrowDate","returnDate","returnedAt","status","whoAdded"]
                            ):

                                if filterType == j:

                                    parsed_name = str(r[i]).lower()
                                    if filterType == "id" or filterType == "studentID" or filterType == "bookID":
                                        if str(filterValue).lower() == parsed_name:
                                            add(rV=r)
                                            break
                                    else:
                                        if filterValue.lower() in parsed_name:
                                            add(rV=r)
                                            break
                                
            elif isWithFilter == False:

                self.cursor.execute("SELECT * FROM loans LIMIT %s OFFSET %s", (limit, offset))
                result2 = self.cursor.fetchall()

                if not result2:
                    pass
                else:
                    for r2 in result2:
                        add(rV=r2)
            
            else:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            if len(IDs) == 0:
                return {"success":False,"message":"Sonuç bulunamadı!"}
            else:

                return {
                    "success":True,
                    "message":f"{totalLoans} ödünç alma kaydından yalnızca {offset} - {(offset + limit) - 1} arası ödünç alma işlemleri listeleniyor.",
                    "data":{
                        "ids":IDs,
                        "studentIDs":studentIDs,
                        "bookNames":bookNames,
                        "borrowDates":borrowDates,
                        "returnDates":returnDates,
                        "returnedAts":returnedAts,
                        "statuses":statuses,
                        "whoAddeds":whoAddeds,
                        "pageCount":pageCount
                    }
                }

                    

        except Exception as e:
            
            writeLog(config.LOANS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}



        
    

