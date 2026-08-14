import "config.dart";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:frontend/dashboards/signInDashboard.dart";
import 'utils/writeLog.dart';

final BaseOptions options = BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
  contentType: Headers.jsonContentType,
  responseType: ResponseType.json,
);

final Dio dio = Dio(options)
  ..interceptors.add(
    InterceptorsWrapper(
      onResponse: (response, handler) {
        if (response.data != null &&
            response.data["message"]?.toString().contains(
                  "Oturumunuz zaman aşımına uğradı. Lütfen tekrar giriş yapın.",
                ) ==
                true) {
          session.clear();

          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginDashboard()),
            (route) => false,
          );
        }
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        writeLog(logName: e.type.name, log: e.message ?? "No message");
        return handler.resolve(
          Response(
            requestOptions: e.requestOptions,
            data: {
              "success": false,
              "message":
                  e.response?.data?["message"] ?? "Bağlantı hatası oluştu.",
            },
          ),
        );
      },
    ),
  );

Future<Map<String, dynamic>?> signUp({
  required String dbName,
  required String developerPassword,
}) async {
  var response = await dio.post(
    "/signUp",
    data: {
      "dbName": dbName,
      "developerPassword": developerPassword,
      "appToken": appKey,
    },
  );
  return response.data;
}

Future<Map<String, dynamic>?> signIn({
  required String dbName,
  required String dbPassword,
  required String userName,
  required String password,
}) async {
  var response = await dio.post(
    "/signIn",
    data: {
      "dbName": dbName,
      "dbPassword": dbPassword,
      "userName": userName,
      "password": password,
      "appToken": appKey,
    },
  );
  if (response.data["success"] == true) {
    session["token"] = response.data["token"];
    session["userName"] = response.data["userName"];
    session["role"] = response.data["role"];
    session["duration"] = 0;
  }
  return response.data;
}

Future<Map<String, dynamic>?> addBook({
  required String bookName,
  required String writer,
  required String publisher,
  required String category,
  required int pageCount,
}) async {
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

Future<Map<String, dynamic>?> deleteBook({required int id}) async {
  var response = await dio.post(
    "/deleteBook",
    data: {"id": id, "appToken": appKey, "token": session["token"]},
  );
  return response.data;
}

Future<Map<String, dynamic>?> listBooks({
  required bool isWithFilter,
  required String filterType,
  required String filterValue,
  required int limit,
  required int pageNumber,
}) async {
  var response = await dio.post(
    "/listBooks",
    data: {
      "isWithFilter": isWithFilter,
      "filterType": filterType,
      "filterValue": filterValue,
      "limit": limit,
      "pageNumber": pageNumber,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Map<String, dynamic>?> updateBook({
  required int id,
  required String bookName,
  required String writer,
  required String publisher,
  required String category,
  required int pageCount,
}) async {
  var response = await dio.post(
    "/updateBook",
    data: {
      "id": id,
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

Future<Map<String, dynamic>?> addCategory({
  required String categoryName,
}) async {
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

Future<Map<String, dynamic>?> deleteCategory({required int id}) async {
  var response = await dio.post(
    "/deleteCategory",
    data: {"id": id, "appToken": appKey, "token": session["token"]},
  );
  return response.data;
}

Future<Map<String, dynamic>?> listCategories({
  required bool isWithFilter,
  required String filterType,
  required String filterValue,
  required int limit,
  required int pageNumber,
}) async {
  var response = await dio.post(
    "/listCategories",
    data: {
      "isWithFilter": isWithFilter,
      "filterType": filterType,
      "filterValue": filterValue,
      "limit": limit,
      "pageNumber": pageNumber,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Map<String, dynamic>?> updateCategory({
  required int id,
  required String categoryName,
}) async {
  var response = await dio.post(
    "/updateCategory",
    data: {
      "id": id,
      "categoryName": categoryName,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Map<String, dynamic>?> borrowBook({
  required int studentID,
  required int bookID,
  required String returnDate,
}) async {
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

Future<Map<String, dynamic>?> returnBook({required int bookID}) async {
  var response = await dio.post(
    "/returnBook",
    data: {"bookID": bookID, "appToken": appKey, "token": session["token"]},
  );
  return response.data;
}

Future<Map<String, dynamic>?> listLoans({
  required bool isWithFilter,
  required String filterType,
  required String filterValue,
  required int limit,
  required int pageNumber,
}) async {
  var response = await dio.post(
    "/listLoans",
    data: {
      "isWithFilter": isWithFilter,
      "filterType": filterType,
      "filterValue": filterValue,
      "limit": limit,
      "pageNumber": pageNumber,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Map<String, dynamic>?> updateLoan({
  required int id,
  required int studentID,
  required int bookID,
  required String returnDate,
}) async {
  var response = await dio.post(
    "/updateLoan",
    data: {
      "id": id,
      "studentID": studentID,
      "bookID": bookID,
      "returnDate": returnDate,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Map<String, dynamic>?> listLeaders({
  required int limit,
  required int pageNumber,
}) async {
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

Future<Map<String, dynamic>?> addUser({
  required String userName,
  required String password,
  required String role,
}) async {
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

Future<Map<String, dynamic>?> deleteUser({required int id}) async {
  var response = await dio.post(
    "/deleteUser",
    data: {"id": id, "appToken": appKey, "token": session["token"]},
  );
  return response.data;
}

Future<Map<String, dynamic>?> changeRole({
  required int id,
  required String newRole,
}) async {
  var response = await dio.post(
    "/changeRole",
    data: {
      "id": id,
      "newRole": newRole,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Map<String, dynamic>?> listUsers({
  required bool isWithFilter,
  required String filterType,
  required String filterValue,
  required int limit,
  required int pageNumber,
}) async {
  var response = await dio.post(
    "/listUsers",
    data: {
      "isWithFilter": isWithFilter,
      "filterType": filterType,
      "filterValue": filterValue,
      "limit": limit,
      "pageNumber": pageNumber,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Map<String, dynamic>?> updateUser({
  required int id,
  required String userName,
  required String password,
  required String role,
}) async {
  var response = await dio.post(
    "/addUser",
    data: {
      "id": id,
      "userName": userName,
      "password": password,
      "role": role,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Map<String, dynamic>?> reset({
  required bool books,
  required bool categories,
  required bool loans,
  required bool users,
}) async {
  var response = await dio.post(
    "/reset",
    data: {
      "books": books,
      "categories": categories,
      "loans": loans,
      "users": users,
      "appToken": appKey,
      "token": session["token"],
    },
  );
  return response.data;
}

Future<Map<String, dynamic>?> signOut() async {
  var response = await dio.post(
    "/signOut",
    data: {"appToken": appKey, "token": session["token"]},
  );
  return response.data;
}
