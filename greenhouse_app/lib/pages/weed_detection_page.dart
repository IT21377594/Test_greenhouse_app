import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/weed_image_display.dart';
import 'package:greenhouse_app/services/api_service.dart';

class WeedDetectionPage extends StatefulWidget {
  const WeedDetectionPage({super.key});

  @override
  _WeedDetectionPageState createState() => _WeedDetectionPageState();
}

class _WeedDetectionPageState extends State<WeedDetectionPage> {
  File? _image;
  bool _isLoading = false;

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      setState(() {
        _image = imageFile;
      });

      List<dynamic> boxes = await ApiService.uploadImage(_image!);

      // Debug: Print bounding boxes before navigating
      print("Bounding Boxes Sent to Result Page: $boxes");

      if (boxes.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ImageDisplayPage(image: _image!, boxes: boxes),
          ),
        );
      } else {
        print("No weeds detected by backend!");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No weeds detected.")),
        );
      }
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
        backgroundColor: const Color(0xff083C27),
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              "Capture or Upload a Chili Plant to Check Quality.",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Show loading while processing
                : _image != null
                    ? Image.file(_image!,
                        width: 300, height: 300, fit: BoxFit.cover)
                    : const Text("Select an Image"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _pickImage, // Pick and upload the image
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      const Text("Add Image", style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Future: Add logic for real-time scan here
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      const Text("Scan Image", style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
