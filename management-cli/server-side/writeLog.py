from datetime import datetime

def writeLog(path,error,message):
    with open(path,"a",encoding="utf-8") as log:
        log.write(f"[{datetime.now().strftime("%d/%m/%Y %H:%M:%S")}] ERROR: {error} MESSAGE: {message}\n")