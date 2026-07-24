import 'package:flutter/material.dart';
import 'package:frontend/api_requests.dart';
import 'package:frontend/main.dart';
import 'adminDashboard.dart';
import 'student_staffDashboard.dart';
import 'teacherDashboard.dart';

class LoginDashboard extends StatefulWidget {
  const LoginDashboard({super.key});

  @override
  State<LoginDashboard> createState() => _LoginDashboardState();
}

class _LoginDashboardState extends State<LoginDashboard> {
  String dbName = "";
  String dbPassword = "";
  String userName = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/libImage.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: const Color(0xFF3A8772),
            ),
            width: 400.0,
            height: 600.0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Hoşgeldiniz!",
                    style: TextStyle(
                      fontSize: 36,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 300.0,
                      child: TextField(
                        onChanged: (value) {
                          dbName = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Kütüphane adı",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 151, 144, 144),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 300.0,
                      child: TextField(
                        onChanged: (value) {
                          dbPassword = value;
                        },
                        obscureText: true,
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                          hintText: "Kütüphane şifresi",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 151, 144, 144),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 300.0,
                      child: TextField(
                        onChanged: (value) {
                          userName = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Kullanıcı adı",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 151, 144, 144),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 300.0,
                      child: TextField(
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: true,
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                          hintText: "Kullanıcı şifresi",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 151, 144, 144),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      var response = await signIn(
                        dbName: dbName,
                        dbPassword: dbPassword,
                        userName: userName,
                        password: password,
                      );
                      if (response!["success"] == true) {
                        if (response["role"] == "admin") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminDashboard(),
                            ),
                          );
                        } else if (response["role"] == "teacher") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeacherDashboard(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentStaffDashboard(),
                            ),
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Hata"),
                              content: Text(response["message"]),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Tamam"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF3A8772)),
                      backgroundColor: const Color(0xFF3A8772),
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MyHomePage(title: 'NorthernLib'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF3A8772)),
                      backgroundColor: const Color(0xFF3A8772),
                    ),
                    child: const Text(
                      "İptal",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
