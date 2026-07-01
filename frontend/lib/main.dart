import 'package:flutter/material.dart';
import 'package:frontend/dashboards/signInDashboard.dart';
import 'package:frontend/dashboards/signUpDashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NorthernLib',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 44, 119, 81),
        ),
      ),
      home: const MyHomePage(title: 'NorthernLib'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(color: Color.fromARGB(255, 54, 1, 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginDashboard()),
                );
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Text(
                "SignIn",
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => signUpDash()),
                );
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Text(
                "SignUp",
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
