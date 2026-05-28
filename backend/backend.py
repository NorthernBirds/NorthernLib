import db.connection
import modules.auth
import modules.books
import modules.categories
import modules.loans
import modules.reset
import modules.users
import config
from utils.writeLog import writeLog
from flask import Flask, request, jsonify
from flask_cors import CORS

session = {}
APP_KEY = "6e42022fafe7b0e4f993591cb58448a0e65ef9afb75e54e654fc0437076cce85"

cursor,conn = db.connection.getDB()

auth = modules.auth.Auth(conn=conn,cursor=cursor)
book = modules.books.Book(conn=conn,cursor=cursor)
category = modules.categories.Category(conn=conn,cursor=cursor)
loan = modules.loans.Loan(conn=conn,cursor=cursor)
user = modules.users.User(conn=conn,cursor=cursor)

app = Flask(__name__)
CORS(app)

def checkRoleAndToken(token,appToken,allowedRoles):

    result = auth.verifyToken(token=token,appToken=appToken)

    if result["success"] != True:
        return result

    if session[token]["role"] not in allowedRoles:
        return {
            "success":False,
            "message":"Yetkiniz yok!"
        }

    return {
        "success":True
    }


@app.route('/backend/signIn', methods=['POST'])
def signIn():

    try:

        data = request.get_json()

        result = auth.signIn(userName=data.get("userName",""),password=data.get("password",""))

        if result["success"] == True:

            session[result["token"]] = {
                "role":result["role"],"userName":result["userName"]
            }

        return jsonify(result)

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
            return jsonify(book.addBook(bookName=data.get("bookName",""), writer=data.get("writer",""), category=data.get("category",""), publisher=data.get("publisher",""), pageCount=data.get("pageCount",0),activeUserName=session[token]["userName"]))

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
            return jsonify(book.deleteBook(id=data.get("id",0)))

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
            return jsonify(book.listBooks(filterType=data.get("filterType",""), filterValue=data.get("filterValue",""), isWithFilter=data.get("isWithFilter","")))

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
            return jsonify(category.addCategory(categoryName=data.get("categoryName",""),activeUserName=session[token]["userName"]))

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
            return jsonify(category.deleteCategory(id=data.get("id",0)))

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
            return jsonify(category.listCategories(filterType=data.get("filterType",""), filterValue=data.get("filterValue",""), isWithFilter=data.get("isWithFilter","")))

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
            return jsonify(loan.borrowBook(bookID=data.get("bookID",0), studentID=data.get("studentID",0), returnDate=data.get("returnDate",""),activeUserName=session[token]["userName"]))

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
            return jsonify(loan.returnBook(bookID=data.get("bookID",0)))

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
            return jsonify(loan.listLoans(filterType=data.get("filterType",""), filterValue=data.get("filterValue",""), isWithFilter=data.get("isWithFilter","")))

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
            return jsonify(user.addUser(userName=data.get("userName",""), password=data.get("password",""), role=data.get("role","")))

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
            return jsonify(user.deleteUser(userName=data.get("userName","")))

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
            return jsonify(user.changeRole(userName=data.get("userName",""), newRole=data.get("newRole","")))

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
            return jsonify(user.listUsers(filterType=data.get("filterType",""), filterValue=data.get("filterValue",""), isWithFilter=data.get("isWithFilter","")))

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
            return jsonify(modules.reset.reset(conn=conn, cursor=cursor, books=data.get("books",""), categories=data.get("categories",""), loans=data.get("loans",""), users=data.get("users","")))

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

        db.connection.closeConnection(conn=conn)

        session.clear()

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
    if os.path.exists(config.CERTIFICATE) and os.path.exists(config.KEY):
        context = ssl.SSLContext(protocol=ssl.PROTOCOL_TLS_SERVER)
        context.load_cert_chain(certfile=config.CERTIFICATE,keyfile=config.KEY)
        app.run(host="0.0.0.0",port=5000,ssl_context=context,debug=False)
    else:
        app.run(host="127.0.0.1",port=5000,debug=True)