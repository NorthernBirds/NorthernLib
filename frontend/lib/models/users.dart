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

class ChangeRoleWidget extends StatefulWidget {
  final VoidCallback onCancel;

  const ChangeRoleWidget({super.key, required this.onCancel});

  @override
  State<ChangeRoleWidget> createState() => _ChangeRoleWidgetState();
}

class _ChangeRoleWidgetState extends State<ChangeRoleWidget> {
  String userName = "";
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
              "Kullanıcı Rolü Değiştirme",
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
                var response = await changeRole(
                  userName: userName,
                  newRole: newRole,
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

class ListUsersWidget extends StatefulWidget {
  final VoidCallback onCancel;
  const ListUsersWidget({super.key, required this.onCancel});

  @override
  State<ListUsersWidget> createState() => _ListUsersWidgetState();
}

class _ListUsersWidgetState extends State<ListUsersWidget> {
  bool isWithFilter = false;
  String BfilterType = "id";
  String filterValue = "";
  String limit = "20";
  int currentPageNumber = 1;
  int itemsPerPage = 10;

  Map<String, String> filterTypeMap = {
    "Kullanıcı ID": "id",
    "Kullanıcı adı": "userName",
    "Rol": "role",
  };

  List<int> IDs = [];
  List<String> userNames = [];
  List<String> roles = [];

  Future<void> _fetchData() async {
    int parsedLimit = int.tryParse(limit) ?? 20;
    var response = await listUsers(
      isWithFilter: isWithFilter,
      filterType: BfilterType,
      filterValue: filterValue,
      limit: parsedLimit,
      pageNumber: currentPageNumber,
    );

    if (response?["success"] == false) {
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
    } else {
      var data = response?["data"];
      setState(() {
        IDs = List<int>.from(data?["ids"] ?? []);
        userNames = List<String>.from(data?["userNames"] ?? []);
        roles = List<String>.from(data?["roles"] ?? []);
        itemsPerPage = parsedLimit;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1200,
        height: 1200,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Kategori Listeleme",
                  style: TextStyle(
                    fontFamily: "Inter",
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SwitchListTile(
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
              DropdownButton<String>(
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 300.0,
                  child: TextField(
                    onChanged: (value) => filterValue = value,
                    decoration: InputDecoration(
                      hintText: "Filtre Değişkeni",
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
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 300.0,
                  child: TextField(
                    onChanged: (value) => limit = value,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Sayfaya Düşen Satır Sayısı",
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
                onPressed: () {
                  setState(() {
                    currentPageNumber = 1;
                  });
                  _fetchData();
                },
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  padding: const EdgeInsets.all(20.0),
                  backgroundColor: Colors.white,
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
                  side: const BorderSide(color: Colors.black),
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  "İptal",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              IDs.isEmpty
                  ? const Text("Gösterilecek veri yok. Önce listeleyin.")
                  : PaginatedDataTable(
                      header: const Text("Kullanıcı Listesi"),
                      rowsPerPage: itemsPerPage,
                      onPageChanged: (int firstRowIndex) {
                        int parsedLimit = int.tryParse(limit) ?? 20;
                        setState(() {
                          currentPageNumber =
                              (firstRowIndex / parsedLimit).floor() + 1;
                        });
                        _fetchData();
                      },
                      columns: const [
                        DataColumn(label: Text("ID")),
                        DataColumn(label: Text("Kullanıcı Adı")),
                        DataColumn(label: Text("Rolh")),
                      ],
                      source: UserDataSource(
                        ids: IDs,
                        userNames: userNames,
                        roles: roles,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDataSource extends DataTableSource {
  final List<int> ids;
  final List<String> userNames;
  final List<String> roles;

  UserDataSource({
    required this.ids,
    required this.userNames,
    required this.roles,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= ids.length) return null;
    return DataRow(
      cells: [
        DataCell(Text(ids[index].toString())),
        DataCell(Text(userNames[index])),
        DataCell(Text(roles[index])),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => ids.length;

  @override
  int get selectedRowCount => 0;
}
