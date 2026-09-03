from utils.writeLog import writeLog
import config
from datetime import datetime

class Loan:

    def __init__(self,conn,cursor):
        
        self.conn = conn
        self.cursor = cursor
    
    def borrowBook(self,bookID:int,studentID:int,returnDate:str,activeUserName:str):

        try:

            if bookID <= 0 or studentID <= 0 or not returnDate.strip():
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            self.cursor.execute("SELECT * FROM books WHERE id = %s",(bookID,))
            result = self.cursor.fetchone()

            returnDate = returnDate.strip()

            try:
                parsed_date = datetime.strptime(returnDate, "%d/%m/%Y").date()
            except ValueError:
                return {"success": False, "message": "Lütfen geçerli bir tarih giriniz (GG/AA/YYYY)!"}
                
            if result is None:
                return {"success":False,"message":"Kitap bulunamadı!"}
            
            if result[6] == "Alındı":
                return {"success":False,"message":"Bu kitap zaten alınmış!"}
            
            if parsed_date < datetime.now().date():
                return {"success":False,"message":"Teslim tarihi geçmişe dönük olamaz, cihazın saatini ayarlayın!"}
                                    

            self.cursor.execute("INSERT INTO loans (studentID,bookID,returnDate,whoAdded) VALUES (%s,%s,%s,%s)",(studentID,bookID,returnDate,activeUserName))
            self.cursor.execute("UPDATE books SET isTaken = %s WHERE id = %s",("Alındı",bookID))
            self.conn.commit()
                                    
            return {"success":True,"message":"Kitap ödünç alındı."}
        
        except Exception as e:

            self.conn.rollback()
            writeLog(config.LOANS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    

    def returnBook(self,bookID:int):

        try:

            if bookID <= 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            self.cursor.execute("SELECT * FROM books WHERE id = %s",(bookID,))
            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"Kitap bulunamadı!"}
            
            if result[6] == "Alınmadı":
                return {"success":False,"message":"Bu kitap zaten ödünç alınmamış!"}
                    
            now = datetime.now().strftime("%d/%m/%Y")
            self.cursor.execute("UPDATE loans SET loanStatus = %s,returnedAt = %s WHERE bookID = %s",("Geri Getirildi",now,bookID))
            self.cursor.execute("UPDATE books SET isTaken = %s WHERE id = %s",("Alınmadı",bookID))
            self.conn.commit()
                        
            return {"success":True,"message":"Kitap geri verildi."}
        
        except Exception as e:

            self.conn.rollback()
            writeLog(config.LOANS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    

    def listLoans(self,filterValue:str,filterType:str,isWithFilter:bool,pageNumber:int,limit:int):

        try:

            filterList = ["id","bookID","studentID","borrowDate","returnDate","returnedAt","loanStatus","whoAdded"]

            if limit <= 0 or pageNumber <= 0:
                return {"success":False,"message":"Lutfen boş bırakmayın!"}
            

            if limit > 10:
                return {"success":False,"message":"Sayfaya düşen satır sayısı en fazla 10 olabilir!"}
                
            
            loans = []
            self.cursor.execute("SELECT COUNT(*) FROM loans")
            totalLoans = self.cursor.fetchone()[0]

            if totalLoans is not None:
                pageCount = totalLoans // limit
                if totalLoans % limit != 0:
                    pageCount += 1

            offset = ((pageNumber - 1) * limit)

            def add(rV):
                loans.append({"ID":rV[0],"studentID":rV[1],"bookID":rV[2],"borrowDate":rV[3],"returnDate":rV[4],"returnedAt":rV[5],"status":rV[6],"whoAdded":rV[7]})
                            
            if isWithFilter == True:

                if not filterValue.strip() or not filterType.strip():
                    return {"success":False,"message":"Lütfen boş bırakmayın!"}
                    
                if filterType != "id" and filterType != "studentID" and filterType != "bookID":
                    if len(filterValue.strip()) < 2:
                        return {"success":False,"message":"Arama en az 2 karakter olmalıdır!"}

                if filterType not in filterList:
                    return {"success":False,"message":"Lütfen geçerli parametre giriniz!"}
                        
                                    
                if filterType != "id" and filterType != "studentID" and filterType != "bookID":
                    newFilterValue = f"%{filterValue.strip()}%"
                    self.cursor.execute(f"SELECT COUNT(*) FROM loans WHERE {filterType} LIKE %s", (newFilterValue,))
                    totalLoans = self.cursor.fetchone()[0]

                    if totalLoans is not None:
                        pageCount = totalLoans // limit
                        if totalLoans % limit != 0:
                            pageCount += 1

                    self.cursor.execute(f"SELECT * FROM loans WHERE {filterType} LIKE %s LIMIT %s OFFSET %s", (newFilterValue,limit, offset))
                    result = self.cursor.fetchall()
                                    
                else:

                    self.cursor.execute(f"SELECT COUNT(*) FROM loans WHERE {filterType} = %s", (int(filterValue),))
                    totalLoans = self.cursor.fetchone()[0]

                    if totalLoans is not None:
                        pageCount = totalLoans // limit
                        if totalLoans % limit != 0:
                            pageCount += 1

                    self.cursor.execute(f"SELECT * FROM loans WHERE {filterType} = %s LIMIT %s OFFSET %s", (int(filterValue),limit, offset))
                    result = self.cursor.fetchall()
                                                                          
            else:

                self.cursor.execute("SELECT * FROM loans LIMIT %s OFFSET %s", (limit, offset))
                result = self.cursor.fetchall()

            if result:

                for r2 in result:
                    add(rV=r2)
                        
            if len(loans) == 0:
                return {"success":False,"message":"Sonuç bulunamadı!"}
                    
            return {
                "success":True,
                "message":f"Ödünç alım kayıtları listelendi.",
                "data":{
                    "totalLoans":totalLoans,
                    "loans":loans,
                    "pageCount":pageCount
                }
            }

                    

        except Exception as e:
            
            writeLog(config.LOANS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}

    def updateLoan(self,id:int,bookID:int,studentID:int,returnDate:str,activeUserName:str):

        try:

            if bookID <= 0 or studentID <= 0 or not returnDate.strip() or id <= 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            self.cursor.execute("SELECT * FROM loans WHERE id = %s",(id,))
            result1 = self.cursor.fetchone()

            if result1 is None:
                return {"success":False,"message":"Ödünç alma kaydı bulunamadı!"}
            
            self.cursor.execute("SELECT * FROM books WHERE id = %s",(bookID,))
            result = self.cursor.fetchone()

            returnDate = returnDate.strip()

            try:
                parsed_date = datetime.strptime(returnDate, "%d/%m/%Y").date()
            except ValueError:
                return {"success": False, "message": "Lütfen geçerli bir tarih giriniz (GG/AA/YYYY)!"}
                    
            if result is None:
                return {"success":False,"message":"Kitap bulunamadı!"}
            
            if result[6] == "Alındı":
                return {"success":False,"message":"Bu kitap zaten alınmış!"}
                        
            if parsed_date < datetime.now().date():
                return {"success":False,"message":"Teslim tarihi geçmişe dönük olamaz, cihazın saatini ayarlayın!"}
                                        
            self.cursor.execute("SELECT * FROM loans WHERE id = %s",(id,))
            result = self.cursor.fetchone()

            if result1[2] != bookID:
                self.cursor.execute("UPDATE books SET isTaken = %s WHERE id = %s",("Alınmadı",result1[2]))
                self.cursor.execute("UPDATE books SET isTaken = %s WHERE id = %s",("Alındı",bookID))
                self.conn.commit()

            self.cursor.execute("UPDATE loans SET studentID = %s, bookID = %s, returnDate = %s, whoAdded = %s WHERE id = %s",(studentID,bookID,returnDate,activeUserName,id))
            self.conn.commit()
                                            
            return {"success":True,"message":"Ödünç Alım Güncellendi."}
        
        except Exception as e:

            self.conn.rollback()
            writeLog(config.LOANS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}