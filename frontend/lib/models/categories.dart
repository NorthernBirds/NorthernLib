import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/api_requests.dart';
import 'package:frontend/config.dart';

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
  bool isWithFilter = false;
  String BfilterType = "id";
  String filterValue = "";
  String limit = "20";
  int currentPageNumber = 1;
  int itemsPerPage = 10;

  Map<String, String> filterTypeMap = {
    "Kategori ID": "id",
    "Kategori Adı": "categoryName",
    "Kim ekledi?": "whoAdded",
  };

  List<int> IDs = [];
  List<String> categoryNames = [];
  List<String> whoAddeds = [];

  Future<void> _fetchData() async {
    int parsedLimit = int.tryParse(limit) ?? 20;
    var response = await listCategories(
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
        categoryNames = List<String>.from(data?["names"] ?? []);
        whoAddeds = List<String>.from(data?["whoAddeds"] ?? []);
        itemsPerPage = IDs.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1200,
        height: 1200,
        color: color,
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
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                  setState(() {
                    currentPageNumber = 1;
                  });
                  _fetchData();
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
              const SizedBox(height: 20),
              IDs.isEmpty
                  ? const Text("Gösterilecek veri yok. Önce listeleyin.")
                  : PaginatedDataTable(
                      header: const Text("Kategori Listesi"),
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
                        DataColumn(label: Text("Kategori Adı")),
                        DataColumn(label: Text("Ekleyen")),
                      ],
                      source: CategoryDataSource(
                        ids: IDs,
                        names: categoryNames,
                        whoAddeds: whoAddeds,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryDataSource extends DataTableSource {
  final List<int> ids;
  final List<String> names;
  final List<String> whoAddeds;

  CategoryDataSource({
    required this.ids,
    required this.names,
    required this.whoAddeds,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= ids.length) return null;
    return DataRow(
      cells: [
        DataCell(Text(ids[index].toString())),
        DataCell(Text(names[index])),
        DataCell(Text(whoAddeds[index])),
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
