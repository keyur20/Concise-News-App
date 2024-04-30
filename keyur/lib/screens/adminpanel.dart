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

import 'help.dart'; // Import the Help.dart file
import 'feedback.dart'; // Import the Feedback.dart file

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final user = FirebaseAuth.instance.currentUser;
  File? _image;
  String? _imageUrl; // Added variable to store image URL
  String? _selectedCategory = 'General'; // Default selected category

  @override
  void initState() {
    super.initState();
    _fetchImageUrl();
    _fetchSelectedCategory(); // Fetch selected category from Firestore
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

  void _removeImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove Image?"),
          content: Text("Are you sure you want to remove the profile photo?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Remove"),
              onPressed: () async {
                try {
                  setState(() {
                    _image = null;
                    _imageUrl = null;
                  });

                  // Delete image URL from Firestore
                  await FirebaseFirestore.instance.collection('example').doc(user?.uid).update({
                    'imageUrl': FieldValue.delete(),
                  });

                  print('Image removed from Firestore.');
                } catch (e) {
                  print('Error removing image from Firestore: $e');
                }
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

  void openHelpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelpPage()), // Navigate to the HelpPage
    );
  }

  void openFeedbackPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeedbackPage()), // Navigate to the FeedbackPage
    );
  }

  Future<void> _fetchSelectedCategory() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('category').doc(user!.email).get();
      if (snapshot.exists) {
        setState(() {
          _selectedCategory = snapshot.data()?['category'];
        });
      }
    } catch (e) {
      print('Error fetching selected category: $e');
    }
  }

  void _updateCategory(String category) async {
    try {
      await FirebaseFirestore.instance.collection('category').doc(user!.email).set({
        'category': category,
      });
      setState(() {
        _selectedCategory = category;
      });
    } catch (e) {
      print('Error updating category: $e');
    }
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
            child: Stack(
              alignment: Alignment.bottomRight, // Aligning the stack content
              children: [
                Column(
                  children: [
                    Text(
                      'Profile',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center, // Centering the text horizontally
                    ),
                    SizedBox(height: 8.0), // Adding some spacing between text and avatar
                    GestureDetector(
                      onTap: _getImage,
                      child: CircleAvatar(
                        radius: 60, // Increased radius to make it larger
                        backgroundImage: _imageUrl != null // Use _imageUrl if available
                            ? NetworkImage(_imageUrl!)
                            : (_image != null
                                ? FileImage(_image!)
                                : AssetImage('assets/images/dummy_profile.png') as ImageProvider),
                      ),
                    ),
                  ],
                ),
                if (_imageUrl != null || _image != null) // Conditional rendering of cross icon
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => _removeImage(),
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
          Divider(), // New divider line
          GestureDetector(
            onTap: openHelpPage, // Navigate to the HelpPage
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligning the help text horizontally
                children: [
                  Text(
                    'FAQs and About US',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyText1!.color, // Use theme text color
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(), // New divider line
          GestureDetector(
            onTap: openFeedbackPage, // Navigate to the FeedbackPage
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligning the feedback text horizontally
                children: [
                  Text(
                    'Feedback',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyText1!.color, // Use theme text color
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(), // New divider line
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyText1!.color, // Use theme text color
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedCategory,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                    _updateCategory(newValue!); // Update category in Firestore
                  },
                  items: <String>['General', 'Entertainment', 'Health', 'Sports', 'Business', 'Technology']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
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
