import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:greenhouse_app/pages/image_display_page.dart'; // Import the new image display page

class WeedDetectionPage extends StatefulWidget {
  const WeedDetectionPage({super.key});

  @override
  _WeedDetectionPageState createState() => _WeedDetectionPageState();
}

class _WeedDetectionPageState extends State<WeedDetectionPage> {
  File? _image;

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    // Pick an image from the gallery
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Save the picked image
      });
      // Navigate to the new page with the selected image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageDisplayPage(image: _image!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weed Detection",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff083C27),
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Capture or Upload a Chili Plant to Check Quality.",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _pickImage, // Call the function to pick an image
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Add Image",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add logic for 'Scan Image' here
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Scan Image",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
