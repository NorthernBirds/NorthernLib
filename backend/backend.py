import db.connection
from flask import Flask, request, jsonify
from flask_cors import CORS
import os
import ssl

session = config.session
developingMode = True

resultDB1 = db.connection.getDB(dbName="library",password="Kutuphane@Yonetim#2026!",dbUser="admin")

conn = resultDB1["data"]["conn"]
cursor = resultDB1["data"]["cursor"]

import modules.auth
import modules.books
import modules.categories
import modules.loans
import modules.reset
import modules.users
import modules.leaders
import modules.processes
from utils.writeLog import writeLog

auth = modules.auth.Auth(conn=conn,cursor=cursor)

app = Flask(__name__)
CORS(app)

def checkRoleAndToken(token,appToken,allowedRoles):

    result = auth.verifyUserToken(token=token)
    
    if result["success"] != True:
        return result
    else:

        result = config.session[token]["classes"]["auth"].verifyAppToken(appToken=appToken,withLock=True)

        if result["success"] != True:
            return result
        else:

            result = config.session[token]["classes"]["auth"].verifyLock()

            if result["success"] != True:
                return result
            else:

                if config.session[token]["role"] not in allowedRoles:
                    return {
                        "success":False,
                        "message":"Yetkiniz yok!"
                    }
                
                else:

                    return {
                        "success":True
                    }

@app.route('/backend/signUp',methods=['POST'])
def signUp():

    try:

        data = request.get_json()

        result = auth.verifyAppToken(appToken=data.get("appToken",""),withLock=False)

        if result["success"] != True:
            return jsonify(result)
        else:

            return jsonify(auth.signUp(dbName=data.get("dbName","")))
    
    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })

@app.route('/backend/signIn', methods=['POST'])
def signIn():

    try:

            data = request.get_json()

            result = auth.verifyAppToken(appToken=data.get("appToken",""),withLock=False)

            if result["success"] != True:
                return jsonify(result)
            else:

                result2 = auth.signInDB(dbName=data.get("dbName",""),dbPassword=data.get("dbPassword",""))

                if result2["success"] != True:
                    return jsonify(result2)
                else:

                    resultDB = db.connection.getDB(dbName=data.get("dbName",""),password=data.get("dbPassword",""),dbUser="admin"+"_"+data.get("dbName",""))

                    if resultDB["success"] != True:
                        return jsonify(resultDB)
                    else:

                        conn = resultDB["data"]["conn"]
                        cursor = resultDB["data"]["cursor"]

                        authUser = modules.auth.Auth(conn=conn,cursor=cursor)
                        book = modules.books.Book(conn=conn,cursor=cursor)
                        category = modules.categories.Category(conn=conn,cursor=cursor)
                        loan = modules.loans.Loan(conn=conn,cursor=cursor)
                        user = modules.users.User(conn=conn,cursor=cursor)
                        reset = modules.reset.Reset(conn=conn,cursor=cursor)
                        leader = modules.leaders.Leader(conn=conn,cursor=cursor)
                        process = modules.processes.Process(conn=conn,cursor=cursor)

                        resultLock = authUser.verifyLock()
                        if resultLock["success"] != True:
                            return jsonify(resultLock)
                        else:

                            result3 = authUser.signIn(userName=data.get("userName",""),password=data.get("password",""))

                            if result3["success"] != True:
                                return jsonify(result3)
                            else:

                                config.session[result3["token"]] = {"userName":result3["userName"],"role":result3["role"],"classes":{"auth":authUser,"book":book,"category":category,"loan":loan,"user":user,"reset":reset,"leader":leader},"dbValues":{"conn":conn,"cursor":cursor}}

                                return jsonify(result3)
   
    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })

@app.route('/backend/addBook',methods=['POST'])
def addBook():

    try:

        data = request.get_json()
        token = data.get("token","")

        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin","teacher","student_staff"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[token]["classes"]["book"].addBook(bookName=data.get("bookName",""), writer=data.get("writer",""), category=data.get("category",""), publisher=data.get("publisher",""), pageCount=data.get("pageCount",0),activeUserName=config.session[token]["userName"]))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })


@app.route('/backend/deleteBook',methods=['POST'])
def deleteBook():

    try:

        data = request.get_json()
        token = data.get("token","")

        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin","teacher","student_staff"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[token]["classes"]["book"].deleteBook(id=data.get("id",0),activeUserName=config.session[token]["userName"]))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })


@app.route('/backend/listBooks',methods=['POST'])
def listBooks():

    try:

        data = request.get_json()
        token = data.get("token","")

        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin","teacher","student_staff"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[token]["classes"]["book"].listBooks(filterType=data.get("filterType",""), filterValue=data.get("filterValue",""), isWithFilter=data.get("isWithFilter",""), pageNumber=data.get("pageNumber",1), limit=data.get("limit",20),activeUserName=config.session[token]["userName"]))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })


@app.route('/backend/addCategory',methods=["POST"])
def addCategory():

    try:

        data = request.get_json()
        token = data.get("token","")

        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin","teacher"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[token]["classes"]["category"].addCategory(categoryName=data.get("categoryName",""),activeUserName=config.session[token]["userName"]))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })


@app.route('/backend/deleteCategory',methods=['POST'])
def deleteCategory():

    try:

        data = request.get_json()
        token = data.get("token","")
        
        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin","teacher"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[token]["classes"]["category"].deleteCategory(id=data.get("id",0),activeUserName=config.session[token]["userName"]))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })


@app.route('/backend/listCategories',methods=['POST'])
def listCategories():

    try:

        data = request.get_json()
        token = data.get("token","")

        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin","teacher"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[token]["classes"]["category"].listCategories(filterType=data.get("filterType",""), filterValue=data.get("filterValue",""), isWithFilter=data.get("isWithFilter",""), pageNumber=data.get("pageNumber",1), limit=data.get("limit",20),activeUserName=config.session[token]["userName"]))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })

@app.route('/backend/borrowBook',methods=["POST"])
def borrowBook():

    try:

        data = request.get_json()
        token = data.get("token","")

        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin","teacher","student_staff"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[token]["classes"]["loan"].borrowBook(bookID=data.get("bookID",0), studentID=data.get("studentID",0), returnDate=data.get("returnDate",""),activeUserName=config.session[token]["userName"]))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })


@app.route('/backend/returnBook',methods=['POST'])
def returnBook():

    try:

        data = request.get_json()
        token = data.get("token","")

        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin","teacher","student_staff"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[token]["classes"]["loan"].returnBook(bookID=data.get("bookID",0),activeUserName=config.session[token]["userName"]))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })


@app.route('/backend/listLoans',methods=['POST'])
def listLoans():

    try:

        data = request.get_json()
        token = data.get("token","")

        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin","teacher","student_staff"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[token]["classes"]["loan"].listLoans(filterType=data.get("filterType",""), filterValue=data.get("filterValue",""), isWithFilter=data.get("isWithFilter",""), pageNumber=data.get("pageNumber",1), limit=data.get("limit",20), activeUserName=config.session[token]["userName"]))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })
    

@app.route('/backend/listLeaders',methods=['POST'])
def listLeaders():
    
    try:

        data = request.get_json()
        token = data.get("token","")

        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin","teacher"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[token]["classes"]["leader"].listLeaders(pageNumber=data.get("pageNumber",1), limit=data.get("limit",10), activeUserName=config.session[token]["userName"]))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })


@app.route('/backend/addUser',methods=['POST'])
def addUser():

    try:

        data = request.get_json()
        token = data.get("token","")

        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[token]["classes"]["user"].addUser(userName=data.get("userName",""), password=data.get("password",""), role=data.get("role",""),activeUserName=config.session[token]["userName"]))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })


@app.route('/backend/deleteUser',methods=['POST'])
def deleteUser():

    try:

        data = request.get_json()
        token = data.get("token","")

        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[token]["classes"]["user"].deleteUser(id=data.get("id",0), activeUserName=config.session[token]["userName"]))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })


@app.route('/backend/changeRole',methods=['POST'])
def changeRole():

    try:

        data = request.get_json()
        token = data.get("token","")

        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[token]["classes"]["user"].changeRole(userName=data.get("userName",""), newRole=data.get("newRole",""), activeUserName=config.session[token]["userName"]))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })

@app.route('/backend/listUsers',methods=['POST'])
def listUsers():

    try:

        data = request.get_json()
        token = data.get("token","")

        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[token]["classes"]["user"].listUsers(filterType=data.get("filterType",""), filterValue=data.get("filterValue",""), isWithFilter=data.get("isWithFilter",""), pageNumber=data.get("pageNumber",1), limit=data.get("limit",20), activeUserName=config.session[token]["userName"]))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })

@app.route('/backend/deleteProcess',methods=['POST'])
def deleteProcess():

    try:

        data = request.get_json()
        token = data.get("token","")

        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[token]["classes"]["process"].deleteProcess(id=data.get("id",0),activeUserName=config.session[token]["userName"]))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })

@app.route('/backend/listProcesses',methods=['POST'])
def listProcesses():

    try:

        data = request.get_json()
        token = data.get("token","")

        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[token]["classes"]["process"].listProcesses(filterType=data.get("filterType",""), filterValue=data.get("filterValue",""), isWithFilter=data.get("isWithFilter",""), pageNumber=data.get("pageNumber",1), limit=data.get("limit",20), activeUserName=config.session[token]["userName"]))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })

@app.route('/backend/reset',methods=['POST'])
def reset():

    try:

        data = request.get_json()
        token = data.get("token","")

        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[token]["classes"]["reset"].reset(books=data.get("books",""), categories=data.get("categories",""), loans=data.get("loans",""), users=data.get("users",""), processes=data.get("processes",""), activeUserName=config.session[token]["userName"]))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })


@app.route('/backend/signOut',methods=['POST'])
def signOut():

    try:

        data = request.get_json()
        token = data.get("token","")

        result = checkRoleAndToken(token=token,appToken=data.get("appToken",""), allowedRoles=["admin","teacher","student_staff"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(auth.signOut(token=token))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })


if __name__ == "__main__":
    if developingMode == True:
        app.run(host="127.0.0.1",port=5000,debug=True)
    else:
            
        if os.path.exists(config.CERTIFICATE) and os.path.exists(config.KEY):
            context = ssl.SSLContext(protocol=ssl.PROTOCOL_TLS_SERVER)
            context.load_cert_chain(certfile=config.CERTIFICATE,keyfile=config.KEY)
            app.run(host="0.0.0.0",port=5000,ssl_context=context,debug=False)

