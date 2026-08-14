import config
from utils.writeLog import writeLog


class Category:

    def __init__(self,conn,cursor):
        
        self.conn = conn
        self.cursor = cursor

    
    def addCategory(self,categoryName:str,activeUserName:str):

        try:
                
            if categoryName not in config.BOOK_CATEGORIES:
                return {"success":False,"message":"Bu kategori mevcut değil!"}
            
            self.cursor.execute("SELECT * FROM categories WHERE categoryName = %s",(categoryName,))
            result = self.cursor.fetchone()

            if result is not None:
                return {"success":False,"message":"Bu kategori zaten mevcut!"}
                
            self.cursor.execute("INSERT INTO categories (categoryName,whoAdded) VALUES (%s,%s)",(categoryName,activeUserName))
            self.conn.commit()
                    
            return {"success":True,"message":"Kategori eklendi."}
                
        except Exception as e:

            writeLog(config.CATEGORIES_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    

    def deleteCategory(self,id:int):

        try:

            if id == 0 or id < 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            
            self.cursor.execute("SELECT * FROM categories WHERE id = %s",(id,))
            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"Kategori bulunamadı!"}
                
            self.cursor.execute("DELETE FROM categories WHERE id = %s",(id,))
            self.conn.commit()
                    
            return {"success":True,"message":"Kategori silindi."}

        except Exception as e:

            writeLog(config.CATEGORIES_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    

    def listCategories(self,filterValue:str,filterType:str,isWithFilter:bool,pageNumber:int,limit:int):

        try:

            filterList = ["id","categoryName","whoAdded"]

            if limit == 0 or limit < 0 or pageNumber == 0 or pageNumber < 0:
                return {"success":False,"message":"Lutfen boş bırakmayın!"}
            
            if limit > 50:
                return {"success":False,"message":"Limit en fazla 50 olabilir!"}
                
            IDs,categoryNames,whoAddeds = [],[],[]
            self.cursor.execute("SELECT COUNT(*) FROM categories")
            totalCategories = self.cursor.fetchone()[0]
            if totalCategories is not None:
                pageCount = totalCategories // limit
                if totalCategories % limit != 0:
                    pageCount += 1
            offset = ((pageNumber - 1) * limit)

            def add(rV):
                IDs.append(rV[0])
                categoryNames.append(rV[1])
                whoAddeds.append(rV[2])

            if isWithFilter:

                if filterValue.replace(" ","") == "" or filterType.replace(" ","") == "":
                    return {"success":False,"message":"Lütfen boş bırakmayın!"}
                        
                if filterType != "id":
                    if len(filterValue.strip()) < 2:
                        return {"success":False,"message":"Arama en az 2 karakter olmalıdır!"}
                            
                if filterType not in filterList:
                    return {"success":False,"message":"Lütfen geçerli parametre giriniz!"}
                         
                if filterType != "id":
                    newFilterValue = f"%{filterValue}%"
                    self.cursor.execute(f"SELECT COUNT(*) FROM categories WHERE {filterType} LIKE %s", (newFilterValue,))
                    totalCategories = self.cursor.fetchone()[0]
                    pageCount = totalCategories // limit
                    if totalCategories % limit != 0:
                        pageCount += 1

                    self.cursor.execute(f"SELECT * FROM categories WHERE {filterType} LIKE %s LIMIT %s OFFSET %s", (newFilterValue,limit, offset))
                    result = self.cursor.fetchall()

                else:
                                
                    self.cursor.execute(f"SELECT COUNT(*) FROM categories WHERE {filterType} = %s", (int(filterValue),))
                    totalCategories = self.cursor.fetchone()[0]
                    pageCount = totalCategories // limit
                    if totalCategories % limit != 0:
                        pageCount += 1

                    self.cursor.execute(f"SELECT * FROM categories WHERE {filterType} = %s LIMIT %s OFFSET %s", (int(filterValue),limit, offset))
                    result = self.cursor.fetchall()

                    if result:
   
                        for r in result:
                            add(rV=r)
                    
            elif isWithFilter == False:

                self.cursor.execute("SELECT * FROM categories LIMIT %s OFFSET %s", (limit, offset))
                result2 = self.cursor.fetchall()
                if result2:
                        
                    for r2 in result2:
                        add(rV=r2)
                        
                    if len(IDs) == 0:
                        return {"success":False,"message":"Sonuç bulunamadı!"}
                    else:
                        
                        return {
                            "success":True,
                            "message":"Kategoriler listelendi.",
                            "data":{
                                "totalCategories":totalCategories,
                                "ids":IDs,
                                "categoryNames":categoryNames,
                                "whoAddeds":whoAddeds,
                                "pageCount":pageCount
                            }
                        }


        except Exception as e:
            
            writeLog(config.CATEGORIES_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}

    def updateCategory(self,id:int,categoryName:str,activeUserName:str):

        try:

            if id == 0 or id < 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}

            self.cursor.execute("SELECT * FROM categories WHERE id = %s",(id,))
            result = self.cursor.fetchone()

            if result is None:
                return {"success":False,"message":"Kategori bulunamadı!"}
                
            if categoryName not in config.BOOK_CATEGORIES:
                return {"success":False,"message":"Bu kategori mevcut değil!"}
            
            self.cursor.execute("SELECT * FROM categories WHERE categoryName = %s",(categoryName,))
            result = self.cursor.fetchone()

            if result is not None:
                return {"success":False,"message":"Bu kategori zaten mevcut!"}
                
            self.cursor.execute("UPDATE categories SET categoryName = %s, whoAdded = %s WHERE id = %s",(categoryName,activeUserName,id))
            self.conn.commit()
                            
            return {"success":True,"message":"Kategori güncellendi."}
                
        except Exception as e:

            writeLog(config.CATEGORIES_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}