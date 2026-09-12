import 'package:flutter/material.dart';
import 'package:frontend/api_requests.dart';
import 'package:frontend/main.dart';
import 'dashboard.dart';
import 'package:frontend/config.dart';

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
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/libImage.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: 16.0,
                      ),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: color,
                      ),
                      width: 400.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          const SizedBox(height: 16.0),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                          const SizedBox(height: 16.0),

                          ElevatedButton(
                            onPressed: () async {
                              var response = await signIn(
                                dbName: dbName,
                                dbPassword: dbPassword,
                                userName: userName,
                                password: password,
                              );
                              if (response!["success"] == true) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Dashboard(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
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
                              backgroundColor: color,
                            ),
                            child: const Text(
                              "Giriş Yap",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyHomePage(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF3A8772)),
                              backgroundColor: color,
                            ),
                            child: const Text(
                              "İptal",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
