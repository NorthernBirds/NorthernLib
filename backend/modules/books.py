import config
from utils.writeLog import writeLog
from modules.processes import addProcess

class Book:

    def __init__(self,conn,cursor):
        
        self.conn = conn
        self.cursor = cursor


    def addBook(self,bookName:str,writer:str,category:str,publisher:str,pageCount:int,activeUserName:str):

        try:

            if bookName == "" or writer == "" or publisher ==  "" or pageCount == 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            else:
                
                self.cursor.execute("SELECT * FROM categories WHERE categoryName = %s",(category,))
                result = self.cursor.fetchone()
                
                if result is None:
                    return {"success":False,"message":"Bu kategori mevcut değil!"}
                else:

                    if len(bookName) > 50:
                        return {"success":False,"message":"Kitap ismi 50 karakterden fazla olamaz!"}
                    else:

                        if len(writer) > 50:
                            return {"success":False,"message":"Yazar ismi 50 karakterden fazla olamaz!"}
                        else:

                            if len(publisher) > 20:
                                return {"success":False,"message":"Yayınevi ismi 20 karakterden fazla olamaz!"}
                            else:

                                if not str(pageCount).isdigit():
                                    return {"success":False,"message":"Sayfa sayısı sayı olmalıdır!"}
                                else:

                                    if int(pageCount) > 99999:
                                        return {"success":False,"message":"Sayfa sayısı 99999'dan fazla olamaz!"}
                                    elif int(pageCount) == 0 or int(pageCount) < 0:
                                        return {"success":False,"message":"Sayfa sayısı 0 veya 0'dan az olamaz!"}
                                    else:

                                        self.cursor.execute(
                                            "INSERT INTO books (bookName,writer,category,publisher,pageCount,whoAdded) VALUES (%s,%s,%s,%s,%s,%s)",
                                            (bookName,writer,category,publisher,pageCount,activeUserName)
                                        )

                                        self.conn.commit()
                                        addProcess(userName=activeUserName,process=f"{bookName} adlı kitap kitaplara eklendi.")
                                        return {"success":True,"message":"Kitap eklendi."}

        except Exception as e:

            writeLog(config.BOOKS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}


    def deleteBook(self,id:int,activeUserName:str):

        try:

            if id == 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            else:

                self.cursor.execute("SELECT * FROM books WHERE id = %s",(id,))
                result = self.cursor.fetchone()

                if result is None:
                    return {"success":False,"message":"Kitap bulunamadı!"}
                else:

                    self.cursor.execute("DELETE FROM books WHERE id = %s",(id,))
                    self.conn.commit()

                    return {"success":True,"message":"Kitap silindi."}

        except Exception as e:

            writeLog(config.BOOKS_LOG_PATH,type(e).__name__,str(e))
            addProcess(userName=activeUserName,process=f"{id} ID'li kitap silindi.")
            return {"success":False,"message":"Bir hata oluştu!"}
    

    def listBooks(self,filterValue:str,filterType:str,isWithFilter:bool | str,pageNumber:int,limit:int,activeUserName:str):

        try:

            if limit == 0:
                return {"success":False,"message":"Lutfen boş bırakmayın!"}
            else:

                if limit > 50:
                    return {"success":False,"message":"Limit en fazla 50 olabilir!"}
                else:

                    IDs,names,writers,categories,publishers,pageCounts,isTakens,whoAddeds = [],[],[],[],[],[],[],[]
                    offset = ((pageNumber - 1) * limit) + 1

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
                        categories.append(rV[3])
                        publishers.append(rV[4])
                        pageCounts.append(rV[5])
                        if bool(rV[6]) == True:
                            isTakens.append("Alındı")
                        else:
                            isTakens.append("Alınmadı")
                        whoAddeds.append(rV[7])

                    if isWithFilter == True:

                        if filterValue == "" or filterType == "":
                            return {"success":False,"message":"Lütfen boş bırakmayın!"}
                        else:

                            if filterType != "pageCount" and filterType != "id":
                                if len(filterValue.strip()) < 2:
                                    return {"success":False,"message":"Arama en az 2 karakter olmalıdır!"}
                            
                            self.cursor.execute("SELECT * FROM books LIMIT %s OFFSET %s", (limit, offset))
                            result = self.cursor.fetchall()

                            if not result:
                                pass
                            else:

                                for r in result:
                                    
                                    for i,j in zip(
                                        range(0,8),
                                        ["id","name","writer","category","publisher","pageCount","isTaken","whoAdded"]
                                    ):

                                        if filterType == j:

                                            parsed_name = str(r[i]).lower()
                                            if filterType == "pageCount" and filterType == "id":
                                                if str(filterValue).lower() == parsed_name:
                                                    add(rV=r)
                                            else:
                                                if str(filterValue).lower() in parsed_name:
                                                    add(rV=r)
                    
                    elif isWithFilter == False:

                        self.cursor.execute("SELECT * FROM books LIMIT %s OFFSET %s", (limit, offset))
                        result2 = self.cursor.fetchall()

                        if not result2:
                            pass
                        else:
                            for r2 in result2:
                                add(rV=r2)
                    

                    if len(IDs) == 0:
                        return {"success":False,"message":"Sonuç bulunamadı!"}
                    else:

                        addProcess(userName=activeUserName,process=f"{f"{filterType} değişkeni {filterValue} olan ve" if isWithFilter == True else ''} {offset + 1} - {(offset + limit) + 1} arasında olan kitaplar listelendi.")
                        return {
                            "success":True,
                            "message":f"{totalBooks} kitap kaydından yalnızca {offset + 1} - {(offset + limit) + 1} arası kitaplar listeleniyor.",
                            "data":{
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