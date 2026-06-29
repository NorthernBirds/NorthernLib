import "config.dart";
import "package:dio/dio.dart";

final BaseOptions options = BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: Duration(seconds: 10),
  receiveTimeout: Duration(seconds: 10),
  contentType: Headers.jsonContentType,
  responseType: ResponseType.json,
);

final Dio dio = Dio(options);

Future<Response> signUp(String dbName) async {
  var response = await dio.post(
    "/setup",
    data: {"dbName": dbName, "appToken": appKey},
  );
  return response.data;
}

Future<Response> signIn(
  String dbName,
  String dbPassword,
  String userName,
  String password,
) async {
  var response = await dio.post(
    "/signin",
    data: {
      "dbName": dbName,
      "dbPassword": dbPassword,
      "userName": userName,
      "password": password,
      "appToken": appKey,
    },
  );
  session["token"] = response.data["token"];
  session["userName"] = response.data["userName"];
  session["role"] = response.data["role"];

  return response.data;
}

Future<Response> addBook(
  String bookName,
  String writer,
  String publisher,
  String category,
  int pageCount,
) async {
  var response = await dio.post(
    "/addBook",
    data: {
      "bookName": bookName,
      "writer": writer,
      "publisher": publisher,
      "category": category,
      "pageCount": pageCount,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Response> deleteBook(int id) async {
  var response = await dio.post(
    "/deleteBook",
    data: {"id": id, "appToken": appKey, "token": session["token"]},
  );
  return response.data;
}

Future<Response> listBooks(
  bool isWithFilter,
  String filterFormat,
  String filterValue,
  int limit,
  int pageNumber,
) async {
  var response = await dio.post(
    "/listBooks",
    data: {
      "isWithFilter": isWithFilter,
      "filterFormat": filterFormat,
      "filterValue": filterValue,
      "limit": limit,
      "pageNumber": pageNumber,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Response> addCategory(String categoryName) async {
  var response = await dio.post(
    "/addCategory",
    data: {
      "categoryName": categoryName,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Response> deleteCategory(int id) async {
  var response = await dio.post(
    "/deleteCategory",
    data: {"id": id, "appToken": appKey, "token": session["token"]},
  );
  return response.data;
}

Future<Response> listCategories(
  bool isWithFilter,
  String filterFormat,
  String filterValue,
  int limit,
  int pageNumber,
) async {
  var response = await dio.post(
    "/listCategories",
    data: {
      "isWithFilter": isWithFilter,
      "filterFormat": filterFormat,
      "filterValue": filterValue,
      "limit": limit,
      "pageNumber": pageNumber,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Response> borrowBook(
  int studentID,
  int bookID,
  String returnDate,
) async {
  var response = await dio.post(
    "/borrowBook",
    data: {
      "studentID": studentID,
      "bookID": bookID,
      "returnDate": returnDate,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Response> returnBook(int bookID) async {
  var response = await dio.post(
    "/returnBook",
    data: {"bookID": bookID, "appToken": appKey, "token": session["token"]},
  );
  return response.data;
}

Future<Response> listLoans(
  bool isWithFilter,
  String filterFormat,
  String filterValue,
  int limit,
  int pageNumber,
) async {
  var response = await dio.post(
    "/listLoans",
    data: {
      "isWithFilter": isWithFilter,
      "filterFormat": filterFormat,
      "filterValue": filterValue,
      "limit": limit,
      "pageNumber": pageNumber,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Response> listLeaders(int limit, int pageNumber) async {
  var response = await dio.post(
    "/listLeaders",
    data: {
      "limit": limit,
      "pageNumber": pageNumber,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Response> addUser(String userName, String password, String role) async {
  var response = await dio.post(
    "/addUser",
    data: {
      "userName": userName,
      "password": password,
      "role": role,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Response> deleteUser(int id) async {
  var response = await dio.post(
    "/deleteUser",
    data: {"id": id, "appToken": appKey, "token": session["token"]},
  );
  return response.data;
}

Future<Response> changeRole(String userName, String newRole) async {
  var response = await dio.post(
    "/changeRole",
    data: {
      "userName": userName,
      "newRole": newRole,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Response> listUsers(
  bool isWithFilter,
  String filterFormat,
  String filterValue,
  int limit,
  int pageNumber,
) async {
  var response = await dio.post(
    "/listUsers",
    data: {
      "isWithFilter": isWithFilter,
      "filterFormat": filterFormat,
      "filterValue": filterValue,
      "limit": limit,
      "pageNumber": pageNumber,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Response> deleteProcess(int id) async {
  var response = await dio.post(
    "/deleteProcess",
    data: {"id": id, "appToken": appKey, "token": session["token"]},
  );
  return response.data;
}

Future<Response> listProcesses(
  bool isWithFilter,
  String filterFormat,
  String filterValue,
  int limit,
  int pageNumber,
) async {
  var response = await dio.post(
    "/listProcesses",
    data: {
      "isWithFilter": isWithFilter,
      "filterFormat": filterFormat,
      "filterValue": filterValue,
      "limit": limit,
      "pageNumber": pageNumber,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Response> reset(
  bool books,
  bool categories,
  bool loans,
  bool users,
  bool processes,
) async {
  var response = await dio.post(
    "/reset",
    data: {
      "books": books,
      "categories": categories,
      "loans": loans,
      "users": users,
      "processes": processes,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Response> signOut() async {
  var response = await dio.post(
    "/signOut",
    data: {"appToken": appKey, "token": session["token"]},
  );
  return response.data;
}
