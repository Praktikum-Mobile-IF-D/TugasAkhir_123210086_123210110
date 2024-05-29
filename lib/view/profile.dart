import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:proyek_akhir/hive/user.dart';
import 'package:proyek_akhir/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences loginData;
  User? _user;

  @override
  void initState() {
    initial();
    super.initState();
    _loadUserData();
  }

  void initial() async {
    loginData = await SharedPreferences.getInstance();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null) {
      var box = Hive.box<User>('usersBox');
      User? user = box.values.firstWhere((user) => user.username == username);
      setState(() {
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 500,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _user!.imagePath != null && _user!.imagePath!.isNotEmpty
                          ? FileImage(File(_user!.imagePath!))
                          : NetworkImage('https://example.com/photo.jpg')
                              as ImageProvider,
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  _user!.username,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text('@' + _user!.username),
              ),
              SizedBox(height: 16),
              ProfileDetailRow(label: 'Username', value: _user!.username),
              ProfileDetailRow(label: 'No Telp', value: _user!.noTelepon),
              ProfileDetailRow(label: 'Alamat', value: _user!.alamat),
              ProfileDetailRow(label: 'Email', value: _user!.email),
              ProfileDetailRow(label: 'Password', value: _user!.password),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    loginData.setBool('login', true);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text('Log out'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final String label;
  final String value;

  ProfileDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
