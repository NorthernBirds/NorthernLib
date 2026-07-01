import 'package:flutter/material.dart';
import 'package:frontend/api_requests.dart';
import 'package:frontend/main.dart';

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
              color: Colors.white,
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

                  // ŞANLI SIGN IN BUTONU
                  ElevatedButton(
                    onPressed: () async {
                      var response = await signIn(
                        dbName: dbName,
                        dbPassword: dbPassword,
                        userName: userName,
                        password: password,
                      );
                      print(response!["message"]);
                    },
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
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
                      side: const BorderSide(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
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
