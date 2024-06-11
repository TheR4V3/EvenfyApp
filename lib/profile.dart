import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'dart:io';
import 'historyPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = 'Juher';
  int _age = 21;
  String _job = 'UI/UX Designer';
  String _imagePath = 'profile/assets/pp.jpg';

  void _updateProfile(String name, int age, String job, String imagePath) {
    setState(() {
      _name = name;
      _age = age;
      _job = job;
      _imagePath = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bagian 1: Banner Wallpaper
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors
                      .red, // Ganti dengan warna atau gambar wallpaper yang sesuai
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Gambar profile
                    Container(
                      width: 120,
                      height: 120,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white, width: 3), // Stroke putih
                        image: DecorationImage(
                          image: _imagePath.startsWith('profile')
                              ? AssetImage(_imagePath)
                              : FileImage(File(_imagePath)) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Nama, Usia, Pekerjaan
                    Text(
                      '$_name, $_age',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserat',
                      ),
                    ),
                    Text(
                      _job,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),

              // Spacer antara banner wallpaper dan konten profile
              SizedBox(height: 20),

              // Bagian 2: Isi konten profile
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card 1: Edit User Profile
                    InkWell(
                      onTap: () async {
                        final updatedProfile = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              name: _name,
                              age: _age,
                              job: _job,
                              imagePath: _imagePath,
                            ),
                          ),
                        );

                        if (updatedProfile != null) {
                          _updateProfile(
                            updatedProfile['name'],
                            updatedProfile['age'],
                            updatedProfile['job'],
                            updatedProfile['imagePath'],
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Edit User Profile"),
                            Icon(Icons.edit),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HistoryPage()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("History Events"),
                            Icon(Icons.history),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
