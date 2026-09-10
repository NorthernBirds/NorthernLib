import dbProcesses
import auth
import config
import ssl
from flask import Flask,request,jsonify
from flask_cors import CORS
import sys
from writeLog import writeLog
import os

developingMode = False

app = Flask(__name__)
CORS(app)

result = dbProcesses.connect()

if result["success"] == False:
    sys.exit(1)

config.classes["dbProcesses"] = dbProcesses.Process(conn=result["data"]["conn"])

def authentication(allowedRoles:list,data):

    userToken = data.get("userToken","")
    appToken = data.get("appToken","")

    funcs = {
        "verifyUserToken":
        config.classes["dbProcesses"].verifyUserTokenDB,
        "verifyAppToken":
        auth.verifyAppToken,
        "verifyRole":
        auth.verifyRole}

    for i,j in zip(funcs.keys(),[userToken,appToken,[allowedRoles,userToken]]):
        result = funcs[i](j)
        if result["success"] == False:
            return result
    else:
        
        return {"success":True}
     

@app.route("/kernel/signIn",methods=['POST'])
def signIn():

    try:

        data = request.get_json()

        result = auth.verifyAppToken(appToken=data.get("appToken",""))
        if result["success"] == False:
            return jsonify(result)

        return jsonify(auth.signIn(userName=data.get("userName",""),password=data.get("password","")))

    except Exception as e:
        writeLog(config.kernelLogPath,error=type(e).__name__,message=e)
        return {"success":False,"message":"Bir hata oluştu!"}

@app.route("/kernel/listLibs",methods=['POST'])
def listLibs():

    try:

        data = request.get_json()

        result = authentication(allowedRoles=["admin","user"],data=data)

        if result["success"] == False:
            return jsonify(result)

        return jsonify(config.classes["dbProcesses"].listLibs())

    except Exception as e:
        writeLog(config.kernelLogPath,error=type(e).__name__,message=e)
        return {"success":False,"message":"Bir hata oluştu!"}

@app.route("/kernel/terminateLib",methods=['POST'])
def terminateLib():

    try:

        data = request.get_json()

        result = authentication(allowedRoles=["admin"],data=data)

        if result["success"] == False:
            return jsonify(result)

        return jsonify(config.classes["dbProcesses"].terminateLib(lid=data.get("lid",1)))
    
    except Exception as e:
        writeLog(config.kernelLogPath,error=type(e).__name__,message=e)
        return {"success":False,"message":"Bir hata oluştu!"}

@app.route("/kernel/addLicense",methods=['POST'])
def addLicense():

    try:

        data = request.get_json()

        result = authentication(allowedRoles=["admin","user"],data=data)

        if result["success"] == False:
            return jsonify(result)
        
        return jsonify(config.classes["dbProcesses"].addLicense(count=data.get("count",0)))

    except Exception as e:
        writeLog(config.kernelLogPath,error=type(e).__name__,message=e)
        return {"success":False,"message":"Bir hata oluştu!"}

@app.route("/kernel/activateLicense",methods=['POST'])
def activateLicense():

    try:

        data = request.get_json()

        result = authentication(allowedRoles=["admin"],data=data)

        if result["success"] == False:
            return jsonify(result)

        return jsonify(config.classes["dbProcesses"].activateLicense(lcid=data.get("lcid")))

    except Exception as e:
        writeLog(config.kernelLogPath,error=type(e).__name__,message=e)
        return {"success":False,"message":"Bir hata oluştu!"}

@app.route("/kernel/disableLicense",methods=['POST'])
def disableLicense():

    try:

        data = request.get_json()

        result = authentication(allowedRoles=["admin"],data=data)

        if result["success"] == False:
            return jsonify(result)

        return jsonify(config.classes["dbProcesses"].disableLicense(lcid=data.get("lcid")))

    except Exception as e:
        writeLog(config.kernelLogPath,error=type(e).__name__,message=e)
        return {"success":False,"message":"Bir hata oluştu!"}

@app.route("/kernel/listLicenses",methods=['POST'])
def listLicenses():

    try:

        data = request.get_json()

        result = authentication(allowedRoles=["admin","user"],data=data)

        if result["success"] == False:
            return jsonify(result)

        return jsonify(config.classes["dbProcesses"].listLicenses())

    except Exception as e:
        writeLog(config.kernelLogPath,error=type(e).__name__,message=e)
        return {"success":False,"message":"Bir hata oluştu!"}

@app.route("/kernel/listProcesses",methods=['POST'])
def listProcesses():

    try:

        data = request.get_json()

        result = authentication(allowedRoles=["admin"],data=data)

        if result["success"] == False:
            return jsonify(result)

        return jsonify(config.classes["dbProcesses"].listProcesses())

    except Exception as e:
        writeLog(config.kernelLogPath,error=type(e).__name__,message=e)
        return {"success":False,"message":"Bir hata oluştu!"}

@app.route("/kernel/killProcess",methods=['POST'])
def killProcess():

    try:

        data = request.get_json()

        result = authentication(allowedRoles=["admin"],data=data)

        if result["success"] == False:
            return jsonify(result)

        return jsonify(config.classes["dbProcesses"].killProcess(pid=data.get("pid","")))

    except Exception as e:
        writeLog(config.kernelLogPath,error=type(e).__name__,message=e)
        return {"success":False,"message":"Bir hata oluştu!"}
    
@app.route("/kernel/signOut",methods=['POST'])
def signOut():

    try:

        data = request.get_json()

        result = authentication(allowedRoles=["admin","user"],data=data)

        if result["success"] == False:
            return jsonify(result)

        return jsonify(config.classes["dbProcesses"].signOut(token=data.get("token","")))

    except Exception as e:
        writeLog(config.kernelLogPath,error=type(e).__name__,message=e)
        return {"success":False,"message":"Bir hata oluştu!"}

if __name__ == "__main__":
    if developingMode:
        app.run(host="127.0.0.1",port=8000,debug=True)
    else:
        if os.path.exists(path=config.KEY) and os.path.exists(path=config.CERTIFICATE):
            context = ssl.SSLContext(protocol=ssl.PROTOCOL_TLS_SERVER)
            context.load_cert_chain(keyfile=config.KEY,certfile=config.CERTIFICATE)
            app.run(host="10.156.231.11",port=8000,ssl_context=context,debug=False)
