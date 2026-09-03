import dbProcesses
import auth
import config
import ssl
from flask import Flask,request,jsonify
from flask_cors import CORS
import threading
import sys

app = Flask(__name__)
CORS(app)

result = dbProcesses.connect()

if result["success"] == False:
    sys.exit(1)

config.classes["dbProcesses"] = dbProcesses.Process(conn=result["data"]["conn"])

thread = threading.Thread(target=config.classes["dbProcesses"].durationHeartbeat,daemon=True)
thread.start()
event = threading.Event()
event.set()

def authentication(allowedRoles:list,data):

    event.clear()

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
        config.classes["dbProcesses"].resetDuration(token=userToken)
        event.set()
        return {"success":True}
     

@app.route("/kernel/signIn",methods=['POST'])
def signIn():

    try:

        data = request.get_json()

        result = auth.verifyAppToken()
        if result["success"] == False:
            return jsonify(result)

        return jsonify(auth.signIn(userName=data.get("userName",""),password=data.get("password","")))

    except Exception as e:

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

        return {"success":False,"message":"Bir hata oluştu!"}

@app.route("/kernel/addLicense",methods=['POST'])
def addLicense():

    try:

        data = request.get_json()

        result = authentication(allowedRoles=["admin","user"],data=data)

        if result["success"] == False:
            return jsonify(result)

        return jsonify(config.classes["dbProcesses"].allLicense(count=data.get("count",0)))

    except Exception as e:

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

        return {"success":False,"message":"Bir hata oluştu!"}

if __name__ == "__main__":
    app.run(host="127.0.0.1",port=8000,debug=False)