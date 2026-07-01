import bcrypt
from utils.writeLog import writeLog
import config
from modules.processes import addProcess


class User:

    def __init__(self,conn,cursor):

        self.conn = conn
        self.cursor = cursor
    

    def addUser(self,userName:str,password:str,role:str,activeUserName:str):

        try:
            if password == "" or userName == "" or role == "":
                return {"success": False, "message": "Lütfen boş bırakmayınız!"}
            else:
                
                if len(userName) > 20:
                    return {"success": False, "message": "Kullanıcı ismi 20 karakterden fazla olamaz!"}
                else:

                    self.cursor.execute("SELECT * FROM users WHERE userName = %s",(userName,))
                    result = self.cursor.fetchone()
                    if result is not None:
                        return {"success": False, "message": "Bu kullanıcı adı zaten mevcut!"}
                    else:

                        if len(password) < 8 or len(password) > 15:
                            return {"success": False, "message": "Şifre 8 - 15 karakter arasında olmalıdır!"}
                        else:
                            
                            if role == "admin":
                                return {"success": False, "message": "Oluşturulan kullanıcı yönetici yetkisine sahip olamaz!"}
                            else:

                                if role not in ["student_staff", "teacher"]:
                                    return {"success": False, "message": "Böyle bir yetki seviyesi bulunmamaktadır!"}
                                else:

                                    password = password.encode()
                                    hashed = bcrypt.hashpw(password, bcrypt.gensalt())
                                    self.cursor.execute(
                                        "INSERT INTO users (userName,userPassword,userRole) VALUES (%s,%s,%s)",
                                        (userName,hashed.decode(),role)
                                    )
                                    self.conn.commit()
                                    addProcess(userName=activeUserName,process=f"{userName} adlı kullanıcı oluşturuldu.")
                                    return {"success": True, "message": "Kullanıcı oluşturuldu"}
            
        except Exception as e:

            writeLog(config.USERS_LOG_PATH,type(e).__name__,str(e))
            return {"success": False, "message": "Bir hata oluştu!"}
    

    def deleteUser(self,id:int,activeUserName:str):

        try:
            if id == 0:
                return {"success": False, "message": "Lütfen boş bırakmayın!"}
            else:

                self.cursor.execute("SELECT * FROM users WHERE id = %s",(id,))
                result = self.cursor.fetchone()
                if result is None:
                    return {"success": False, "message": "Kullanıcı bulunamadı!"}
                else:

                    if result[3] == 'admin':
                        return {"success": False, "message": "Yönetici yetkisine sahip kullanıcı silinemez!"}
                    else:
                        
                        self.cursor.execute("DELETE FROM users WHERE id = %s",(id,))
                        self.conn.commit()
                        addProcess(userName=activeUserName,process=f"{id} ID'li kullanıcı silindi.")
                        return {"success": True, "message": "Kullanıcı silindi"}
            
        except Exception as e:

            writeLog(config.USERS_LOG_PATH,type(e).__name__,str(e))
            return {"success": False, "message": "Bir hata oluştu!"}
    

    def changeRole(self,userName:str,newRole:str,activeUserName:str):

        try:
            if userName == "" or newRole == "":
                return {"success": False, "message": "Lütfen boş bırakmayın!"}
            else:

                self.cursor.execute("SELECT * FROM users WHERE userName = %s",(userName,))
                result = self.cursor.fetchone()
                if result is None:
                    return {"success": False, "message": "Kullanıcı bulunamadı!"}
                else:
                    
                    if newRole == "admin":
                        return {"success": False, "message": "Oluşturulan kullanıcı yönetici yetkisine sahip olamaz!"}
                    else:

                        if newRole not in ["student_staff", "teacher"]:
                            return {"success": False, "message": "Böyle bir yetki seviyesi bulunmamaktadır!"}
                        else:

                            if result[3] == newRole:
                                return {"success": False, "message": "Bu kullanıcı zaten bu role sahip!"}
                            else:

                                self.cursor.execute(
                                    "UPDATE users SET userRole = %s WHERE userName = %s",
                                    (newRole,userName)
                                )
                                self.conn.commit()
                                addProcess(userName=activeUserName,process=f"{userName} adlı kullanıcının rolü {newRole} olarak değiştirildi.")
                                return {"success": True, "message": "Rol güncellendi."}
                            
        except Exception as e:

            writeLog(config.USERS_LOG_PATH,type(e).__name__,str(e))
            return {"success": False, "message": "Bir hata oluştu!"}
    

    def listUsers(self,filterValue:str,filterType:str,isWithFilter:bool | str,pageNumber:int,limit:int,activeUserName:str):

        try:

            if limit == 0:
                return {"success":False,"message":"Lutfen boş bırakmayın!"}
            else:

                if limit > 50:
                    return {"success":False,"message":"Limit en fazla 50 olabilir!"}
                else:

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
                    
                    if isWithFilter == True:

                        if filterValue == "" or filterType == "":
                            return {"success":False,"message":"Lütfen boş bırakmayın!"}
                        else:

                            if filterType != "id":
                                if len(filterValue.strip()) < 2:
                                    return {"success":False,"message":"Arama en az 2 karakter olmalıdır!"}

                            self.cursor.execute("SELECT * FROM users LIMIT %s OFFSET %s", (limit, offset))
                            result = self.cursor.fetchall()

                            if not result:
                                pass
                            else:
                                
                                for r in result:

                                    for i,j in zip(
                                        range(0,3),
                                        ["id","userName","role"]
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

                        self.cursor.execute("SELECT * FROM users LIMIT %s OFFSET %s", (limit, offset))
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
                        
                        addProcess(userName=activeUserName,process=f"{f"{filterType} değişkeni {filterValue} olan ve" if isWithFilter == True else ''} {offset + 1} - {(offset + limit) + 1} arasında olan kullanıcılar listelendi.")
                        return {
                            "success":True,
                            "message":f"{totalUsers} kullanıcı kaydından yalnızca {offset + 1} - {(offset + limit) + 1} arası kullanıcılar listeleniyor.",
                            "data":{
                                "ids":IDs,
                                "userNames":userNames,
                                "roles":roles,
                                "pageCount":pageCount
                            }
                        }

        except Exception as e:
            
            writeLog(config.USERS_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}