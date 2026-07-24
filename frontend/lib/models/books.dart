import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/api_requests.dart';
import 'package:frontend/config.dart';

class AddBookWidget extends StatefulWidget {
  final VoidCallback onCancel;

  const AddBookWidget({super.key, required this.onCancel});

  @override
  State<AddBookWidget> createState() => _AddBookWidgetState();
}

class _AddBookWidgetState extends State<AddBookWidget> {
  String bookName = "";
  String writer = "";
  String publisher = "";
  String category = "";
  String pageCount = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 700,
        decoration: BoxDecoration(
          color: const Color(0xFF3A8772),
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Kitap Ekleme",
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
                  onChanged: (value) => bookName = value,
                  decoration: InputDecoration(
                    hintText: "Kitap Adı",
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
                  onChanged: (value) => writer = value,
                  decoration: InputDecoration(
                    hintText: "Yazar Adı",
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
                  onChanged: (value) => publisher = value,
                  decoration: InputDecoration(
                    hintText: "Yayımcı Adı",
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
              value: category,
              items: categoriesList.map<DropdownMenuItem<String>>((category) {
                return DropdownMenuItem<String>(
                  value: category.toString(),
                  child: Text(category.toString()),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  category = value!;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 300.0,
                child: TextField(
                  onChanged: (value) => pageCount = value,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Sayfa Sayısı",
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
                int parsedPages = int.tryParse(pageCount) ?? 0;

                var response = await addBook(
                  bookName: bookName,
                  writer: writer,
                  category: category,
                  publisher: publisher,
                  pageCount: parsedPages,
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
                backgroundColor: const Color(0xFF3A8772),
              ),
              child: const Text("Ekle", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: widget.onCancel,
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF3A8772)),
                backgroundColor: const Color(0xFF3A8772),
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

class DeleteBookWidget extends StatefulWidget {
  final VoidCallback onCancel;

  const DeleteBookWidget({super.key, required this.onCancel});

  @override
  State<DeleteBookWidget> createState() => _DeleteBookWidgetState();
}

class _DeleteBookWidgetState extends State<DeleteBookWidget> {
  String idInput = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          color: const Color(0xFF3A8772),
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Kitap Silme",
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
                    hintText: "Kitap ID",
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
                var response = await deleteBook(id: parsedId);
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
                backgroundColor: const Color(0xFF3A8772),
              ),
              child: const Text("Sil", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: widget.onCancel,
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF3A8772)),
                backgroundColor: const Color(0xFF3A8772),
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

class ListBooksWidget extends StatefulWidget {
  final VoidCallback onCancel;
  const ListBooksWidget({super.key, required this.onCancel});

  @override
  State<ListBooksWidget> createState() => _ListBooksWidgetState();
}

class _ListBooksWidgetState extends State<ListBooksWidget> {
  bool isWithFilter = false;
  String BfilterType = "id";
  String filterValue = "";
  String limit = "20";
  int currentPageNumber = 1;
  int itemsPerPage = 10;

  Map<String, String> filterTypeMap = {
    "Kitap ID": "id",
    "Kitap Adı": "bookName",
    "Yazar Adı": "writer",
    "Yayımcı Adı": "publisher",
    "Kategori Adı": "category",
    "Sayfa Sayısı": "pageCount",
    "Alındı mı?": "isTaken",
    "Kim ekledi?": "whoAdded",
  };

  List<int> IDs = [];
  List<String> bookNames = [];
  List<String> writers = [];
  List<String> publishers = [];
  List<String> categories = [];
  List<int> pageCounts = [];
  List<String> isTakens = [];
  List<String> whoAddeds = [];

  Future<void> _fetchData() async {
    int parsedLimit = int.tryParse(limit) ?? 20;
    var response = await listBooks(
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
        bookNames = List<String>.from(data?["names"] ?? []);
        writers = List<String>.from(data?["writers"] ?? []);
        publishers = List<String>.from(data?["publishers"] ?? []);
        categories = List<String>.from(data?["categories"] ?? []);
        pageCounts = List<int>.from(data?["pageCounts"] ?? []);
        isTakens = List<String>.from(data?["isTakens"] ?? []);
        whoAddeds = List<String>.from(data?["whoAddeds"] ?? []);
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
        color: const Color(0xFF3A8772),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Kitap Listeleme",
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
                  side: const BorderSide(color: Color(0xFF3A8772)),
                  padding: const EdgeInsets.all(20.0),
                  backgroundColor: const Color(0xFF3A8772),
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
                  backgroundColor: const Color(0xFF3A8772),
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
                      header: const Text("Kitap Listesi"),
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
                        DataColumn(label: Text("Kitap Adı")),
                        DataColumn(label: Text("Yazar")),
                        DataColumn(label: Text("Yayımcı")),
                        DataColumn(label: Text("Kategori")),
                        DataColumn(label: Text("Sayfa")),
                        DataColumn(label: Text("Durum")),
                        DataColumn(label: Text("Ekleyen")),
                      ],
                      source: BookDataSource(
                        ids: IDs,
                        names: bookNames,
                        writers: writers,
                        publishers: publishers,
                        categories: categories,
                        pageCounts: pageCounts,
                        isTakens: isTakens,
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

class BookDataSource extends DataTableSource {
  final List<int> ids;
  final List<String> names;
  final List<String> writers;
  final List<String> publishers;
  final List<String> categories;
  final List<int> pageCounts;
  final List<String> isTakens;
  final List<String> whoAddeds;

  BookDataSource({
    required this.ids,
    required this.names,
    required this.writers,
    required this.publishers,
    required this.categories,
    required this.pageCounts,
    required this.isTakens,
    required this.whoAddeds,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= ids.length) return null;
    return DataRow(
      cells: [
        DataCell(Text(ids[index].toString())),
        DataCell(Text(names[index])),
        DataCell(Text(writers[index])),
        DataCell(Text(publishers[index])),
        DataCell(Text(categories[index])),
        DataCell(Text(pageCounts[index].toString())),
        DataCell(Text(isTakens[index])),
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
