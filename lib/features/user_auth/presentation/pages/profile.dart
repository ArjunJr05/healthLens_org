// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, sort_child_properties_last, deprecated_member_use, no_leading_underscores_for_local_identifiers, avoid_print, unused_field, use_build_context_synchronously, unused_import, prefer_const_literals_to_create_immutables

import 'dart:typed_data';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb/features/user_auth/presentation/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePage2State();
}

class _ProfilePage2State extends State<ProfilePage> {
  late Uint8List _image;
  _ProfilePage2State() {
    _image = Uint8List(0);
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    _navigateToImageDisplay(img);
  }

  Future<void> updateName() async {
    String newName = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String enteredName = '';

        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Enter Name'),
            content: TextField(
              onChanged: (value) {
                enteredName = value;
              },
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(enteredName);
                },
                child: Text('Save'),
              ),
            ],
          ),
        );
      },
    );

    if (newName != null) {
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'name': newName});
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('userProfile')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.data() != null) {
                        Map<String, dynamic> userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        String? imageLink = userData['imageLink'];

                        return CircleAvatar(
                          radius: 64,
                          backgroundImage: imageLink != null
                              ? CachedNetworkImageProvider(imageLink)
                              : null,
                          child: imageLink == null
                              ? const Icon(
                                  Icons.person,
                                  size: 64,
                                  color: Colors.black,
                                )
                              : null,
                        );
                      } else {
                        return const CircleAvatar(
                          radius: 64,
                          child: Icon(
                            Icons.person,
                            size: 64,
                            color: Colors.black,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('userProfile')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  String userName = '';
                  if (snapshot.hasData) {
                    userName = snapshot.data!['name'];
                  }

                  return Text(
                    userName,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  );
                },
              ),
              SizedBox(height: 12.0),
              Text(
                FirebaseAuth.instance.currentUser?.email ??
                    'arjunfree256@gmail.com',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage(),
                    ),
                  );
                },
                child: Text(
                  'Log Out',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.warning, // Replace with the desired icon
                    color: Colors.grey,
                  ),
                  SizedBox(
                      width: 8.0), // Adjust the spacing between icon and text
                  Expanded(
                    child: Center(
                      child: Text(
                        '\nDisclaimer: If you need to change your name and profile, relogin!...',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 25, 201, 204),
      title: Padding(
        padding: const EdgeInsets.only(left: 70),
        child: SafeArea(
          child: Text(
            'Health Lens',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<Uint8List> pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Images Selected');
    return Uint8List(0);
  }

  void _navigateToImageDisplay(Uint8List pickedImage) {
    setState(() {
      _image = pickedImage;
    });
  }
}
