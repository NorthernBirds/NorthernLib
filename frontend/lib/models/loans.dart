import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/api_requests.dart';

class BorrowBookWidget extends StatefulWidget {
  final VoidCallback onCancel;

  const BorrowBookWidget({super.key, required this.onCancel});

  @override
  State<BorrowBookWidget> createState() => _BorrowBookWidgetState();
}

class _BorrowBookWidgetState extends State<BorrowBookWidget> {
  String studentID = "";
  String bookID = "";
  final TextEditingController _returnDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 500,
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
              "Kitap Ödünç Alma",
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
                  onChanged: (value) => studentID = value,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Öğrenci No",
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
                  onChanged: (value) => bookID = value,
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
            TextFormField(
              controller: _returnDateController,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: "Kitap Teslim Tarihi: GG/AA/YYYY",
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                final DateTime today = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                );

                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: today,
                  firstDate: today,
                  lastDate: DateTime(today.year + 4, 6, 10),
                );

                if (pickedDate != null) {
                  String day = pickedDate.day.toString().padLeft(2, '0');
                  String month = pickedDate.month.toString().padLeft(2, '0');
                  String year = pickedDate.year.toString();

                  setState(() {
                    _returnDateController.text = "$day/$month/$year";
                  });
                } else {
                  setState(() {
                    _returnDateController.text = "";
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: () async {
                int parsedStdID = int.tryParse(studentID) ?? 0;
                int parsedBkID = int.tryParse(bookID) ?? 0;

                var response = await borrowBook(
                  studentID: parsedStdID,
                  bookID: parsedBkID,
                  returnDate: _returnDateController.text,
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

class ReturnBookWidget extends StatefulWidget {
  final VoidCallback onCancel;

  const ReturnBookWidget({super.key, required this.onCancel});

  @override
  State<ReturnBookWidget> createState() => _ReturnBookWidgetState();
}

class _ReturnBookWidgetState extends State<ReturnBookWidget> {
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
              "Kitap Geri Alma",
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
                var response = await returnBook(bookID: parsedId);
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
              child: const Text(
                "Geri Al",
                style: TextStyle(color: Colors.black),
              ),
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

class ListLoansWidget extends StatefulWidget {
  final VoidCallback onCancel;
  const ListLoansWidget({super.key, required this.onCancel});

  @override
  State<ListLoansWidget> createState() => _ListLoansWidgetState();
}

class _ListLoansWidgetState extends State<ListLoansWidget> {
  bool isWithFilter = false;
  String BfilterType = "id";
  String filterValue = "";
  String limit = "20";
  int currentPageNumber = 1;
  int itemsPerPage = 10;

  Map<String, String> filterTypeMap = {
    "ID": "id",
    "Öğrenci No": "studentID",
    "Kitap ID": "bookID",
    "Ödünç Alma Tarihi": "borrowDate",
    "Planlanan Geri Getirme Tarihi": "returnDate",
    "Gerçek Geri Getirme Tarihi": "returnedAt",
    "Durum": "loanStatus",
    "Kim ekledi?": "whoAdded",
  };

  List<int> IDs = [];
  List<int> studentIDs = [];
  List<String> bookNames = [];
  List<String> borrowDates = [];
  List<String> returnDates = [];
  List<String> returnedAts = [];
  List<String> loanStatuses = [];
  List<String> whoAddeds = [];

  Future<void> _fetchData() async {
    int parsedLimit = int.tryParse(limit) ?? 20;
    var response = await listLoans(
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
        studentIDs = List<int>.from(data?["studentIDs"] ?? []);
        bookNames = List<String>.from(data?["bookNames"] ?? []);
        borrowDates = List<String>.from(data?["borrowDates"] ?? []);
        returnDates = List<String>.from(data?["returnDates"] ?? []);
        returnedAts = List<String>.from(data?["pageCounts"] ?? []);
        loanStatuses = List<String>.from(data?["loanStatuses"] ?? []);
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
                        DataColumn(label: Text("Öğrenci No")),
                        DataColumn(label: Text("Kitap Adı")),
                        DataColumn(label: Text("Ödünç Alma Tarihi")),
                        DataColumn(
                          label: Text("Planlanan Geri Getirme Tarihi"),
                        ),
                        DataColumn(label: Text("Gerçek Geri Getirilme Tarihi")),
                        DataColumn(label: Text("Durum")),
                        DataColumn(label: Text("Ekleyen")),
                      ],
                      source: LoanDataSource(
                        ids: IDs,
                        bookNames: bookNames,
                        studentIDs: studentIDs,
                        borrowDates: borrowDates,
                        returnDates: returnDates,
                        returnedAts: returnedAts,
                        loanStatuses: loanStatuses,
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

class LoanDataSource extends DataTableSource {
  final List<int> ids;
  final List<String> bookNames;
  final List<int> studentIDs;
  final List<String> borrowDates;
  final List<String> returnDates;
  final List<String> returnedAts;
  final List<String> loanStatuses;
  final List<String> whoAddeds;

  LoanDataSource({
    required this.ids,
    required this.bookNames,
    required this.studentIDs,
    required this.borrowDates,
    required this.returnDates,
    required this.returnedAts,
    required this.loanStatuses,
    required this.whoAddeds,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= ids.length) return null;
    return DataRow(
      cells: [
        DataCell(Text(ids[index].toString())),
        DataCell(Text(studentIDs[index].toString())),
        DataCell(Text(bookNames[index])),
        DataCell(Text(borrowDates[index])),
        DataCell(Text(returnDates[index])),
        DataCell(Text(returnedAts[index])),
        DataCell(Text(loanStatuses[index])),
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
