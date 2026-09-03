import config
from utils.writeLog import writeLog


class Book:

    def __init__(self,conn,cursor):
        
        self.conn = conn
        self.cursor = cursor


    def addBook(self,bookName:str,writer:str,category:str,publisher:str,pageCount:int,activeUserName:str):

        try:

            if not bookName.strip() or not writer.strip() or not publisher.strip() or pageCount <= 0:
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
                                    
            self.cursor.execute("INSERT INTO books (bookName,writer,category,publisher,pageCount,whoAdded) VALUES (%s,%s,%s,%s,%s,%s)",(bookName.strip(),writer.strip(),category.strip(),publisher.strip(),pageCount,activeUserName))
            self.conn.commit()
                                        
            return {"success":True,"message":"Kitap eklendi."}

        except Exception as e:

            self.conn.rollback()
            writeLog(config.BOOKS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}


    def deleteBook(self,id:int):

        try:

            if id <= 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            self.cursor.execute("SELECT * FROM books WHERE id = %s",(id,))
            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"Kitap bulunamadı!"}

            self.cursor.execute("SELECT * FROM books WHERE id = %s and isTaken = 'Alındı'",(id,))
            result = self.cursor.fetchone()

            if result is not None:
                return {"success":False,"message":"Kitap ödünç verildiği için silinemez!"}
            
            self.cursor.execute("DELETE FROM books WHERE id = %s",(id,))
            self.conn.commit()

            return {"success":True,"message":"Kitap silindi."}

        except Exception as e:

            self.conn.rollback()
            writeLog(config.BOOKS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    

    def listBooks(self,filterValue:str,filterType:str,isWithFilter:bool,pageNumber:int,limit:int):

        try:

            filterList = ["id","bookName","writer","category","publisher","pageCount","isTaken","whoAdded"]

            if limit <= 0 or pageNumber <= 0:
                return {"success":False,"message":"Lutfen boş bırakmayın!"}
            
            if limit > 10:
                return {"success":False,"message":"Sayfaya düşen satır sayısı en fazla 10 olabilir!"}
            
            books = []

            self.cursor.execute("SELECT COUNT(*) FROM books")
            totalBooks = self.cursor.fetchone()[0]

            if totalBooks is not None:
                pageCount = totalBooks // limit
                if totalBooks % limit != 0:
                    pageCount += 1

            offset = ((pageNumber - 1) * limit)

            def add(rV):
                books.append({"ID":rV[0],"name":rV[1],"writer":rV[2],"publisher":rV[3],"pageCount":rV[4],"category":rV[5],"isTaken":rV[6],"whoAdded":rV[7]})

            if isWithFilter:

                if not filterValue.strip() or not filterType.strip():
                    return {"success":False,"message":"Lütfen boş bırakmayın!"}
                        
                if filterType != "pageCount" and filterType != "id":
                    if len(filterValue.strip()) < 2:
                        return {"success":False,"message":"Arama en az 2 karakter olmalıdır!"}
                                
                if filterType not in filterList:
                    return {"success":False,"message":"Lütfen geçerli parametre giriniz!"}
                              
                if filterType != "pageCount" and filterType != "id":
                    newFilterValue = f"%{filterValue.strip()}%"
                    self.cursor.execute(f"SELECT COUNT(*) FROM books WHERE {filterType} LIKE %s", (newFilterValue,))
                    totalBooks = self.cursor.fetchone()[0]

                    if totalBooks is not None:
                        pageCount = totalBooks // limit
                        if totalBooks % limit != 0:
                            pageCount += 1

                    self.cursor.execute(f"SELECT * FROM books WHERE {filterType} LIKE %s LIMIT %s OFFSET %s", (newFilterValue,limit, offset))
                    result = self.cursor.fetchall()

                else:
                                
                    self.cursor.execute(f"SELECT COUNT(*) FROM books WHERE {filterType} = %s", (int(filterValue),))
                    totalBooks = self.cursor.fetchone()[0]

                    if totalBooks is not None:
                        pageCount = totalBooks // limit
                        if totalBooks % limit != 0:
                            pageCount += 1

                    self.cursor.execute(f"SELECT * FROM books WHERE {filterType} = %s LIMIT %s OFFSET %s", (int(filterValue),limit, offset))
                    result = self.cursor.fetchall()
                    
            else:

                self.cursor.execute("SELECT * FROM books LIMIT %s OFFSET %s", (limit, offset))
                result = self.cursor.fetchall()

            if result: 
                for r2 in result:
                    add(rV=r2)
                    
            if len(books) == 0:
                return {"success":False,"message":"Sonuç bulunamadı!"}
                
            return {
                "success":True,
                "message":"Kitaplar listelendi.",
                "data":{
                    "totalBooks":totalBooks,
                    "books":books,
                    "pageCount":pageCount
                }
            }

                            

        except Exception as e:
            
            writeLog(config.BOOKS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}

    def updateBook(self,id:int,bookName:str,writer:str,category:str,publisher:str,pageCount:int,activeUserName:str):

        try:

            if id <= 0 or not bookName.strip() or not writer.strip() or not publisher.strip() or pageCount <= 0 or not category.strip():
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

            self.cursor.execute("UPDATE books SET bookName = %s, writer = %s, category = %s, publisher = %s, pageCount = %s, whoAdded = %s WHERE id = %s",(bookName.strip(),writer.strip(),category.strip(),publisher.strip(),pageCount,activeUserName,id))
            self.conn.commit()
                                            
            return {"success":True,"message":"Kitap güncellendi."}

        except Exception as e:

            self.conn.rollback()
            writeLog(config.BOOKS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}