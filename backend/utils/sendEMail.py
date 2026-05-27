import os
import sys

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import smtplib
from email.mime.text import MIMEText
import config
import json
import base64
from writeLog import writeLog

def sendEMail(subject,message):
    
    try:
        
        with open(config.CONFIG_JSON_PATH_FOR_SENDEMAIL,"r",encoding="utf-8") as SMTP_DATA:
            data = json.load(SMTP_DATA)

        PASSWORD = base64.b64decode(data["SMTP_PASSWORD"]).decode("utf-8")
        GMAIL = config.GMAIL

        server = smtplib.SMTP("smtp.gmail.com",587)
        server.starttls()
        server.login(GMAIL,PASSWORD)

        msg = MIMEText(message,"plain","utf-8")
        msg["Subject"] = subject
        msg["From"] = GMAIL
        msg["To"] = GMAIL

        server.sendmail(GMAIL,GMAIL,msg.as_string())
        server.quit()
    
    except Exception as e:

        writeLog(config.SENDEMAIL_LOG_PATH,type(e).__name__,str(e))
        return {
            "success":False,
            "message":"Bir hata oluştu!"
        }


