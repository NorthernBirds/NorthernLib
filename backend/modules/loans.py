from utils.writeLog import writeLog
import config
from datetime import datetime


class Loan:

    def __init__(self,conn,cursor):
        
        self.conn = conn
        self.cursor = cursor
    
    def borrowBook(self,bookID:int,studentID:int,returnDate:str,activeUserName:str):

        try:

            if bookID == 0 or studentID == 0 or returnDate == "":
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            else:

                self.cursor.execute("SELECT * FROM books WHERE id = %s",(bookID,))
                result = self.cursor.fetchone()
                
                if result is None:
                    return {"success":False,"message":"Kitap bulunamadı!"}
                else:

                    if result[6] == "Alındı":
                        return {"success":False,"message":"Bu kitap zaten alınmış!"}
                    else:

                        if datetime.strptime(returnDate, "%d/%m/%Y").date() < datetime.now().date():
                            return {"success":False,"message":"Teslim tarihi geçmişe dönük olamaz, cihazın saatini ayarlayın!"}
                        else:

                            self.cursor.execute("INSERT INTO loans (studentID,bookID,returnDate,whoAdded) VALUES (%s,%s,%s,%s)",(studentID,bookID,returnDate,activeUserName))
                            self.conn.commit()
                            self.cursor.execute("UPDATE books SET isTaken = %s WHERE id = %s",("Alındı",bookID))
                            self.conn.commit()
                            
                            return {"success":True,"message":"Kitap ödünç alındı."}
        
        except Exception as e:

            writeLog(config.LOANS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    

    def returnBook(self,bookID:int):

        try:

            if bookID == 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            else:

                self.cursor.execute("SELECT * FROM books WHERE id = %s",(bookID,))
                result = self.cursor.fetchone()

                if result is None:
                    return {"success":False,"message":"Kitap bulunamadı!"}
                else:

                    if result[6] == "Alınmadı":
                        return {"success":False,"message":"Bu kitap zaten ödünç alınmamış!"}
                    else:

                        now = datetime.now().strftime("%d/%m/%Y")
                        self.cursor.execute("UPDATE loans SET loanStatus = %s,returnedAt = %s WHERE bookID = %s",("returned",now,bookID))
                        self.conn.commit()
                        self.cursor.execute("UPDATE books SET isTaken = %s WHERE id = %s",("Alınmadı",bookID))
                        self.conn.commit()
                        
                        return {"success":True,"message":"Kitap geri verildi."}
        except Exception as e:

            writeLog(config.LOANS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    

    def listLoans(self,filterValue:str,filterType:str,isWithFilter:bool | str,pageNumber:int,limit:int):

        try:

            filterList = ["id","bookID","studentID","borrowDate","returnDate","returnedAt","loanStatus","whoAdded"]

            if limit == 0:
                return {"success":False,"message":"Lutfen boş bırakmayın!"}
            else:

                if limit > 50:
                    return {"success":False,"message":"Limit en fazla 50 olabilir!"}
                else:
            
                        IDs,studentIDs,bookNames,borrowDates,returnDates,returnedAts,statuses,whoAddeds = [],[],[],[],[],[],[],[]
                        self.cursor.execute("SELECT COUNT(*) FROM loans")
                        totalLoans = self.cursor.fetchone()[0]
                        if totalLoans is not None:
                            pageCount = totalLoans // limit
                            if totalLoans % limit != 0:
                                pageCount += 1
                            offset = ((pageNumber - 1) * limit)

                        def add(rV):
                            IDs.append(rV[0])
                            studentIDs.append(rV[1])

                            self.cursor.execute("SELECT bookName FROM books WHERE id = %s",(rV[2],))
                            result = self.cursor.fetchone()
                            
                            if result:
                                bookNames.append(result[0])
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

                                if filterType not in filterList:
                                    return {"success":False,"message":"Lütfen geçerli parametre giriniz!"}
                                else:
                                    
                                    if filterType != "id" and filterType != "studentID" and filterType != "bookID":
                                        newFilterValue = f"%{filterValue}%"
                                        self.cursor.execute(f"SELECT COUNT(*) FROM loans WHERE {filterType} LIKE %s", (newFilterValue,))
                                        totalLoans = self.cursor.fetchone()[0]
                                        pageCount = totalLoans // limit
                                        if totalLoans % limit != 0:
                                            pageCount += 1

                                        self.cursor.execute(f"SELECT * FROM loans WHERE {filterType} LIKE %s LIMIT %s OFFSET %s", (newFilterValue,limit, offset))
                                        result = self.cursor.fetchall()
                                    else:
                                    
                                        self.cursor.execute(f"SELECT COUNT(*) FROM loans WHERE {filterType} = %s", (int(filterValue),))
                                        totalLoans = self.cursor.fetchone()[0]
                                        pageCount = totalLoans // limit
                                        if totalLoans % limit != 0:
                                            pageCount += 1

                                        self.cursor.execute(f"SELECT * FROM loans WHERE {filterType} = %s LIMIT %s OFFSET %s", (int(filterValue),limit, offset))
                                        result = self.cursor.fetchall()

                                if not result:
                                    pass
                                else:
                                    
                                    for r in result:

                                        add(rV=r)
                                                        
                                            
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
                                "message":f"{totalLoans} ödünç alma kaydından yalnızca {offset + 1} - {(offset + limit) + 1} arası ödünç alma işlemleri listeleniyor.",
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