import 'package:flutter/material.dart';
import 'package:proyek_akhir/view/home.dart';
import 'package:proyek_akhir/view/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage());
  }
}
