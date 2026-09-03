import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/api_requests.dart';
import 'package:frontend/config.dart';
import 'package:number_pagination/number_pagination.dart';

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
          color: color,
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
                  onChanged: (value) => bookID = value,
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 300.0,
                child: TextFormField(
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
                      String month = pickedDate.month.toString().padLeft(
                        2,
                        '0',
                      );
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
              ),
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
          color: color,
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
                backgroundColor: color,
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

class ListLoansWidget extends StatefulWidget {
  final VoidCallback onCancel;
  const ListLoansWidget({super.key, required this.onCancel});

  @override
  State<ListLoansWidget> createState() => _ListLoansWidgetState();
}

class _ListLoansWidgetState extends State<ListLoansWidget> {
  int currentPageNumber = 1;
  int totalPages = 1;
  int totalLoans = 0;
  String limit = "10";
  bool isWithFilter = false;
  String BfilterType = "id";
  String filterValue = "";

  bool isData = false;
  List<Loan> loanList = [];

  Map<String, String> filterTypeMap = {
    "Ödünç Alım ID": "id",
    "Öğrenci ID": "studentID",
    "Kitap ID": "bookID",
    "Ödünç Alım Tarihi": "borrowDate",
    "Geri Getirme Tarihi": "returnDate",
    "Geri Getirilen Tarih": "returnAt",
    "Durum": "isTaken",
    "Kim ekledi?": "whoAdded",
  };
  Future<void> _fetchData({required bool isFirst}) async {
    var response = await listLoans(
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
        loanList = Loan.fromLists(
          loanListFromBE: List<Map<String, dynamic>>.from(data["loans"] ?? []),
        );

        if (isFirst) {
          totalPages = data["pageCount"] ?? 1;
          totalLoans = data["totalLoans"] ?? 0;
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
            const SizedBox(width: 100.0),
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
                      "Ödünç Alım Listeleme",
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
                                DataColumn(label: Text("ID")),
                                DataColumn(label: Text("Öğrenci ID")),
                                DataColumn(label: Text("Kitap ID")),
                                DataColumn(label: Text("Ödünç Alım Tarihi")),
                                DataColumn(
                                  label: Text("Planlanan Geri Getirme Tarihi"),
                                ),
                                DataColumn(label: Text("Geri Getirilen Tarih")),
                                DataColumn(label: Text("Durum")),
                                DataColumn(label: Text("Ekleyen")),
                              ],
                              rows: List.generate(loanList.length, (i) {
                                Loan currentBook = loanList[i];
                                return DataRow(
                                  cells: [
                                    DataCell(Text(currentBook.ID.toString())),
                                    DataCell(
                                      Text(currentBook.studentID.toString()),
                                    ),
                                    DataCell(
                                      Text(currentBook.bookID.toString()),
                                    ),
                                    DataCell(Text(currentBook.borrowDate)),
                                    DataCell(Text(currentBook.returnDate)),
                                    DataCell(Text(currentBook.returnedAt)),
                                    DataCell(Text(currentBook.status)),
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
            SizedBox(width: 100.0),
          ],
        ),
      ),
    );
  }
}

class Loan {
  final int ID;
  final int studentID;
  final int bookID;
  final String borrowDate;
  final String returnDate;
  final String returnedAt;
  final String status;
  final String whoAdded;

  Loan({
    required this.ID,
    required this.studentID,
    required this.bookID,
    required this.borrowDate,
    required this.returnDate,
    required this.returnedAt,
    required this.status,
    required this.whoAdded,
  });

  static List<Loan> fromLists({
    required List<Map<String, dynamic>> loanListFromBE,
  }) {
    List<Loan> loans = [];
    for (int i = 0; i < loanListFromBE.length; i++) {
      Map<String, dynamic> currentDict = loanListFromBE[i];
      loans.add(
        Loan(
          ID: currentDict["ID"],
          studentID: currentDict["studentID"],
          bookID: currentDict["bookID"],
          borrowDate: currentDict["borrowDate"],
          returnDate: currentDict["returnDate"],
          returnedAt: currentDict["returnedAt"],
          status: currentDict["status"],
          whoAdded: currentDict["whoAdded"],
        ),
      );
    }
    return loans;
  }
}

class UpdateLoanWidget extends StatefulWidget {
  final VoidCallback onCancel;

  const UpdateLoanWidget({super.key, required this.onCancel});

  @override
  State<UpdateLoanWidget> createState() => _UpdateLoanWidgetState();
}

class _UpdateLoanWidgetState extends State<UpdateLoanWidget> {
  TextEditingController idController = TextEditingController();
  TextEditingController bookIDController = TextEditingController();
  TextEditingController stdIDController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();

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
              "Kitap Ödünç Alım Güncelleme",
              textAlign: TextAlign.center,
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
                    var response = await listLoans(
                      isWithFilter: true,
                      filterType: "id",
                      filterValue: idController.text,
                      limit: 1,
                      pageNumber: 1,
                    );
                    setState(() {
                      if (response?["success"] == true &&
                          response?["data"]["loans"] != []) {
                        Map<String, dynamic> currentLoan =
                            response?["data"]["loans"][0];
                        bookIDController.text = currentLoan["bookID"]
                            .toString();
                        stdIDController.text = currentLoan["studentID"]
                            .toString();
                        _returnDateController.text = currentLoan["returnDate"];
                      } else {
                        bookIDController.clear();
                        stdIDController.clear();
                        _returnDateController.clear();
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
                  controller: stdIDController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Öğrenci No",
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
                  controller: bookIDController,
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 300.0,
                child: TextFormField(
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

                    DateTime initialDatePickerDate = today;
                    if (_returnDateController.text.isNotEmpty) {
                      try {
                        List<String> parts = _returnDateController.text.split(
                          '/',
                        );
                        if (parts.length == 3) {
                          int day = int.parse(parts[0]);
                          int month = int.parse(parts[1]);
                          int year = int.parse(parts[2]);
                          initialDatePickerDate = DateTime(year, month, day);
                        }
                      } catch (_) {
                        initialDatePickerDate = today;
                      }
                    }

                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: initialDatePickerDate,
                      firstDate: today,
                      lastDate: DateTime(today.year + 4, 6, 10),
                    );

                    if (pickedDate != null) {
                      String day = pickedDate.day.toString().padLeft(2, '0');
                      String month = pickedDate.month.toString().padLeft(
                        2,
                        '0',
                      );
                      String year = pickedDate.year.toString();

                      _returnDateController.text = "$day/$month/$year";
                    }
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                int parsedStdID = int.tryParse(stdIDController.text) ?? 0;
                int parsedBkID = int.tryParse(bookIDController.text) ?? 0;

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
