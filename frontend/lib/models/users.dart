import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/api_requests.dart';
import 'package:frontend/config.dart';
import 'package:number_pagination/number_pagination.dart';

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
        height: 600,
        decoration: BoxDecoration(
          color: color,
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
                    hintStyle: const TextStyle(color: color2),
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
                    hintStyle: const TextStyle(color: color2),
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
                side: const BorderSide(color: Color(0xFF3A8772)),
                padding: const EdgeInsets.all(20.0),
                backgroundColor: color,
              ),
              child: const Text("Ekle", style: TextStyle(color: Colors.black)),
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
          color: color,
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
                    hintStyle: const TextStyle(color: color2),
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
                side: const BorderSide(color: Color(0xFF3A8772)),
                padding: const EdgeInsets.all(20.0),
                backgroundColor: color,
              ),
              child: const Text("Sil", style: TextStyle(color: Colors.black)),
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
}

class ChangeRoleWidget extends StatefulWidget {
  final VoidCallback onCancel;

  const ChangeRoleWidget({super.key, required this.onCancel});

  @override
  State<ChangeRoleWidget> createState() => _ChangeRoleWidgetState();
}

class _ChangeRoleWidgetState extends State<ChangeRoleWidget> {
  int id = 0;
  String newRole = "teacher";

  Map<String, String> roleMap = {
    "Öğretmen": "teacher",
    "Öğrenci": "student_staff",
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 600,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Kullanıcı Rolü Değiştirme",
              textAlign: TextAlign.center,
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
                  onChanged: (value) => id = int.tryParse(value) ?? 0,
                  decoration: InputDecoration(
                    hintText: "Kullanıcı ID",
                    hintStyle: const TextStyle(color: color2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ),
            DropdownButton<String>(
              value: newRole,
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
                  newRole = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                var response = await changeRole(id: id, newRole: newRole);

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
                "Güncelle",
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
}

class ListUsersWidget extends StatefulWidget {
  final VoidCallback onCancel;
  const ListUsersWidget({super.key, required this.onCancel});

  @override
  State<ListUsersWidget> createState() => _ListUsersWidgetState();
}

class _ListUsersWidgetState extends State<ListUsersWidget> {
  int currentPageNumber = 1;
  int totalPages = 1;
  int totalUsers = 0;
  String limit = "10";
  bool isWithFilter = false;
  String BfilterType = "id";
  String filterValue = "";

  bool isData = false;
  List<User> userList = [];

  Map<String, String> filterTypeMap = {
    "ID": "id",
    "Kullanıcı Adı": "userName",
    "Rol": "userRole",
    "Kim Ekledi?": "whoAdded",
  };
  Future<void> _fetchData({required bool isFirst}) async {
    var response = await listUsers(
      isWithFilter: isWithFilter,
      filterType: BfilterType,
      filterValue: filterValue,
      limit: int.tryParse(limit) ?? 10,
      pageNumber: currentPageNumber,
    );

    if (response?["success"] == true) {
      var data = response?["data"];
      setState(() {
        isData = true;
        userList = User.fromLists(
          userListFromBE: List<Map<String, dynamic>>.from(data["users"] ?? []),
        );

        if (isFirst) {
          totalPages = data["pageCount"] ?? 1;
          totalUsers = data["totalUsers"] ?? 0;
        }
      });
    } else {
      setState(() {
        isData = false;
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Hata"),
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(width: 100.0),
            Container(
              width: 400,
              height: 600,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: Colors.black, width: 2.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      "Kullanıcı Listeleme",
                      style: TextStyle(
                        fontFamily: "Inter",
                        color: Colors.black,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SwitchListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 45.0,
                    ),
                    title: const Text(
                      "Filtreli arama",
                      style: TextStyle(
                        fontFamily: "Inter",
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    value: isWithFilter,
                    activeThumbColor: Colors.teal,
                    activeTrackColor: Colors.tealAccent,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey.shade400,
                    onChanged: (bool value) {
                      setState(() {
                        isWithFilter = value;
                      });
                    },
                  ),
                  IgnorePointer(
                    ignoring: isWithFilter ? false : true,
                    child: DropdownButton<String>(
                      value: BfilterType,

                      items: filterTypeMap.entries
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
                          BfilterType = value!;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 300.0,
                      child: TextField(
                        onChanged: (value) => filterValue = value,
                        readOnly: isWithFilter ? false : true,
                        decoration: InputDecoration(
                          hintText: "Filtre Değişkeni",
                          hintStyle: const TextStyle(color: color2),
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
                        onChanged: (value) => limit = value,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Sayfaya Düşen Satır Sayısı",
                          hintStyle: const TextStyle(color: color2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _fetchData(isFirst: true);
                    },
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF3A8772)),
                      padding: const EdgeInsets.all(20.0),
                      backgroundColor: color,
                    ),
                    child: const Text(
                      "Listele",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
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
            const SizedBox(width: 100.0),
            Container(
              width: 900,
              height: 700,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: Colors.black, width: 2.0),
              ),
              child: isData
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text("Kullanıcı ID")),
                                DataColumn(label: Text("Kullanıcı Adı")),
                                DataColumn(label: Text("Rol")),
                                DataColumn(label: Text("Ekleyen")),
                              ],
                              rows: List.generate(userList.length, (i) {
                                User currentBook = userList[i];
                                return DataRow(
                                  cells: [
                                    DataCell(Text(currentBook.ID.toString())),
                                    DataCell(Text(currentBook.userName)),
                                    DataCell(Text(currentBook.role)),
                                    DataCell(Text(currentBook.whoAdded)),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                        NumberPagination(
                          totalPages: totalPages,
                          onPageChanged: (int index) {
                            setState(() {
                              currentPageNumber = index;
                            });
                            _fetchData(isFirst: false);
                          },
                          currentPage: currentPageNumber,
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        "Gösterilecek veri yok.\nÖnce listeleyin.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          fontFamily: "Inter",
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
            const SizedBox(width: 100.0),
          ],
        ),
      ),
    );
  }
}

class User {
  final int ID;
  final String userName;
  final String role;
  final String whoAdded;

  User({
    required this.ID,
    required this.userName,
    required this.role,
    required this.whoAdded,
  });

  static List<User> fromLists({
    required List<Map<String, dynamic>> userListFromBE,
  }) {
    List<User> users = [];
    for (int i = 0; i < userListFromBE.length; i++) {
      Map<String, dynamic> currentDict = userListFromBE[i];
      users.add(
        User(
          ID: currentDict["ID"],
          userName: currentDict["userName"],
          role: currentDict["role"],
          whoAdded: currentDict["whoAdded"],
        ),
      );
    }
    return users;
  }
}

class UpdateUserWidget extends StatefulWidget {
  final VoidCallback onCancel;

  const UpdateUserWidget({super.key, required this.onCancel});

  @override
  State<UpdateUserWidget> createState() => _UpdateUserWidgetState();
}

class _UpdateUserWidgetState extends State<UpdateUserWidget> {
  TextEditingController idController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  String role = "teacher";

  Map<String, String> roleMap = {
    "Öğretmen": "teacher",
    "Öğrenci": "student_staff",
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 600,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Kullanıcı Güncelleme",
              style: TextStyle(
                fontSize: 36,
                fontFamily: "Inter",
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 100.0),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 100.0,
                    child: TextField(
                      controller: idController,
                      decoration: InputDecoration(
                        hintText: "Kullanıcı ID",
                        hintStyle: const TextStyle(color: color2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    size: 30.0,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    var response = await listUsers(
                      isWithFilter: true,
                      filterType: "id",
                      filterValue: idController.text,
                      limit: 1,
                      pageNumber: 1,
                    );
                    setState(() {
                      if (response?["success"] == true &&
                          response?["data"]["ids"].isNotEmpty) {
                        Map<String, dynamic> currentUser =
                            response?["data"]["users"][0];
                        userNameController.text = currentUser["userName"];
                        role = currentUser["role"];
                      } else {
                        userNameController.clear();
                        role = "teacher";
                      }
                    });
                  },
                ),
                const SizedBox(width: 100.0),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 300.0,
                child: TextField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    hintText: "Kullanıcı Adı",
                    hintStyle: const TextStyle(color: color2),
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
            ElevatedButton(
              onPressed: () async {
                var response = await updateUser(
                  id: int.tryParse(idController.text) ?? 0,
                  userName: userNameController.text,
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
                side: const BorderSide(color: Color(0xFF3A8772)),
                padding: const EdgeInsets.all(20.0),
                backgroundColor: color,
              ),
              child: const Text(
                "Güncelle",
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
}
