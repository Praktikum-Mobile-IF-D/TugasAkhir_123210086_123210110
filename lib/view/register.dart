import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hive/hive.dart';
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

  Future<void> _register() async {
    var box = Hive.box<User>('usersBox');

    User newUser = User(
      username: _usernameController.text,
      noTelepon: _noTeleponController.text,
      alamat: _alamatController.text,
      email: _emailController.text,
      password: _passwordController.text,
      imagePath: _image?.path,
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
