from datetime import datetime

def writeLog(path,errName,message):

    with open(path,"a",encoding="utf-8") as LOG:
        LOG.write(f"[{datetime.now().strftime('%d.%m.%Y %H:%M:%S')}] ERROR: {errName} MESSAGE: {message} \n")
