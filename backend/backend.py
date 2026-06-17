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

                        authUser = modules.auth.Auth(conn=resultDB["data"]["conn"],cursor=resultDB["data"]["cursor"])
                        book = modules.books.Book(conn=resultDB["data"]["conn"],cursor=resultDB["data"]["cursor"])
                        category = modules.categories.Category(conn=resultDB["data"]["conn"],cursor=resultDB["data"]["cursor"])
                        loan = modules.loans.Loan(conn=resultDB["data"]["conn"],cursor=resultDB["data"]["cursor"])
                        user = modules.users.User(conn=resultDB["data"]["conn"],cursor=resultDB["data"]["cursor"])
                        reset = modules.reset.Reset(conn=resultDB["data"]["conn"],cursor=resultDB["data"]["cursor"])
                        
                        resultLock = authUser.verifyLock()
                        if resultLock["success"] != True:
                            return jsonify(resultLock)
                        else:

                            result3 = authUser.signIn(userName=data.get("userName",""),password=data.get("password",""))

                            if result3["success"] != True:
                                return jsonify(result3)
                            else:

                                config.session[result3["token"]] = {"userName":result3["userName"],"role":result3["role"],"classes":{"auth":authUser,"book":book,"category":category,"loan":loan,"user":user,"reset":reset},"dbValues":{"conn":resultDB["data"]["conn"],"cursor":resultDB["data"]["cursor"]}}

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

        result = checkRoleAndToken(token=data.get("token",""),appToken=data.get("appToken",""), allowedRoles=["admin","teacher","student_staff"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[data.get("token")]["classes"]["book"].deleteBook(id=data.get("id",0)))

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

        result = checkRoleAndToken(token=data.get("token",""),appToken=data.get("appToken",""), allowedRoles=["admin","teacher","student_staff"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[data.get("token")]["classes"]["book"].listBooks(filterType=data.get("filterType",""), filterValue=data.get("filterValue",""), isWithFilter=data.get("isWithFilter","")))

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

        result = checkRoleAndToken(token=data.get("token",""),appToken=data.get("appToken",""), allowedRoles=["admin","teacher"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[data.get("token")]["classes"]["category"].deleteCategory(id=data.get("id",0)))

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

        result = checkRoleAndToken(token=data.get("token",""),appToken=data.get("appToken",""), allowedRoles=["admin","teacher"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[data.get("token")]["classes"]["category"].listCategories(filterType=data.get("filterType",""), filterValue=data.get("filterValue",""), isWithFilter=data.get("isWithFilter","")))

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

        result = checkRoleAndToken(token=data.get("token",""),appToken=data.get("appToken",""), allowedRoles=["admin","teacher","student_staff"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[data.get("token")]["classes"]["loan"].returnBook(bookID=data.get("bookID",0)))

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

        result = checkRoleAndToken(token=data.get("token",""),appToken=data.get("appToken",""), allowedRoles=["admin","teacher","student_staff"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[data.get("token")]["classes"]["loan"].listLoans(filterType=data.get("filterType",""), filterValue=data.get("filterValue",""), isWithFilter=data.get("isWithFilter","")))

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

        result = checkRoleAndToken(token=data.get("token",""),appToken=data.get("appToken",""), allowedRoles=["admin"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[data.get("token")]["classes"]["user"].addUser(userName=data.get("userName",""), password=data.get("password",""), role=data.get("role","")))

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

        result = checkRoleAndToken(token=data.get("token",""),appToken=data.get("appToken",""), allowedRoles=["admin"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[data.get("token")]["classes"]["user"].deleteUser(userName=data.get("userName","")))

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

        result = checkRoleAndToken(token=data.get("token",""),appToken=data.get("appToken",""), allowedRoles=["admin"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[data.get("token")]["classes"]["user"].changeRole(userName=data.get("userName",""), newRole=data.get("newRole","")))

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

        result = checkRoleAndToken(token=data.get("token",""),appToken=data.get("appToken",""), allowedRoles=["admin"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[data.get("token")]["classes"]["user"].listUsers(filterType=data.get("filterType",""), filterValue=data.get("filterValue",""), isWithFilter=data.get("isWithFilter","")))

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

        result = checkRoleAndToken(token=data.get("token",""),appToken=data.get("appToken",""), allowedRoles=["admin"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(config.session[data.get("token")]["classes"]["reset"].reset(books=data.get("books",""), categories=data.get("categories",""), loans=data.get("loans",""), users=data.get("users","")))

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

        result = checkRoleAndToken(token=data.get("token",""),appToken=data.get("appToken",""), allowedRoles=["admin","teacher","student_staff"])

        if result["success"] != True:
            return jsonify(result)
        else:
            return jsonify(auth.signOut(token=data.get("token","")))

    except Exception as e:

        writeLog(config.BACKEND_LOG_PATH,type(e).__name__,str(e))

        return jsonify({
            "success":False,
            "message":"Bir hata oluştu!"
        })


@app.route('/backend/closeDB')
def closeDB():

    try:

        data = request.get_json()

        result = config.session[data.get("token")]["classes"]["auth"].verifyAppToken(appToken=data.get("appToken",""))

        if result["success"] != True:
            return jsonify(result)
        else:
            db.connection.closeConnection(conn=conn)
            config.session.clear()

        return jsonify({
            "success":True,
            "message":"Veritabanı bağlantısı kapatıldı."
        })

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

