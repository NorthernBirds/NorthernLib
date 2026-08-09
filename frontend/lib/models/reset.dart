import 'package:flutter/material.dart';
import 'package:frontend/api_requests.dart';
import 'package:frontend/config.dart';

class ResetWidget extends StatefulWidget {
  final VoidCallback onCancel;
  const ResetWidget({super.key, required this.onCancel});

  @override
  State<ResetWidget> createState() => _ResetWidgetState();
}

class _ResetWidgetState extends State<ResetWidget> {
  bool books = false;
  bool categories = false;
  bool loans = false;
  bool users = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 600,
        width: 400,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Sıfırlama",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 36.0,
                color: Colors.black,
              ),
            ),
            _buildSwitchTile(
              title: "Kitap kayıtları",
              value: books,
              onChanged: (bool value) {
                setState(() {
                  books = value;
                });
              },
            ),
            _buildSwitchTile(
              title: "Kategori kayıtları",
              value: categories,
              onChanged: (bool value) {
                setState(() {
                  categories = value;
                });
              },
            ),
            _buildSwitchTile(
              title: "Ödünç alma kayıtları",
              value: loans,
              onChanged: (bool value) {
                setState(() {
                  loans = value;
                });
              },
            ),
            _buildSwitchTile(
              title: "Kullanıcı kayıtları",
              value: users,
              onChanged: (bool value) {
                setState(() {
                  users = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                var response = await reset(
                  books: books,
                  categories: categories,
                  loans: loans,
                  users: users,
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
                side: const BorderSide(color: Color(0xFF3A8772)),
                padding: const EdgeInsets.all(20.0),
                backgroundColor: color,
              ),
              child: const Text(
                "Sıfırla",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: widget.onCancel,
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
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 45.0),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: "Inter",
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
      value: value,
      activeThumbColor: Colors.teal,
      activeTrackColor: Colors.tealAccent,
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.grey.shade400,
      onChanged: onChanged,
    );
  }
}
