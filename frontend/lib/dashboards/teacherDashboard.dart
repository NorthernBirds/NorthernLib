import 'package:flutter/material.dart';
import 'package:frontend/api_requests.dart';
import 'package:frontend/dashboards/signInDashboard.dart';
import 'package:frontend/models/books.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  final ButtonStyle _menuButtonStyle = ElevatedButton.styleFrom(
    side: const BorderSide(color: Colors.black),
    padding: const EdgeInsets.all(20.0),
    backgroundColor: const Color.fromARGB(255, 77, 44, 44),
  );

  final TextStyle _labelTextStyle = const TextStyle(
    fontFamily: "Inter",
    fontWeight: FontWeight.normal,
    fontSize: 14.0,
    color: Colors.black,
  );

  bool isAddBookWidgetVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Container(
            width: 300.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Colors.black, width: 2)),
              color: const Color.fromARGB(255, 77, 44, 44),
            ),
            child: SingleChildScrollView(
              primary: true,
              child: Container(
                color: const Color.fromARGB(255, 77, 44, 44),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/image.png",
                      width: 200.0,
                      height: 200.0,
                    ),
                    const SizedBox(height: 24.0),

                    const Text(
                      "Kitap İşlemleri",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isAddBookWidgetVisible = true;
                        });
                      },
                      style: _menuButtonStyle,
                      child: Text("Kitap Ekle", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () => print(1),
                      style: _menuButtonStyle,
                      child: Text("Kitap Sil", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () => print(2),
                      style: _menuButtonStyle,
                      child: Text("Kitap Listele", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 24.0),

                    const Text(
                      "Kategori İşlemleri",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    ElevatedButton(
                      onPressed: () => print(3),
                      style: _menuButtonStyle,
                      child: Text("Kategori Ekle", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () => print(4),
                      style: _menuButtonStyle,
                      child: Text("Kategori Sil", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () => print(5),
                      style: _menuButtonStyle,
                      child: Text("Kategori Listele", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 24.0),

                    const Text(
                      "Ödünç Alma İşlemleri",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    ElevatedButton(
                      onPressed: () => print(6),
                      style: _menuButtonStyle,
                      child: Text("Ödünç Kitap Ver", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () => print(7),
                      style: _menuButtonStyle,
                      child: Text("Kitap Geri Al", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () => print(8),
                      style: _menuButtonStyle,
                      child: Text(
                        "Ödünç Kitapları Listele",
                        style: _labelTextStyle,
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    const Text(
                      "Çıkış İşlemleri",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    ElevatedButton(
                      onPressed: () async {
                        await signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginDashboard(),
                          ),
                        );
                      },
                      style: _menuButtonStyle,
                      child: Text("Çıkış Yap", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 12.0),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/libImage.png"),
                  fit: BoxFit.cover,
                ),
              ),

              child: isAddBookWidgetVisible
                  ? AddBookWidget(
                      onCancel: () {
                        setState(() {
                          isAddBookWidgetVisible = false;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
