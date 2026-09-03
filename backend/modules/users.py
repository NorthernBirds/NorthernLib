import bcrypt
from utils.writeLog import writeLog
import config

class User:

    def __init__(self,conn,cursor):

        self.conn = conn
        self.cursor = cursor
    

    def addUser(self,userName:str,password:str,role:str,activeUserName:str):

        try:
            if not password.strip() or not userName.strip() or not role.strip():
                return {"success": False, "message": "Lütfen boş bırakmayınız!"}
            
            if len(userName) > 20:
                return {"success": False, "message": "Kullanıcı ismi 20 karakterden fazla olamaz!"}
            
            self.cursor.execute("SELECT * FROM users WHERE userName = %s",(userName,))
            result = self.cursor.fetchone()
            if result is not None:
                return {"success": False, "message": "Bu kullanıcı adı zaten mevcut!"}
                    
            if len(password) < 8 or len(password) > 15:
                return {"success": False, "message": "Şifre 8 - 15 karakter arasında olmalıdır!"}
            
            if role.strip() == "admin":
                return {"success": False, "message": "Oluşturulan kullanıcı yönetici yetkisine sahip olamaz!"}
            
            if role.strip() not in ["student_staff", "teacher"]:
                return {"success": False, "message": "Böyle bir yetki seviyesi bulunmamaktadır!"}
                        
            password = password.strip().encode()
            hashed = bcrypt.hashpw(password, bcrypt.gensalt())
            self.cursor.execute("INSERT INTO users (userName,userPassword,userRole,whoAdded) VALUES (%s,%s,%s,%s)",(userName.strip(),hashed.decode(),"Öğretmen" if role.strip() == "teacher" else "Öğrenci",activeUserName))
            self.conn.commit()
                                    
            return {"success": True, "message": "Kullanıcı oluşturuldu"}
            
        except Exception as e:

            self.conn.rollback()
            writeLog(config.USERS_LOG_PATH,type(e).__name__,str(e))
            return {"success": False, "message": "Bir hata oluştu!"}
    

    def deleteUser(self,id:int):

        try:
            if id <= 0:
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

            self.conn.rollback()
            writeLog(config.USERS_LOG_PATH,type(e).__name__,str(e))
            return {"success": False, "message": "Bir hata oluştu!"}
    

    def changeRole(self,id:int,newRole:str):

        try:
            if id <= 0 or not newRole.strip():
                return {"success": False, "message": "Lütfen boş bırakmayın!"}
            
            self.cursor.execute("SELECT * FROM users WHERE id = %s",(id,))
            result = self.cursor.fetchone()
            if result is None:
                return {"success": False, "message": "Kullanıcı bulunamadı!"}

            if result[3] == "admin" and newRole != "admin":
                return {"success":False,"message":"Yönetici yetkisine sahip kullanıcının rolü değiştirilemez!"}
            
            if newRole.strip() == "admin":
                return {"success": False, "message": "Oluşturulan kullanıcı yönetici yetkisine sahip olamaz!"}
        
            if newRole.strip() not in ["student_staff", "teacher"]:
                return {"success": False, "message": "Böyle bir yetki seviyesi bulunmamaktadır!"}
         
            if result[3] == newRole:
                return {"success": False, "message": "Bu kullanıcı zaten bu role sahip!"}
            
            self.cursor.execute("UPDATE users SET userRole = %s WHERE id = %s",(newRole.strip(),id))
            self.conn.commit()
                                
            return {"success": True, "message": "Rol güncellendi."}
                            
        except Exception as e:

            self.conn.rollback()
            writeLog(config.USERS_LOG_PATH,type(e).__name__,str(e))
            return {"success": False, "message": "Bir hata oluştu!"}
    

    def listUsers(self,filterValue:str,filterType:str,isWithFilter:bool,pageNumber:int,limit:int):

        try:

            filterList = ["id","userName","userRole","whoAdded"]

            if limit <= 0 or pageNumber <= 0:
                return {"success":False,"message":"Lutfen boş bırakmayın!"}
            
            if limit > 10:
                return {"success":False,"message":"Sayfaya düşen satır sayısı en fazla 10 olabilir!"}
            
            users = []
            self.cursor.execute("SELECT COUNT(*) FROM users WHERE userRole != 'admin'")
            totalUsers = self.cursor.fetchone()[0]

            if totalUsers is not None:
                pageCount = totalUsers // limit
                if totalUsers % limit != 0:
                    pageCount += 1
                    
            offset = ((pageNumber - 1) * limit)

            def add(rV):
                users.append({"ID":rV[0],"userName":rV[1],"role":rV[3],"whoAdded":rV[4]})

                    
            if isWithFilter:

                if not filterValue.strip() or not filterType.strip():
                    return {"success":False,"message":"Lütfen boş bırakmayın!"}
                       
                if filterType != "id":
                    if len(filterValue.strip()) < 2:
                        return {"success":False,"message":"Arama en az 2 karakter olmalıdır!"}

                if filterType not in filterList:
                    return {"success":False,"message":"Lütfen geçerli parametre giriniz!"}
                            
                if filterType != "id":
                    newFilterValue = f"%{filterValue}%"
                    self.cursor.execute(f"SELECT COUNT(*) FROM users WHERE {filterType} LIKE %s AND userRole != 'admin'", (newFilterValue,))
                    totalUsers = self.cursor.fetchone()[0]

                    if totalUsers is not None:
                        pageCount = totalUsers // limit
                        if totalUsers % limit != 0:
                            pageCount += 1

                    self.cursor.execute(f"SELECT * FROM users WHERE {filterType} LIKE %s AND userRole != 'admin' LIMIT %s OFFSET %s", (newFilterValue,limit, offset))
                    result = self.cursor.fetchall()

                else:
                   
                    self.cursor.execute(f"SELECT COUNT(*) FROM users WHERE {filterType} = %s AND userRole != 'admin'", (int(filterValue),))
                    totalUsers = self.cursor.fetchone()[0]

                    if totalUsers is not None:
                        pageCount = totalUsers // limit
                        if totalUsers % limit != 0:
                            pageCount += 1

                    self.cursor.execute(f"SELECT * FROM users WHERE {filterType} = %s AND userRole != 'admin' LIMIT %s OFFSET %s", (int(filterValue),limit, offset))
                    result = self.cursor.fetchall()
                    
            else:

                self.cursor.execute("SELECT * FROM users WHERE userRole != 'admin' LIMIT %s OFFSET %s", (limit, offset))
                result = self.cursor.fetchall()

            if result:

                for r2 in result:
                    add(rV=r2)
                    
            if len(users) == 0:
                return {"success":False,"message":"Sonuç bulunamadı!"}
    
            return {
                "success":True,
                "message":"Kullanıcılar listelendi.",
                "data":{
                    "totalUsers":totalUsers,
                    "users":users,
                    "pageCount":pageCount
                }
            }

        except Exception as e:
            
            writeLog(config.USERS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}

    def updateUser(self,id:int,userName:str,role:str):

        try:
            if not userName.strip() or not role.strip() or id <= 0:
                return {"success": False, "message": "Lütfen boş bırakmayınız!"}
            
            self.cursor.execute("SELECT * FROM users WHERE id = %s",(id,))
            result = self.cursor.fetchone()

            if result is None:
                return {"success": False, "message": "Kullanıcı bulunamadı!"}

            if result[3] == "admin" and role.strip() != "admin":
                return {"success":False,"message":"Yönetici yetkisine sahip kullanıcının rolü değiştirilemez!"}
                
            if len(userName) > 20:
                return {"success": False, "message": "Kullanıcı ismi 20 karakterden fazla olamaz!"}
                  
            self.cursor.execute("SELECT * FROM users WHERE userName = %s",(userName,))
            result = self.cursor.fetchone()
            if result is not None:
                return {"success": False, "message": "Bu kullanıcı adı zaten mevcut!"}
                   
            if role.strip() == "admin":
                return {"success": False, "message": "Güncellenen kullanıcı yönetici yetkisine sahip olamaz!"}
            
            if role.strip() not in ["student_staff", "teacher"]:
                return {"success": False, "message": "Böyle bir yetki seviyesi bulunmamaktadır!"}
            
            self.cursor.execute("UPDATE users SET userName = %s, userRole = %s WHERE id = %s",(userName,"Öğretmen" if role.strip() == "teacher" else "Öğrenci",id))
            self.conn.commit()
                                        
            return {"success": True, "message": "Kullanıcı güncellendi"}
            
        except Exception as e:

            self.conn.rollback()
            writeLog(config.USERS_LOG_PATH,type(e).__name__,str(e))
            return {"success": False, "message": "Bir hata oluştu!"}