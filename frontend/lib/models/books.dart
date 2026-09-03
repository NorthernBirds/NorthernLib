import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/api_requests.dart';
import 'package:frontend/config.dart';
import 'package:number_pagination/number_pagination.dart';

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
  String category = "Roman";
  String pageCount = "";

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
                  onChanged: (value) => writer = value,
                  decoration: InputDecoration(
                    hintText: "Yazar Adı",
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
                  onChanged: (value) => publisher = value,
                  decoration: InputDecoration(
                    hintText: "Yayınevi Adı",
                    hintStyle: const TextStyle(color: color2),
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
          color: color,
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

class ListBooksWidget extends StatefulWidget {
  final VoidCallback onCancel;
  const ListBooksWidget({super.key, required this.onCancel});

  @override
  State<ListBooksWidget> createState() => _ListBooksWidgetState();
}

class _ListBooksWidgetState extends State<ListBooksWidget> {
  int currentPageNumber = 1;
  int totalPages = 1;
  int totalBooks = 0;
  String limit = "10";
  bool isWithFilter = false;
  String BfilterType = "id";
  String filterValue = "";

  bool isData = false;
  List<Book> bookList = [];

  Map<String, String> filterTypeMap = {
    "Kitap ID": "id",
    "Kitap Adı": "bookName",
    "Yazar Adı": "writer",
    "Yayınevi Adı": "publisher",
    "Kategori Adı": "category",
    "Sayfa Sayısı": "pageCount",
    "Alındı mı?": "isTaken",
    "Kim ekledi?": "whoAdded",
  };
  Future<void> _fetchData({required bool isFirst}) async {
    var response = await listBooks(
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
        bookList = Book.fromLists(
          bookListFromBE: List<Map<String, dynamic>>.from(data["books"] ?? []),
        );

        if (isFirst) {
          totalPages = data["pageCount"] ?? 1;
          totalBooks = data["totalBooks"] ?? 0;
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
        child: SingleChildScrollView(
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
                        "Kitap Listeleme",
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
                  border: Border.all(
                    color: const Color.fromARGB(255, 218, 173, 173),
                    width: 2.0,
                  ),
                ),
                child: isData
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text("Kitap ID")),
                                DataColumn(label: Text("Kitap Adı")),
                                DataColumn(label: Text("Yazar")),
                                DataColumn(label: Text("Yayınevi")),
                                DataColumn(label: Text("Kategori")),
                                DataColumn(label: Text("Sayfa Sayısı")),
                                DataColumn(label: Text("Durum")),
                                DataColumn(label: Text("Ekleyen")),
                              ],
                              rows: List.generate(bookList.length, (i) {
                                Book currentBook = bookList[i];
                                return DataRow(
                                  cells: [
                                    DataCell(Text(currentBook.ID.toString())),
                                    DataCell(Text(currentBook.name)),
                                    DataCell(Text(currentBook.writer)),
                                    DataCell(Text(currentBook.publisher)),
                                    DataCell(Text(currentBook.category)),
                                    DataCell(
                                      Text(currentBook.pageCount.toString()),
                                    ),
                                    DataCell(Text(currentBook.isTaken)),
                                    DataCell(Text(currentBook.whoAdded)),
                                  ],
                                );
                              }),
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
      ),
    );
  }
}

class Book {
  final int ID;
  final String name;
  final String writer;
  final String publisher;
  final String category;
  final int pageCount;
  final String isTaken;
  final String whoAdded;

  Book({
    required this.ID,
    required this.name,
    required this.writer,
    required this.publisher,
    required this.category,
    required this.pageCount,
    required this.isTaken,
    required this.whoAdded,
  });

  static List<Book> fromLists({
    required List<Map<String, dynamic>> bookListFromBE,
  }) {
    List<Book> books = [];
    for (int i = 0; i < bookListFromBE.length; i++) {
      Map<String, dynamic> currentDict = bookListFromBE[i];
      books.add(
        Book(
          ID: currentDict["ID"],
          name: currentDict["name"],
          writer: currentDict["writer"],
          publisher: currentDict["publisher"],
          category: currentDict["category"],
          pageCount: currentDict["pageCount"],
          isTaken: currentDict["isTaken"],
          whoAdded: currentDict["whoAdded"],
        ),
      );
    }
    return books;
  }
}

class UpdateBookWidget extends StatefulWidget {
  final VoidCallback onCancel;

  const UpdateBookWidget({super.key, required this.onCancel});

  @override
  State<UpdateBookWidget> createState() => _UpdateBookWidgetState();
}

class _UpdateBookWidgetState extends State<UpdateBookWidget> {
  TextEditingController idController = TextEditingController();
  TextEditingController bookNameController = TextEditingController();
  TextEditingController writerController = TextEditingController();
  TextEditingController publisherController = TextEditingController();
  String category = "Roman";
  TextEditingController pageCountController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    bookNameController.dispose();
    writerController.dispose();
    publisherController.dispose();
    pageCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 700,
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
              "Kitap Güncelleme",
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
                        hintText: "Kitap ID",
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
                    var response = await listBooks(
                      isWithFilter: true,
                      filterType: "id",
                      filterValue: idController.text,
                      limit: 1,
                      pageNumber: 1,
                    );
                    setState(() {
                      if (response?["success"] == true &&
                          response?["data"]["books"].isNotEmpty) {
                        Map<String, dynamic> currentBook =
                            response?["data"]["books"][0];
                        bookNameController.text = currentBook["name"] ?? "";
                        writerController.text = currentBook["writer"] ?? "";
                        publisherController.text =
                            currentBook["publisher"] ?? "";
                        category = currentBook["category"] ?? "Roman";
                        pageCountController.text = currentBook["pageCount"]
                            .toString();
                      } else {
                        bookNameController.clear();
                        writerController.clear();
                        publisherController.clear();
                        category = "Roman";
                        pageCountController.clear();
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
                  controller: bookNameController,
                  decoration: InputDecoration(
                    hintText: "Kitap Adı",
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
                  controller: writerController,
                  decoration: InputDecoration(
                    hintText: "Yazar Adı",
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
                  controller: publisherController,
                  decoration: InputDecoration(
                    hintText: "Yayınevi Adı",
                    hintStyle: const TextStyle(color: color2),
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
                  controller: pageCountController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Sayfa Sayısı",
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
                var response = await updateBook(
                  id: int.tryParse(idController.text) ?? 0,
                  bookName: bookNameController.text,
                  writer: writerController.text,
                  category: category,
                  publisher: publisherController.text,
                  pageCount: int.tryParse(pageCountController.text) ?? 0,
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
