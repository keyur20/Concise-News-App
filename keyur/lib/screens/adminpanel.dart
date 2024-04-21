import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_2/theme_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final user = FirebaseAuth.instance.currentUser;
  File? _image;
  String? _imageUrl; // Added variable to store image URL

  @override
  void initState() {
    super.initState();
    _fetchImageUrl();
  }

  Future<void> _fetchImageUrl() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('example').doc(user!.uid).get();
      if (snapshot.exists) {
        setState(() {
          _imageUrl = snapshot.data()?['imageUrl'];
        });
      }
    } catch (e) {
      print('Error fetching image URL: $e');
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        _showUploadDialog(); // Show upload dialog after selecting image
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImageToFirebase() async {
    if (_image == null) {
      print('No image to upload.');
      return;
    }

    try {
      final storage = FirebaseStorage.instance;
      final Reference storageRef = storage.ref().child('profile/${user!.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(_image!);
      final TaskSnapshot uploadSnapshot = await uploadTask.whenComplete(() {});
      final String downloadURL = await uploadSnapshot.ref.getDownloadURL();

      setState(() {
        _imageUrl = downloadURL; // Save image URL
      });

      // Save image URL to Firestore
      await FirebaseFirestore.instance.collection('example').doc(user?.uid).set({
        'imageUrl': downloadURL,
      });

      print('Image uploaded to Firebase Storage: $downloadURL');
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Upload Image?"),
          content: Text("Do you want to upload the selected image?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                _uploadImageToFirebase();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  signout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  void shareApp() {
    const String appLink = 'https://example.com/myapp';
    Share.share('Check out this cool app: $appLink');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: shareApp,
          ),
        ],
      ),
      body: Column(
        children: [
          Divider(), // Line above
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8.0),
                GestureDetector(
                  onTap: _getImage,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: _imageUrl != null // Use _imageUrl if available
                        ? NetworkImage(_imageUrl!)
                        : (_image != null
                        ? FileImage(_image!)
                        : AssetImage('assets/images/dummy_profile.png') as ImageProvider),
                  ),
                ),
              ],
            ),
          ),
          Divider(), // Line below
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Theme', style: TextStyle(fontSize: 16)),
                Obx(() => Switch(
                  value: themeController.isDarkTheme.value,
                  onChanged: (value) {
                    themeController.toggleTheme();
                  },
                )),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: signout,
        child: Icon(Icons.logout),
      ),
    );
  }
}
