import 'package:flutter/material.dart';
import 'package:frontend/api_requests.dart';

class adminDashboard extends StatefulWidget {
  const adminDashboard({super.key});

  @override
  State<adminDashboard> createState() => _adminDashboardState();
}

class _adminDashboardState extends State<adminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/image.png", width: 200.0, height: 200.0),
            Text(
              "Kitap İşlemleri",
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 16.0,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(0);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Text(
                "Kitap Ekle",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(1);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Text(
                "Kitap Sil",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(2);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Text(
                "Kitap Listele",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ),

            Text(
              "Kategori İşlemleri",
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 16.0,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(3);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Text(
                "Kategori Ekle",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(4);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Text(
                "Kategori Sil",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(5);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Text(
                "Kategori Listele",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ),

            Text(
              "Ödünç Alma İşlemleri",
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 16.0,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(6);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Text(
                "Ödünç Kitap Ver",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(7);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Text(
                "Kitap Geri Al",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(8);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Text(
                "Ödünç Kitapları Listele",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ),

            Text(
              "Kullanıcı İşlemleri",
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 16.0,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(9);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Text(
                "Kullanıcı Ekle",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(10);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Text(
                "Kullanıcı Sil",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(11);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Text(
                "Kullanıcı Listele",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ),

            Text(
              "Süreç İşlemleri",
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 16.0,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(12);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Text(
                "Süreç Sil",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(13);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Text(
                "Süreç Listele",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ),
            Text(
              "Sıfırlama İşlemleri",
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 16.0,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(14);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Text(
                "Sistemi Sıfırla",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
