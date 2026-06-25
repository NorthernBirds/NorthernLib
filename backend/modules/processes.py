import config
from utils.writeLog import writeLog
from datetime import datetime

def addProcess(self,userName,process):

    try:

        if userName == "" or process == "":
            return {"success":False,"message":"Lütfen boş bırakmayın!"}
        else:

            self.cursor.execute("INSERT INTO processes (processDate,processTime,userName,process) VALUES (%s,%s,%s,%s)",(datetime.now().strftime("%d.%m.%Y"),datetime.now().strftime("%H:%M:%S"),userName,process))
            self.conn.commit()
            return {"success":True,"message":"işlem eklendi."}

    except Exception as e:

        writeLog(config.PROCESSES_LOG_PATH,type(e).__name__,str(e))
        return {"success":False,"message":"Bir hata oluştu!"}

class Process:

    def __init__(self,conn,cursor):
        
        self.conn = conn
        self.cursor = cursor

    def deleteProcess(self,id,activeUserName):

        try:

            if id == 0:
                return {"success":False,"message":"Lütfen boş bırakmayın!"}
            else:

                self.cursor.execute("SELECT * FROM processes WHERE id = %s",(id,))
                result = self.cursor.fetchone()

                if result is None:
                    return {"success":False,"message":"İşlem bulunamadı!"}
                else:

                    self.cursor.execute("DELETE FROM processes WHERE id = %s",(id,))
                    self.conn.commit()
                    addProcess(userName=activeUserName,process=f"{id} ID'li kayıt silindi.")
                    return {"success":True,"message":"işlem silindi."}
    
        except Exception as e:

            writeLog(config.PROCESSES_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
    
    def listProcesses(self,filterValue,filterType,isWithFilter,pageNumber,limit,activeUserName):

        try:

            if limit == 0:
                return {"success":False,"message":"Lutfen boş bırakmayın!"}
            else:

                if limit > 50:
                    return {"success":False,"message":"Limit en fazla 50 olabilir!"}
                else:

                    IDs,processDates,processTimes,userNames,processes = [],[],[],[],[]
                    offset = ((pageNumber - 1) * limit)

                    self.cursor.execute("SELECT COUNT(*) FROM processes")
                    totalProcesses = self.cursor.fetchone()[0]
                    if totalProcesses is not None:
                        pageCount = totalProcesses // limit
                        if totalProcesses % limit != 0:
                            pageCount += 1

                    def add(rV):
                        IDs.append(rV[0])
                        processDates.append(rV[1])
                        processTimes.append(rV[2])
                        userNames.append(rV[3])
                        processes.append(rV[4])

                    if isWithFilter == True:

                        if filterValue == "" or filterType == "":
                            return {"success":False,"message":"Lütfen boş bırakmayın!"}
                        else:

                            if filterType != "id":
                                if len(filterValue.strip()) < 2:
                                    return {"success":False,"message":"Arama en az 2 karakter olmalıdır!"}
                            
                            self.cursor.execute("SELECT * FROM processes LIMIT %s OFFSET %s", (limit, offset))
                            result = self.cursor.fetchall()

                            if not result:
                                pass
                            else:

                                for r in result:
                                    
                                    for i,j in zip(
                                        range(0,5),
                                        ["id","processDate","processTime","userName","process"]
                                    ):

                                        if filterType == j:

                                            parsed_name = str(r[i]).lower()
                                            if filterType == "id":
                                                if str(filterValue).lower() == parsed_name:
                                                    add(rV=r)
                                            else:
                                                if str(filterValue).lower() in parsed_name:
                                                    add(rV=r)
                    
                    elif isWithFilter == False:

                        self.cursor.execute("SELECT * FROM processes LIMIT %s OFFSET %s", (limit, offset))
                        result2 = self.cursor.fetchall()

                        if not result2:
                            pass
                        else:
                            for r2 in result2:
                                add(rV=r2)
                    

                    if len(IDs) == 0:
                        return {"success":False,"message":"Sonuç bulunamadı!"}
                    else:

                        addProcess(userName=activeUserName,process=f"{f"{filterType} değişkeni {filterValue} olan ve" if isWithFilter == True else ''} {offset + 1} - {(offset + limit) + 1} arasında olan işlemler listelendi.")
                        return {
                            "success":True,
                            "message":f"{totalProcesses} işlem kaydından yalnızca {offset + 1} - {(offset + limit) + 1} arası işlemler listeleniyor.",
                            "data":{
                                "ids":IDs,
                                "processDates":processDates,
                                "processTimes":processTimes,
                                "userNames":userNames,
                                "processes":processes,
                                "pageCount":pageCount
                            }
                        }

                                

        except Exception as e:
            
            writeLog(config.PROCESSES_LOG_PATH,type(e).__name__,str(e))
            return {"success":False,"message":"Bir hata oluştu!"}
