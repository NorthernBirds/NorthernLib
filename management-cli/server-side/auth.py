import secrets
import config
from writeLog import writeLog
import bcrypt

def verifyRole(allowedRolesAndToken:list[list[str],str]):

    try:

        result = config.classes["dbProcesses"].giveUserRoleByToken(token=allowedRolesAndToken[1])

        if result["success"] == False:
            return result

        if result["data"]["role"] not in allowedRolesAndToken[0]:
            return {"success":False,"message":"Yetkiniz yok!"}

        return {"success":True}

    except Exception as e:
        writeLog(config.authLogPath,error=type(e).__name__,message=e)
        return {"success":False,"message":"Bir hata oluştu!"}

def verifyAppToken(appToken:str):

    if config.APP_KEY != appToken:
        return {"success":False,"message":"403 Forbidden!"}

    return {"success":True}

def signIn(userName:str,password:str):

    try:

        if userName.replace(" ","") == "" or password.replace(" ","") == "":
            return {"success":False,"message":"Lütfen boş bırakmayın"}

        result = config.classes["dbProcesses"].giveUserData(userName=userName)

        if result["success"] == False:
            return result

        passwordCorrect = bcrypt.checkpw(password=password.encode("utf-8"), hashed_password=result["data"][1].encode("utf-8"))

        if passwordCorrect == False:
            return {"success":False,"message":"Şifre yanlış!"}

        token = secrets.token_hex(32)

        info = config.classes["dbProcesses"].addSession(userID=result["data"][0],token=token)
        
        if info["success"]:
            info["data"] = {"token":token}

        return info

    except Exception as e:
        writeLog(config.authLogPath,error=type(e).__name__,message=e)
        return {"success":False,"message":"Bir hata oluştu!"}