import 'package:flutter/material.dart';
import 'package:frontend/api_requests.dart';
import 'package:frontend/main.dart';

class signUpDash extends StatefulWidget {
  const signUpDash({super.key});

  @override
  State<signUpDash> createState() => _signUpStateDash();
}

class _signUpStateDash extends State<signUpDash> {
  String dbName = "";
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
                  ElevatedButton(
                    onPressed: () async {
                      var response = await signUp(dbName: dbName);
                      print(response!["message"]);
                    },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    child: const Text(
                      "Kayıt Ol",
                      style: TextStyle(fontSize: 14),
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
