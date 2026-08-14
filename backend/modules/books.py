import config
from utils.writeLog import writeLog


class Book:

    def __init__(self,conn,cursor):
        
        self.conn = conn
        self.cursor = cursor


    def addBook(self,bookName:str,writer:str,category:str,publisher:str,pageCount:int,activeUserName:str):

        try:

            if bookName.replace(" ","") == "" or writer.replace(" ","") == "" or publisher.replace(" ","") ==  "" or pageCount == 0 or pageCount < 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            self.cursor.execute("SELECT * FROM categories WHERE categoryName = %s",(category,))
            result = self.cursor.fetchone()
                
            if result is None:
                return {"success":False,"message":"Bu kategori mevcut değil!"}
                
            if len(bookName) > 50:
                return {"success":False,"message":"Kitap ismi 50 karakterden fazla olamaz!"}
                    
            if len(writer) > 50:
                return {"success":False,"message":"Yazar ismi 50 karakterden fazla olamaz!"}
                        
            if len(publisher) > 20:
                return {"success":False,"message":"Yayınevi ismi 20 karakterden fazla olamaz!"}
                            
            if not str(pageCount).isdigit():
                return {"success":False,"message":"Sayfa sayısı sayı olmalıdır!"}
            
            if int(pageCount) > 99999:
                return {"success":False,"message":"Sayfa sayısı 99999'dan fazla olamaz!"}
                                    
            self.cursor.execute("INSERT INTO books (bookName,writer,category,publisher,pageCount,whoAdded) VALUES (%s,%s,%s,%s,%s,%s)",(bookName,writer,category,publisher,pageCount,activeUserName))
            self.conn.commit()
                                        
            return {"success":True,"message":"Kitap eklendi."}

        except Exception as e:

            writeLog(config.BOOKS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}


    def deleteBook(self,id:int):

        try:

            if id == 0 or id < 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            self.cursor.execute("SELECT * FROM books WHERE id = %s",(id,))
            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"Kitap bulunamadı!"}

            self.cursor.execute("DELETE FROM books WHERE id = %s",(id,))
            self.conn.commit()

            return {"success":True,"message":"Kitap silindi."}

        except Exception as e:

            writeLog(config.BOOKS_LOG_PATH,type(e).__name__,str(e))
            
            return {"success":False,"message":"Bir hata oluştu!"}
    

    def listBooks(self,filterValue:str,filterType:str,isWithFilter:bool | str,pageNumber:int,limit:int):

        try:

            filterList = ["id","bookName","writer","category","publisher","pageCount","isTaken","whoAdded"]

            if limit == 0:
                return {"success":False,"message":"Lutfen boş bırakmayın!"}
            
            if limit > 50:
                return {"success":False,"message":"Limit en fazla 50 olabilir!"}
            
            IDs,names,writers,categories,publishers,pageCounts,isTakens,whoAddeds = [],[],[],[],[],[],[],[]
            offset = ((pageNumber - 1) * limit)

            self.cursor.execute("SELECT COUNT(*) FROM books")
            totalBooks = self.cursor.fetchone()[0]
            if totalBooks is not None:
                pageCount = totalBooks // limit
            if totalBooks % limit != 0:
                pageCount += 1

            def add(rV):
                IDs.append(rV[0])
                names.append(rV[1])
                writers.append(rV[2])
                publishers.append(rV[3])
                pageCounts.append(rV[4])
                categories.append(rV[5])
                isTakens.append(rV[6])
                whoAddeds.append(rV[7])

            if isWithFilter:

                if filterValue.replace(" ","") == "" or filterType.replace(" ","") == "":
                    return {"success":False,"message":"Lütfen boş bırakmayın!"}
                        
                if filterType != "pageCount" and filterType != "id":
                    if len(filterValue.strip()) < 2:
                        return {"success":False,"message":"Arama en az 2 karakter olmalıdır!"}
                                
                if filterType not in filterList:
                    return {"success":False,"message":"Lütfen geçerli parametre giriniz!"}
                              
                if filterType != "pageCount" and filterType != "id":
                    newFilterValue = f"%{filterValue}%"
                    self.cursor.execute(f"SELECT COUNT(*) FROM books WHERE {filterType} LIKE %s", (newFilterValue,))
                    totalBooks = self.cursor.fetchone()[0]
                    pageCount = totalBooks // limit
                    if totalBooks % limit != 0:
                        pageCount += 1

                    self.cursor.execute(f"SELECT * FROM books WHERE {filterType} LIKE %s LIMIT %s OFFSET %s", (newFilterValue,limit, offset))
                    result = self.cursor.fetchall()

                else:
                                
                    self.cursor.execute(f"SELECT COUNT(*) FROM books WHERE {filterType} = %s", (int(filterValue),))
                    totalBooks = self.cursor.fetchone()[0]
                    pageCount = totalBooks // limit
                    if totalBooks % limit != 0:
                        pageCount += 1

                    self.cursor.execute(f"SELECT * FROM books WHERE {filterType} = %s LIMIT %s OFFSET %s", (int(filterValue),limit, offset))
                    result = self.cursor.fetchall()

                    if result:
                        for r in result:
                            add(rV=r)  
                    
            elif isWithFilter == False:

                self.cursor.execute("SELECT * FROM books LIMIT %s OFFSET %s", (limit, offset))
                result2 = self.cursor.fetchall()

                if result2: 
                    for r2 in result2:
                        add(rV=r2)
                    
                if len(IDs) == 0:
                    return {"success":False,"message":"Sonuç bulunamadı!"}
                
                return {
                    "success":True,
                    "message":"Kitaplar listelendi.",
                    "data":{
                        "totalBooks":totalBooks,
                        "ids":IDs,
                        "names":names,
                        "writers":writers,
                        "categories":categories,
                        "publishers":publishers,
                        "pageCounts":pageCounts,
                        "isTakens":isTakens,
                        "whoAddeds":whoAddeds,
                        "pageCount":pageCount
                    }
                }

                            

        except Exception as e:
            
            writeLog(config.BOOKS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}

    def updateBook(self,id:int,bookName:str,writer:str,category:str,publisher:str,pageCount:int,activeUserName:str):

        try:

            if id == 0 or id < 0 or bookName.replace(" ","") == "" or writer.replace(" ","") == "" or publisher.replace(" ","") == "" or pageCount == 0 or category.replace(" ","") == "" or pageCount < 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            self.cursor.execute("SELECT * FROM books WHERE id = %s",(id,))
            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"Kitap bulunamadı!"}
            
            self.cursor.execute("SELECT * FROM categories WHERE categoryName = %s",(category,))
            result = self.cursor.fetchone()
                    
            if result is None:
                return {"success":False,"message":"Bu kategori mevcut değil!"}
            
            if len(bookName) > 50:
                return {"success":False,"message":"Kitap ismi 50 karakterden fazla olamaz!"}
            
            if len(writer) > 50:
                return {"success":False,"message":"Yazar ismi 50 karakterden fazla olamaz!"}
            
            if len(publisher) > 50:
                return {"success":False,"message":"Yayınevi ismi 50 karakterden fazla olamaz!"}
            
            if not str(pageCount).isdigit():
                return {"success":False,"message":"Sayfa sayısı sayı olmalıdır!"}
                
            if int(pageCount) > 99999:
                return {"success":False,"message":"Sayfa sayısı 99999'dan fazla olamaz!"}

            self.cursor.execute("UPDATE books SET bookName = %s, writer = %s, category = %s, publisher = %s, pageCount = %s, whoAdded = %s WHERE id = %s",(bookName,writer,category,publisher,pageCount,activeUserName,id))
            self.conn.commit()
                                            
            return {"success":True,"message":"Kitap güncellendi."}

        except Exception as e:

            writeLog(config.BOOKS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}