import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/api_requests.dart';
import 'package:frontend/config.dart';
import 'package:number_pagination/number_pagination.dart';

class AddCategoryWidget extends StatefulWidget {
  final VoidCallback onCancel;

  const AddCategoryWidget({super.key, required this.onCancel});

  @override
  State<AddCategoryWidget> createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
  String categoryName = "Roman";

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
              "Kategori Ekleme",
              style: TextStyle(
                fontSize: 36,
                fontFamily: "Inter",
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: categoryName,
              items: categoriesList.map<DropdownMenuItem<String>>((category) {
                return DropdownMenuItem<String>(
                  value: category.toString(),
                  child: Text(category.toString()),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  categoryName = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                var response = await addCategory(categoryName: categoryName);

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

class DeleteCategoryWidget extends StatefulWidget {
  final VoidCallback onCancel;

  const DeleteCategoryWidget({super.key, required this.onCancel});

  @override
  State<DeleteCategoryWidget> createState() => _DeleteCategoryWidgetState();
}

class _DeleteCategoryWidgetState extends State<DeleteCategoryWidget> {
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
              "Kategori Silme",
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
                    hintText: "Kategori ID",
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
                var response = await deleteCategory(id: parsedId);
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

class ListCategoriesWidget extends StatefulWidget {
  final VoidCallback onCancel;
  const ListCategoriesWidget({super.key, required this.onCancel});

  @override
  State<ListCategoriesWidget> createState() => _ListCategoriesWidgetState();
}

class _ListCategoriesWidgetState extends State<ListCategoriesWidget> {
  int currentPageNumber = 1;
  int totalPages = 1;
  int totalCategories = 0;
  String limit = "10";
  bool isWithFilter = false;
  String BfilterType = "id";
  String filterValue = "";

  bool isData = false;
  List<Category> categoryList = [];

  Map<String, String> filterTypeMap = {
    "Kategori ID": "id",
    "Kategori Adı": "categoryName",
    "Kim Ekledi?": "whoAdded",
  };
  Future<void> _fetchData({required bool isFirst}) async {
    var response = await listCategories(
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
        categoryList = Category.fromLists(
          categoryListFromBE: List<Map<String, dynamic>>.from(
            data["categories"] ?? [],
          ),
        );

        if (isFirst) {
          totalPages = data["pageCount"] ?? 1;
          totalCategories = data["totalCategories"] ?? 0;
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      "Kategori Listeleme",
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
            SizedBox(width: 100.0),
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
                                DataColumn(label: Text("Kategori ID")),
                                DataColumn(label: Text("Kategori Adı")),
                                DataColumn(label: Text("Ekleyen")),
                              ],
                              rows: List.generate(categoryList.length, (i) {
                                Category currentCategory = categoryList[i];
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(currentCategory.ID.toString()),
                                    ),
                                    DataCell(Text(currentCategory.name)),
                                    DataCell(Text(currentCategory.whoAdded)),
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
            SizedBox(width: 100.0),
          ],
        ),
      ),
    );
  }
}

class Category {
  final int ID;
  final String name;
  final String whoAdded;

  Category({required this.ID, required this.name, required this.whoAdded});

  static List<Category> fromLists({
    required List<Map<String, dynamic>> categoryListFromBE,
  }) {
    List<Category> categories = [];
    for (int i = 0; i < categoryListFromBE.length; i++) {
      Map<String, dynamic> currentDict = categoryListFromBE[i];
      categories.add(
        Category(
          ID: currentDict["ID"],
          name: currentDict["name"],
          whoAdded: currentDict["whoAdded"],
        ),
      );
    }
    return categories;
  }
}

class UpdateCategoryWidget extends StatefulWidget {
  final VoidCallback onCancel;

  const UpdateCategoryWidget({super.key, required this.onCancel});

  @override
  State<UpdateCategoryWidget> createState() => _UpdateCategoryWidgetState();
}

class _UpdateCategoryWidgetState extends State<UpdateCategoryWidget> {
  TextEditingController idController = TextEditingController();
  String categoryName = "Roman";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 500,
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
              "Kategori Güncelleme",
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
                        hintText: "Kategori ID",
                        hintStyle: const TextStyle(color: color2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    size: 30.0,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    var response = await listCategories(
                      isWithFilter: true,
                      filterType: "id",
                      filterValue: idController.text,
                      limit: 1,
                      pageNumber: 1,
                    );
                    setState(() {
                      if (response?["success"] == true &&
                          response?["data"]["categories"].isNotEmpty) {
                        Map<String, dynamic> currentCategory =
                            response?["data"]["categories"][0];
                        categoryName = currentCategory["name"] ?? "Roman";
                      } else {
                        categoryName = "Roman";
                      }
                    });
                  },
                ),
                const SizedBox(width: 100.0),
              ],
            ),
            DropdownButton<String>(
              value: categoryName,
              items: categoriesList.map<DropdownMenuItem<String>>((category) {
                return DropdownMenuItem<String>(
                  value: category.toString(),
                  child: Text(category.toString()),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  categoryName = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                var response = await updateCategory(
                  id: int.tryParse(idController.text) ?? 0,
                  categoryName: categoryName,
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
