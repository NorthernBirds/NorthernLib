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
  String licenseKey = "";

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
                physics: const BouncingScrollPhysics(),
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
                            "Kayıt Ol",
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
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
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
                                  licenseKey = value;
                                },
                                decoration: InputDecoration(
                                  hintText: "Lisans Anahtarı",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                obscureText: true,
                                obscuringCharacter: '*',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () async {
                              var response = await signUp(
                                dbName: dbName,
                                license: licenseKey,
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
                                      content: SelectableText(
                                        "Kütüphane adı: $dbName\n"
                                        "Kütüphane şifresi: ${response["data"]?["dbPassword"] ?? "Bilinmiyor"}\n"
                                        "Admin kullanıcı adı: admin admin\n"
                                        "Admin şifresi: ${response["data"]?["adminPassword"] ?? "Bilinmiyor"}",
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
                              "Kütüphane Aç",
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
