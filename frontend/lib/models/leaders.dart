import 'package:flutter/material.dart';
import 'package:frontend/api_requests.dart';
import 'package:flutter/services.dart';
import 'package:frontend/config.dart';
import 'package:number_pagination/number_pagination.dart';

class ListLeadersWidget extends StatefulWidget {
  final VoidCallback onCancel;
  const ListLeadersWidget({super.key, required this.onCancel});

  @override
  State<ListLeadersWidget> createState() => _ListLeadersWidgetState();
}

class _ListLeadersWidgetState extends State<ListLeadersWidget> {
  int currentPageNumber = 1;
  int totalPages = 1;
  int totalLeaders = 0;
  String limit = "10";

  bool isData = false;
  List<Leader> leaderList = [];

  Future<void> _fetchData({required bool isFirst}) async {
    var response = await listLeaders(
      limit: int.tryParse(limit) ?? 10,
      pageNumber: currentPageNumber,
    );

    if (response?["success"] == true) {
      var data = response?["data"];
      setState(() {
        isData = true;
        leaderList = Leader.fromLists(
          leaderListFromBE: List<Map<String, dynamic>>.from(
            data["leaders"] ?? [],
          ),
        );

        if (isFirst) {
          totalPages = data["pageCount"] ?? 1;
          totalLeaders = data["totalLeaders"] ?? 0;
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(width: 100.0),
          Container(
            width: 400,
            height: 300,
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
                              DataColumn(label: Text("Öğrenci ID")),
                              DataColumn(label: Text("Okuduğu Kitap Sayısı")),
                            ],
                            rows: List.generate(leaderList.length, (i) {
                              Leader currentLeader = leaderList[i];
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(currentLeader.studentID.toString()),
                                  ),
                                  DataCell(
                                    Text(currentLeader.readBooks.toString()),
                                  ),
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
    );
  }
}

class Leader {
  final int studentID;
  final int readBooks;

  Leader({required this.studentID, required this.readBooks});

  static List<Leader> fromLists({
    required List<Map<String, dynamic>> leaderListFromBE,
  }) {
    List<Leader> leaders = [];
    for (int i = 0; i < leaderListFromBE.length; i++) {
      Map<String, dynamic> currentDict = leaderListFromBE[i];
      leaders.add(
        Leader(
          studentID: currentDict["studentID"],
          readBooks: currentDict["readBooks"],
        ),
      );
    }
    return leaders;
  }
}
