import bcrypt
from utils.writeLog import writeLog
import config


class User:

    def __init__(self,conn,cursor):

        self.conn = conn
        self.cursor = cursor
    

    def addUser(self,userName:str,password:str,role:str):

        try:
            if password.replace(" ","") == "" or userName.replace(" ","") == "" or role.replace(" ","") == "":
                return {"success": False, "message": "Lütfen boş bırakmayınız!"}
            
            if len(userName) > 20:
                return {"success": False, "message": "Kullanıcı ismi 20 karakterden fazla olamaz!"}
            
            self.cursor.execute("SELECT * FROM users WHERE userName = %s",(userName,))
            result = self.cursor.fetchone()
            if result is not None:
                return {"success": False, "message": "Bu kullanıcı adı zaten mevcut!"}
                    
            if len(password) < 8 or len(password) > 15:
                return {"success": False, "message": "Şifre 8 - 15 karakter arasında olmalıdır!"}
            
            if role == "admin":
                return {"success": False, "message": "Oluşturulan kullanıcı yönetici yetkisine sahip olamaz!"}
            
            if role not in ["student_staff", "teacher"]:
                return {"success": False, "message": "Böyle bir yetki seviyesi bulunmamaktadır!"}
                        
            password = password.encode()
            hashed = bcrypt.hashpw(password, bcrypt.gensalt())
            self.cursor.execute("INSERT INTO users (userName,userPassword,userRole) VALUES (%s,%s,%s)",(userName,hashed.decode(),role))
            self.conn.commit()
                                    
            return {"success": True, "message": "Kullanıcı oluşturuldu"}
            
        except Exception as e:

            writeLog(config.USERS_LOG_PATH,type(e).__name__,str(e))
            return {"success": False, "message": "Bir hata oluştu!"}
    

    def deleteUser(self,id:int):

        try:
            if id == 0 or id < 0:
                return {"success": False, "message": "Lütfen boş bırakmayın!"}
            
            self.cursor.execute("SELECT * FROM users WHERE id = %s",(id,))
            result = self.cursor.fetchone()
            if result is None:
                return {"success": False, "message": "Kullanıcı bulunamadı!"}
            
            if result[3] == 'admin':
                return {"success": False, "message": "Yönetici yetkisine sahip kullanıcı silinemez!"}
                          
            self.cursor.execute("DELETE FROM users WHERE id = %s",(id,))
            self.conn.commit()
                        
            return {"success": True, "message": "Kullanıcı silindi"}
            
        except Exception as e:

            writeLog(config.USERS_LOG_PATH,type(e).__name__,str(e))
            return {"success": False, "message": "Bir hata oluştu!"}
    

    def changeRole(self,id:int,newRole:str):

        try:
            if id == 0 or newRole.replace(" ","") == "" or id < 0:
                return {"success": False, "message": "Lütfen boş bırakmayın!"}
            
            self.cursor.execute("SELECT * FROM users WHERE id = %s",(id,))
            result = self.cursor.fetchone()
            if result is None:
                return {"success": False, "message": "Kullanıcı bulunamadı!"}
            
            if newRole == "admin":
                return {"success": False, "message": "Oluşturulan kullanıcı yönetici yetkisine sahip olamaz!"}
        
            if newRole not in ["student_staff", "teacher"]:
                return {"success": False, "message": "Böyle bir yetki seviyesi bulunmamaktadır!"}
         
            if result[3] == newRole:
                return {"success": False, "message": "Bu kullanıcı zaten bu role sahip!"}
            
            self.cursor.execute("UPDATE users SET userRole = %s WHERE id = %s",(newRole,id))
            self.conn.commit()
                                
            return {"success": True, "message": "Rol güncellendi."}
                            
        except Exception as e:

            writeLog(config.USERS_LOG_PATH,type(e).__name__,str(e))
            return {"success": False, "message": "Bir hata oluştu!"}
    

    def listUsers(self,filterValue:str,filterType:str,isWithFilter:bool,pageNumber:int,limit:int):

        try:

            filterList = ["id","userName","userRole"]

            if limit == 0 or limit < 0 or pageNumber == 0 or pageNumber < 0:
                return {"success":False,"message":"Lutfen boş bırakmayın!"}
            
            if limit > 50:
                return {"success":False,"message":"Limit en fazla 50 olabilir!"}
            
            IDs,userNames,roles = [],[],[]
            self.cursor.execute("SELECT COUNT(*) FROM users")
            totalUsers = self.cursor.fetchone()[0]
            if totalUsers is not None:
                pageCount = totalUsers // limit
                if totalUsers % limit != 0:
                    pageCount += 1
            offset = ((pageNumber - 1) * limit)

            def add(rV):
                IDs.append(rV[0])
                userNames.append(rV[1])
                roles.append(rV[3])
                    
            if isWithFilter:

                if filterValue == "" or filterType == "":
                    return {"success":False,"message":"Lütfen boş bırakmayın!"}
                       
                if filterType != "id":
                    if len(filterValue.strip()) < 2:
                        return {"success":False,"message":"Arama en az 2 karakter olmalıdır!"}

                if filterType not in filterList:
                    return {"success":False,"message":"Lütfen geçerli parametre giriniz!"}
                            
                if filterType != "id":
                    newFilterValue = f"%{filterValue}%"
                    self.cursor.execute(f"SELECT COUNT(*) FROM users WHERE {filterType} LIKE %s", (newFilterValue,))
                    totalUsers = self.cursor.fetchone()[0]
                    pageCount = totalUsers // limit
                    if totalUsers % limit != 0:
                        pageCount += 1

                self.cursor.execute(f"SELECT * FROM users WHERE {filterType} LIKE %s LIMIT %s OFFSET %s", (newFilterValue,limit, offset))
                result = self.cursor.fetchall()
                   
                self.cursor.execute(f"SELECT COUNT(*) FROM users WHERE {filterType} = %s", (int(filterValue),))
                totalUsers = self.cursor.fetchone()[0]
                pageCount = totalUsers // limit
                if totalUsers % limit != 0:
                    pageCount += 1

                self.cursor.execute(f"SELECT * FROM users WHERE {filterType} = %s LIMIT %s OFFSET %s", (int(filterValue),limit, offset))
                result = self.cursor.fetchall()
       
                for r in result:
                    add(rV=r)
                    
            elif isWithFilter == False:

                self.cursor.execute("SELECT * FROM users LIMIT %s OFFSET %s", (limit, offset))
                result2 = self.cursor.fetchall()

                if result2:

                    for r2 in result2:
                        add(rV=r2)
                    
            if len(IDs) == 0:
                return {"success":False,"message":"Sonuç bulunamadı!"}
    
            return {
                "success":True,
                "message":"Kullanıcılar listelendi.",
                "data":{
                    "totalUsers":totalUsers,
                    "ids":IDs,
                    "userNames":userNames,
                    "roles":roles,
                    "pageCount":pageCount
                }
            }

        except Exception as e:
            
            writeLog(config.USERS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}

    def updateUser(self,id:int,userName:str,password:str,role:str):

        try:
            if password.replace(" ", "") == "" or userName.replace(" ", "") == "" or role.replace(" ", "") == "" or id == 0 or id < 0:
                return {"success": False, "message": "Lütfen boş bırakmayınız!"}
            
            self.cursor.execute("SELECT * FROM users WHERE id = %s",(id,))
            result = self.cursor.fetchone()

            if result is None:
                return {"success": False, "message": "Kullanıcı bulunamadı!"}
                
            if len(userName) > 20:
                return {"success": False, "message": "Kullanıcı ismi 20 karakterden fazla olamaz!"}
                  
            self.cursor.execute("SELECT * FROM users WHERE userName = %s",(userName,))
            result = self.cursor.fetchone()
            if result is not None:
                return {"success": False, "message": "Bu kullanıcı adı zaten mevcut!"}
            
            if len(password) < 8 or len(password) > 15:
                return {"success": False, "message": "Şifre 8 - 15 karakter arasında olmalıdır!"}
                   
            if role == "admin":
                return {"success": False, "message": "Oluşturulan kullanıcı yönetici yetkisine sahip olamaz!"}
            
            if role not in ["student_staff", "teacher"]:
                return {"success": False, "message": "Böyle bir yetki seviyesi bulunmamaktadır!"}
            
            password = password.encode()
            hashed = bcrypt.hashpw(password, bcrypt.gensalt())
            self.cursor.execute("UPDATE users SET userName = %s, userPassword = %s, userRole = %s WHERE id = %s",(userName,hashed.decode(),role,id))
            self.conn.commit()
                                        
            return {"success": True, "message": "Kullanıcı güncellendi"}
            
        except Exception as e:

            writeLog(config.USERS_LOG_PATH,type(e).__name__,str(e))
            return {"success": False, "message": "Bir hata oluştu!"}