import 'package:flutter/material.dart';
import 'package:frontend/api_requests.dart';
import 'package:frontend/config.dart';
import 'package:frontend/dashboards/signInDashboard.dart';
import 'package:frontend/models/books.dart';
import 'package:frontend/models/categories.dart';
import 'package:frontend/models/loans.dart';
import 'package:frontend/models/leaders.dart';
import 'package:frontend/models/users.dart';
import 'package:frontend/models/reset.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final ButtonStyle _menuButtonStyle = ElevatedButton.styleFrom(
    side: const BorderSide(color: Color(0xFF3A8772)),
    padding: const EdgeInsets.all(20.0),
    backgroundColor: const Color(0xFF3A8772),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  );

  final TextStyle _labelTextStyle = const TextStyle(
    fontFamily: "Inter",
    fontWeight: FontWeight.normal,
    fontSize: 14.0,
    color: Colors.black,
  );

  bool isAddBookWidgetVisible = false;
  bool isDeleteBookWidgetVisible = false;
  bool isListBooksWidgetVisible = false;

  bool isAddCategoryWidgetVisible = false;
  bool isDeleteCategoryWidgetVisible = false;
  bool isListCategoriesWidgetVisible = false;

  bool isBorrowBookWidgetVisible = false;
  bool isReturnBookWidgetVisible = false;
  bool isListLoansWidgetVisible = false;
  bool isListLeadersWidgetVisible = false;

  bool isAddUserWidgetVisible = false;
  bool isDeleteUserWidgetVisible = false;
  bool isListUsersWidgetVisible = false;
  bool isChangeRoleWidgetVisible = false;

  bool isResetWidgetVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Container(
            width: 300.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Colors.black, width: 2)),
              color: const Color(0xFF3A8772),
            ),
            child: SingleChildScrollView(
              primary: true,
              child: Container(
                color: const Color(0xFF3A8772),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/adminUserPhoto.png",
                      width: 200.0,
                      height: 200.0,
                    ),
                    const SizedBox(height: 17.0),

                    const Text(
                      "Kitap İşlemleri",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.7,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 17.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isAddBookWidgetVisible = true;
                        });
                      },
                      style: _menuButtonStyle,
                      child: Text("Kitap Ekle", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 9.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isDeleteBookWidgetVisible = true;
                        });
                      },
                      style: _menuButtonStyle,
                      child: Text("Kitap Sil", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 9.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isListBooksWidgetVisible = true;
                        });
                      },
                      style: _menuButtonStyle,
                      child: Text("Kitap Listele", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 17.0),

                    const Text(
                      "Kategori İşlemleri",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.7,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 17.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isAddCategoryWidgetVisible = true;
                        });
                      },
                      style: _menuButtonStyle,
                      child: Text("Kategori Ekle", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 9.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isDeleteCategoryWidgetVisible = true;
                        });
                      },
                      style: _menuButtonStyle,
                      child: Text("Kategori Sil", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 9.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isListCategoriesWidgetVisible = true;
                        });
                      },
                      style: _menuButtonStyle,
                      child: Text("Kategori Listele", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 17.0),

                    const Text(
                      "Ödünç Alma İşlemleri",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.7,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 17.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isBorrowBookWidgetVisible = true;
                        });
                      },
                      style: _menuButtonStyle,
                      child: Text("Ödünç Kitap Ver", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 9.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isReturnBookWidgetVisible = true;
                        });
                      },
                      style: _menuButtonStyle,
                      child: Text("Kitap Geri Al", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 9.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isListLoansWidgetVisible = true;
                        });
                      },
                      style: _menuButtonStyle,
                      child: Text(
                        "Ödünç Kitapları Listele",
                        style: _labelTextStyle,
                      ),
                    ),
                    const SizedBox(height: 9.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isListLeadersWidgetVisible = true;
                        });
                      },
                      style: _menuButtonStyle,
                      child: Text("Liderleri Listele", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 17.0),

                    const Text(
                      "Kullanıcı İşlemleri",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.7,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 17.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isAddUserWidgetVisible = true;
                        });
                      },
                      style: _menuButtonStyle,
                      child: Text("Kullanıcı Ekle", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 9.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isDeleteUserWidgetVisible = true;
                        });
                      },
                      style: _menuButtonStyle,
                      child: Text("Kullanıcı Sil", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 9.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isListUsersWidgetVisible = true;
                        });
                      },
                      style: _menuButtonStyle,
                      child: Text("Kullanıcı Listele", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 9.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isChangeRoleWidgetVisible = true;
                        });
                      },
                      style: _menuButtonStyle,
                      child: Text(
                        "Kullanıcı Rolü Değiştir",
                        style: _labelTextStyle,
                      ),
                    ),
                    const SizedBox(height: 17.0),

                    const Text(
                      "Sıfırlama İşlemleri",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.7,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 17.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isResetWidgetVisible = true;
                        });
                      },
                      style: _menuButtonStyle,
                      child: Text("Sistemi Sıfırla", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 17.0),

                    const Text(
                      "Çıkış İşlemleri",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.7,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 17.0),
                    ElevatedButton(
                      onPressed: () async {
                        await signOut();
                        session.clear();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginDashboard(),
                          ),
                        );
                      },
                      style: _menuButtonStyle,
                      child: Text("Çıkış Yap", style: _labelTextStyle),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/libImage.png"),
                  fit: BoxFit.cover,
                ),
              ),

              child: isAddBookWidgetVisible
                  ? AddBookWidget(
                      onCancel: () {
                        setState(() {
                          isAddBookWidgetVisible = false;
                        });
                      },
                    )
                  : isDeleteBookWidgetVisible
                  ? DeleteBookWidget(
                      onCancel: () {
                        setState(() {
                          isDeleteBookWidgetVisible = false;
                        });
                      },
                    )
                  : isListBooksWidgetVisible
                  ? ListBooksWidget(
                      onCancel: () {
                        setState(() {
                          isListBooksWidgetVisible = false;
                        });
                      },
                    )
                  : isAddCategoryWidgetVisible
                  ? AddCategoryWidget(
                      onCancel: () {
                        setState(() {
                          isAddCategoryWidgetVisible = false;
                        });
                      },
                    )
                  : isDeleteCategoryWidgetVisible
                  ? DeleteCategoryWidget(
                      onCancel: () {
                        setState(() {
                          isDeleteCategoryWidgetVisible = false;
                        });
                      },
                    )
                  : isListCategoriesWidgetVisible
                  ? ListCategoriesWidget(
                      onCancel: () {
                        setState(() {
                          isListCategoriesWidgetVisible = false;
                        });
                      },
                    )
                  : isBorrowBookWidgetVisible
                  ? BorrowBookWidget(
                      onCancel: () {
                        setState(() {
                          isBorrowBookWidgetVisible = false;
                        });
                      },
                    )
                  : isReturnBookWidgetVisible
                  ? ReturnBookWidget(
                      onCancel: () {
                        setState(() {
                          isReturnBookWidgetVisible = false;
                        });
                      },
                    )
                  : isListLoansWidgetVisible
                  ? ListLoansWidget(
                      onCancel: () {
                        setState(() {
                          isListLoansWidgetVisible = false;
                        });
                      },
                    )
                  : isListLeadersWidgetVisible
                  ? ListLeadersWidget(
                      onCancel: () {
                        setState(() {
                          isListLeadersWidgetVisible = false;
                        });
                      },
                    )
                  : isListCategoriesWidgetVisible
                  ? ListCategoriesWidget(
                      onCancel: () {
                        setState(() {
                          isListCategoriesWidgetVisible = false;
                        });
                      },
                    )
                  : isBorrowBookWidgetVisible
                  ? BorrowBookWidget(
                      onCancel: () {
                        setState(() {
                          isBorrowBookWidgetVisible = false;
                        });
                      },
                    )
                  : isReturnBookWidgetVisible
                  ? ReturnBookWidget(
                      onCancel: () {
                        setState(() {
                          isReturnBookWidgetVisible = false;
                        });
                      },
                    )
                  : isListLoansWidgetVisible
                  ? ListLoansWidget(
                      onCancel: () {
                        setState(() {
                          isListLoansWidgetVisible = false;
                        });
                      },
                    )
                  : isListLeadersWidgetVisible
                  ? ListLeadersWidget(
                      onCancel: () {
                        setState(() {
                          isListLeadersWidgetVisible = false;
                        });
                      },
                    )
                  : isListCategoriesWidgetVisible
                  ? ListCategoriesWidget(
                      onCancel: () {
                        setState(() {
                          isListCategoriesWidgetVisible = false;
                        });
                      },
                    )
                  : isBorrowBookWidgetVisible
                  ? BorrowBookWidget(
                      onCancel: () {
                        setState(() {
                          isBorrowBookWidgetVisible = false;
                        });
                      },
                    )
                  : isReturnBookWidgetVisible
                  ? ReturnBookWidget(
                      onCancel: () {
                        setState(() {
                          isReturnBookWidgetVisible = false;
                        });
                      },
                    )
                  : isListLoansWidgetVisible
                  ? ListLoansWidget(
                      onCancel: () {
                        setState(() {
                          isListLoansWidgetVisible = false;
                        });
                      },
                    )
                  : isListLeadersWidgetVisible
                  ? ListLeadersWidget(
                      onCancel: () {
                        setState(() {
                          isListLeadersWidgetVisible = false;
                        });
                      },
                    )
                  : isAddUserWidgetVisible
                  ? AddUserWidget(
                      onCancel: () {
                        setState(() {
                          isBorrowBookWidgetVisible = false;
                        });
                      },
                    )
                  : isDeleteUserWidgetVisible
                  ? DeleteUserWidget(
                      onCancel: () {
                        setState(() {
                          isReturnBookWidgetVisible = false;
                        });
                      },
                    )
                  : isListUsersWidgetVisible
                  ? ListUsersWidget(
                      onCancel: () {
                        setState(() {
                          isListLoansWidgetVisible = false;
                        });
                      },
                    )
                  : isChangeRoleWidgetVisible
                  ? ChangeRoleWidget(
                      onCancel: () {
                        setState(() {
                          isListLeadersWidgetVisible = false;
                        });
                      },
                    )
                  : isResetWidgetVisible
                  ? ResetWidget(
                      onCancel: () {
                        setState(() {
                          isResetWidgetVisible = false;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
