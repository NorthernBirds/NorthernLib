import 'package:flutter/material.dart';
import 'dart:io';

const String baseUrl = "http://127.0.0.1:5000/backend";

Map<String, String> session = {"userName": "", "role": "", "token": ""};

const String appKey = "<your_app_token>";

List<dynamic> categories = [
  "Roman",
  "Hikaye",
  "Şiir",
  "Biyografi",
  "Otobiyografi",
  "Tarih",
  "Bilim",
  "Kişisel Gelişim",
  "Ders Kitabı",
  "Ansiklopedi",
  "Çizgi Roman",
];

String userPhotoForTeachersAndStudentStaffs = "assets/images/userPhoto.png";

const Color color = Color(0xFF3A8772);

const Color color2 = Color.fromARGB(255, 26, 80, 65);

const String aboutMeText = "<your_about_me_text>";

const String communicationInfos = "<your_communication_infos>";

Directory logDir = Directory('${Directory.current.path}/log');
