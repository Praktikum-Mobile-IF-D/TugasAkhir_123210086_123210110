import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:proyek_akhir/hive/user.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File? _image;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _noTeleponController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  String _encryptPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _register() async {
    if (_usernameController.text.isEmpty ||
        _noTeleponController.text.isEmpty ||
        _alamatController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Harap Isi Data Anda!'),
          content: Text('Inputan Tidak Boleh Kosong'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (!_emailController.text.contains('@')) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Email Tidak Valid!'),
          content: Text('Email yang Anda masukkan tidak valid.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    var box = Hive.box<User>('usersBox');
    bool emailExists = false;
    for (var user in box.values) {
      if (user.email == _emailController.text) {
        emailExists = true;
        break;
      }
    }
    if (emailExists) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Email Sudah Digunakan!'),
          content: Text('Email yang Anda masukkan sudah terdaftar.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    String encryptedPassword = _encryptPassword(_passwordController.text);

    User newUser = User(
      username: _usernameController.text,
      noTelepon: _noTeleponController.text,
      alamat: _alamatController.text,
      email: _emailController.text,
      password: encryptedPassword,
      imagePath: _image?.path,
      carts: [],
    );

    await box.add(newUser);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  "Hello, selamat datang!",
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 40.0),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    hintText: "Masukkan nama Anda",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _noTeleponController,
                  decoration: InputDecoration(
                    labelText: "No Telepon",
                    hintText: "Masukkan nomor telepon Anda",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _alamatController,
                  decoration: InputDecoration(
                    labelText: "Alamat",
                    hintText: "Masukkan alamat Anda",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Masukkan email Anda",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Masukkan password Anda",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text("Upload Gambar"),
                    ),
                    SizedBox(width: 10.0),
                    _image != null
                        ? Image.file(_image!, width: 50, height: 50)
                        : Container(),
                  ],
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _register,
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 100.0, vertical: 15.0),
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text("Sudah memiliki akun?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text("Masuk"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
