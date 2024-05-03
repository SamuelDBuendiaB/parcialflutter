import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'principal.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Subir extends StatefulWidget {
  @override
  _SubirState createState() => _SubirState();
}

class _SubirState extends State<Subir> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = pickedImage;
    });
  }

Future<void> _upload() async {
  if (_imageFile == null) {
    return;
  }

  final title = _titleController.text.trim();
  final description = _descriptionController.text.trim();

  if (title.isEmpty || description.isEmpty) {
    return;
  }

  try {
    final storageRef = firebase_storage.FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');
    await storageRef.putFile(File(_imageFile!.path));
    final imageUrl = await storageRef.getDownloadURL();

    // Add image details to Firestore
    await FirebaseFirestore.instance.collection('images').add({
      'img': imageUrl,
      'title': title,
      'description': description,
      // You can add more fields here if needed
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image uploaded successfully')));

    // Navigate to Principal screen
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => principal()));
  } catch (e) {
    print('Error uploading image: $e');
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading image')));
  }
}


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("imagenes/frame.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 200, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Type the title',
                            labelStyle: TextStyle(color: const Color.fromARGB(255, 5, 5, 5)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: const Color.fromARGB(255, 83, 83, 83)),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 40),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Write a description',
                            labelStyle: TextStyle(color: const Color.fromARGB(255, 7, 7, 7)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: const Color.fromARGB(255, 82, 82, 82)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _getImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        icon: Icon(Icons.image),
                        label: Text('Upload Image'),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _upload,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Upload'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}








