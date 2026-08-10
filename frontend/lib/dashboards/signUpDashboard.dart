import 'package:flutter/material.dart';
import 'package:frontend/api_requests.dart';
import 'package:frontend/main.dart';
import 'package:frontend/config.dart';

class signUpDash extends StatefulWidget {
  const signUpDash({super.key});

  @override
  State<signUpDash> createState() => _signUpStateDash();
}

class _signUpStateDash extends State<signUpDash> {
  String dbName = "";
  String developerPassword = "";

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
              color: color,
            ),
            width: 400.0,
            height: 500.0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Kayıt Ol",
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
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
                          developerPassword = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Yönetici Şifresi",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        obscureText: true,
                        obscuringCharacter: '*',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var response = await signUp(
                        dbName: dbName,
                        developerPassword: developerPassword,
                      );
                      if (response!["success"] != true) {
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
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Kayıt Başarılı!"),
                              content: Text(
                                "Admin kullanıcı adı: admin admin\n"
                                "Admin şifresi: ${response["data"]?["adminPassword"] ?? "Bilinmiyor"}\n"
                                "Kütüphane adı: $dbName\n"
                                "Kütüphane şifresi: ${response["data"]?["dbPassword"] ?? "Bilinmiyor"}",
                              ),
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
                      side: BorderSide(color: color),
                      backgroundColor: color,
                    ),
                    child: const Text(
                      "Kayıt Ol",
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
                      backgroundColor: color,
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
