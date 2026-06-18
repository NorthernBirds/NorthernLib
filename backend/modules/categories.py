import config
from utils.writeLog import writeLog

class Category:

    def __init__(self,conn,cursor):
        
        self.conn = conn
        self.cursor = cursor

    
    def addCategory(self,categoryName,activeUserName):

        try:
                
            if categoryName not in config.BOOK_CATEGORIES:
                return {"success":False,"message":"Bu kategori mevcut değil!"}
            else:

                self.cursor.execute(
                    "SELECT * FROM categories WHERE categoryName = %s",
                    (categoryName,)
                )

                result = self.cursor.fetchone()

                if result is not None:
                    return {"success":False,"message":"Bu kategori zaten mevcut!"}
                else:

                    self.cursor.execute(
                        "INSERT INTO categories (categoryName,whoAdded) VALUES (%s,%s)",
                        (categoryName,activeUserName)
                    )

                    self.conn.commit()

                    return {"success":True,"message":"Kategori eklendi."}
                
        except Exception as e:

            writeLog(config.CATEGORIES_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    

    def deleteCategory(self,id):

        try:

            if id == 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            else:

                self.cursor.execute("SELECT * FROM categories WHERE id = %s",(id,))
                result = self.cursor.fetchone()

                if result is None:
                    return {"success":False,"message":"Kategori bulunamadı!"}
                else:

                    self.cursor.execute("DELETE FROM categories WHERE id = %s",(id,))
                    self.conn.commit()

                    return {"success":True,"message":"Kategori silindi."}

        except Exception as e:

            writeLog(config.CATEGORIES_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    

    def listCategories(self,filterValue,filterType,isWithFilter,pageNumber):

        try:

            sendData = True
            IDs,categoryNames,whoAddeds = [],[],[]
            
            def add(rV):
                IDs.append(rV[0])
                categoryNames.append(rV[1])
                whoAddeds.append(rV[2])

            if isWithFilter == True:

                if filterValue == "" or filterType == "":
                    return {"success":False,"message":"Lütfen boş bırakmayın!"}
                else:

                    if filterType != "id":
                        if len(filterValue.strip()) < 2:
                            return {"success":False,"message":"Arama en az 2 karakter olmalıdır!"}

                    self.cursor.execute("SELECT * FROM categories LIMIT %s OFFSET %s", (20, (pageNumber - 1) * 20))
                    result = self.cursor.fetchall()

                    if not result:
                        pass
                    else:
                    
                            for r in result:

                                for i,j in zip(
                                    range(0,3),
                                    ["id","categoryName","whoAdded"]
                                ):

                                    if filterType == j:

                                        parsed_name = str(r[i]).lower()
                                        if filterType == "id":
                                            if str(filterValue).lower() == parsed_name:
                                                add(rV=r)
                                        else:
                                            if filterValue.lower() in parsed_name:
                                                add(rV=r)
            
            elif isWithFilter == False:

                self.cursor.execute("SELECT * FROM categories LIMIT %s OFFSET %s", (20, (pageNumber - 1) * 20))
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
                            "categoryNames":categoryNames,
                            "whoAddeds":whoAddeds
                        }
                    }
            else:
                pass

        except Exception as e:
            
            writeLog(config.CATEGORIES_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}