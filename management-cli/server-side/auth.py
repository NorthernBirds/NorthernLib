import secrets
import config

def verifyRole(allowedRolesAndToken):

    try:

        result = config.classes["dbProcesses"].giveUserRoleByToken(token=allowedRolesAndToken[1])

        if result["success"] == False:
            return result

        if result["data"]["role"] not in allowedRolesAndToken[0]:
            return {"success":False,"message":"Yetkiniz yok!"}

        return {"success":True}

    except Exception as e:

        return {"success":False,"message":"Bir hata oluştu!"}

def verifyAppToken(appToken):

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

        if result["data"][1] != password:
            return {"success":False,"message":"Şifre yanlış!"}

        return config.classes["dbProcesses"].addSession(userID=result[0],token=secrets.token_hex(32))

    except Exception as e:

        return {"success":False,"message":"Bir hata oluştu!"}