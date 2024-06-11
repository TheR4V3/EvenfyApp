import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class EditProfilePage extends StatefulWidget {
  final String name;
  final int age;
  final String job;
  final String imagePath;

  EditProfilePage({
    required this.name,
    required this.age,
    required this.job,
    required this.imagePath,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _imageFile;
  Uint8List? _webImageFile;
  final picker = ImagePicker();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _jobController;
  String _imagePath = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _ageController = TextEditingController(text: widget.age.toString());
    _jobController = TextEditingController(text: widget.job);
    _imagePath = widget.imagePath;
  }

  Future<void> pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _webImageFile = result.files.single.bytes!;
          _imagePath = result.files.single.name; // Store the name for NetworkImage
        });
      }
    } else {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);
          _imagePath = pickedFile.path;
        } else {
          print('No image selected.');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: kIsWeb
                      ? _webImageFile != null
                          ? MemoryImage(_webImageFile!) as ImageProvider
                          : NetworkImage(widget.imagePath)
                      : _imageFile != null
                          ? FileImage(_imageFile!) as ImageProvider
                          : AssetImage(widget.imagePath),
                  child: (_imageFile == null && _webImageFile == null)
                      ? Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: Colors.grey[800],
                        )
                      : null,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _jobController,
                decoration: InputDecoration(
                  labelText: 'Job',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String name = _nameController.text;
                  int age = int.tryParse(_ageController.text) ?? widget.age;
                  String job = _jobController.text;
                  Navigator.pop(context, {
                    'name': name,
                    'age': age,
                    'job': job,
                    'imagePath': _imagePath,
                  });
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
