import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/api_requests.dart';

class AddUserWidget extends StatefulWidget {
  final VoidCallback onCancel;

  const AddUserWidget({super.key, required this.onCancel});

  @override
  State<AddUserWidget> createState() => _AddUserWidgetState();
}

class _AddUserWidgetState extends State<AddUserWidget> {
  String userName = "";
  String role = "teacher";
  String password = "";

  Map<String, String> roleMap = {
    "Öğretmen": "teacher",
    "Öğrenci": "student_staff",
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 700,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Kullanıcı Ekleme",
              style: TextStyle(
                fontSize: 36,
                fontFamily: "Inter",
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 300.0,
                child: TextField(
                  onChanged: (value) => userName = value,
                  decoration: InputDecoration(
                    hintText: "Kullanıcı Adı",
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
            DropdownButton<String>(
              value: role,
              items: roleMap.entries
                  .map(
                    (e) => DropdownMenuItem(
                      value: e.value,
                      child: Text(
                        e.key,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (String? value) {
                setState(() {
                  role = value!;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 300.0,
                child: TextField(
                  onChanged: (value) => password = value,
                  decoration: InputDecoration(
                    hintText: "Şifre",
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
                var response = await addUser(
                  userName: userName,
                  password: password,
                  role: role,
                );

                String alertTitle = (response?["success"] == true)
                    ? "Kayıt Başarılı"
                    : "Hata";

                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(alertTitle),
                        content: Text(
                          response?["message"] ?? "Bilinmeyen bir hata oluştu.",
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Tamam"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                padding: const EdgeInsets.all(20.0),
                backgroundColor: Colors.white,
              ),
              child: const Text("Ekle", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: widget.onCancel,
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                backgroundColor: Colors.white,
              ),
              child: const Text(
                "İptal",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteUserWidget extends StatefulWidget {
  final VoidCallback onCancel;

  const DeleteUserWidget({super.key, required this.onCancel});

  @override
  State<DeleteUserWidget> createState() => _DeleteUserWidgetState();
}

class _DeleteUserWidgetState extends State<DeleteUserWidget> {
  String idInput = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Kullanıcı Silme",
              style: TextStyle(
                fontSize: 36,
                fontFamily: "Inter",
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 300.0,
                child: TextField(
                  onChanged: (value) => idInput = value,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Kullanıcı ID",
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
                int parsedId = int.tryParse(idInput) ?? 0;
                var response = await deleteUser(id: parsedId);
                String alertTitle = (response?["success"] == true)
                    ? "Kayıt Başarılı"
                    : "Hata";

                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(alertTitle),
                        content: Text(
                          response?["message"] ?? "Bilinmeyen bir hata oluştu.",
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Tamam"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                padding: const EdgeInsets.all(20.0),
                backgroundColor: Colors.white,
              ),
              child: const Text("Sil", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: widget.onCancel,
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                backgroundColor: Colors.white,
              ),
              child: const Text(
                "İptal",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
