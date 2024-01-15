// ignore_for_file: prefer_const_constructors, unused_import, unused_element

import 'dart:io';
import 'package:fb/features/user_auth/presentation/pages/image%20display.dart';
import 'package:fb/features/user_auth/presentation/pages/presentation2/image%20display.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PageScanner2 extends StatefulWidget {
  const PageScanner2({Key? key}) : super(key: key);

  @override
  State<PageScanner2> createState() => _PageScanner2State();
}

class _PageScanner2State extends State<PageScanner2> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/scan.gif',
                width: 230,
                height: 230,
              ),
              SizedBox(height: 20),
              _selectedImage != null
                  ? Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 25, 201, 204),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            _showImageSelectionOptions();
                          },
                          child: Text(
                            'Scan Prescription',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 25, 201, 204),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            _showImageSelectionOptions();
                          },
                          child: Text(
                            'Scan Prescription',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSelectionOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              onTap: () {
                _pickImageFromCamera();
                Navigator.pop(context);
              },
              leading: Icon(Icons.camera_alt),
              title: Text('Select by Camera'),
            ),
            ListTile(
              onTap: () {
                _pickImageFromGallery();
                Navigator.pop(context);
              },
              leading: Icon(Icons.photo),
              title: Text('Select by Gallery'),
            ),
          ],
        );
      },
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _navigateToImageDisplay(returnedImage);
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _navigateToImageDisplay(returnedImage);
  }

  void _navigateToImageDisplay(XFile? pickedImage) {
    if (pickedImage == null) return;
    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageDisplayPage2(selectedImage: _selectedImage!),
      ),
    );
  }
}
