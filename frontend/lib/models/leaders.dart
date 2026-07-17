import 'package:flutter/material.dart';
import 'package:frontend/api_requests.dart';
import 'package:flutter/services.dart';

class ListLeadersWidget extends StatefulWidget {
  final VoidCallback onCancel;
  const ListLeadersWidget({super.key, required this.onCancel});

  @override
  State<ListLeadersWidget> createState() => _ListLeadersWidgetState();
}

class _ListLeadersWidgetState extends State<ListLeadersWidget> {
  int currentPageNumber = 1;
  int itemsPerPage = 10;
  String limit = "20";

  List<int> studentIDs = [];
  List<String> readBooks = [];

  Future<void> _fetchData() async {
    int parsedLimit = int.tryParse(limit) ?? 10;
    var response = await listLeaders(
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
        studentIDs = List<int>.from(data?["studentIDs"] ?? []);
        readBooks = List<String>.from(data?["readBook"] ?? []);
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
                  "Liderleri Listele",
                  style: TextStyle(
                    fontFamily: "Inter",
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
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
              studentIDs.isEmpty
                  ? const Text("Gösterilecek veri yok. Önce listeleyin.")
                  : PaginatedDataTable(
                      header: const Text("Liderler Listesi"),
                      rowsPerPage: itemsPerPage,
                      onPageChanged: (int firstRowIndex) {
                        int parsedLimit = int.tryParse(limit) ?? 10;
                        setState(() {
                          currentPageNumber =
                              (firstRowIndex / parsedLimit).floor() + 1;
                        });
                        _fetchData();
                      },
                      columns: const [
                        DataColumn(label: Text("Sıralama")),
                        DataColumn(label: Text("Öğrenci No")),
                        DataColumn(label: Text("Okuduğu Kitap Sayısı")),
                      ],
                      source: LeaderDataSource(
                        studentIDs: studentIDs,
                        readBooks: readBooks,
                        currentPage: currentPageNumber,
                        itemsPerPage: itemsPerPage,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeaderDataSource extends DataTableSource {
  final List<int> studentIDs;
  final List<String> readBooks;
  final int currentPage;
  final int itemsPerPage;

  LeaderDataSource({
    required this.studentIDs,
    required this.readBooks,
    required this.currentPage,
    required this.itemsPerPage,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= studentIDs.length) return null;
    int rank = ((currentPage - 1) * itemsPerPage) + index + 1;
    return DataRow(
      cells: [
        DataCell(Text(rank.toString())),
        DataCell(Text(studentIDs[index].toString())),
        DataCell(Text(readBooks[index])),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => studentIDs.length;

  @override
  int get selectedRowCount => 0;
}
