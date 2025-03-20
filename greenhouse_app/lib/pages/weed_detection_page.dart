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
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // Function to pick an image from the gallery or capture from the camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      setState(() {
        _image = imageFile;
        _isLoading = true;
      });

      List<dynamic> boxes = await ApiService.uploadImage(_image!);

      setState(() {
        _isLoading = false;
      });

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
              "Capture or Upload an Image to Detect Weeds.",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  ) // Show loading while processing
                : _image != null
                    ? Image.file(_image!,
                        width: 300, height: 300, fit: BoxFit.contain)
                    : Image.asset(
                        'assets/capture.png',
                        width: 400,
                        height: 300,
                        fit: BoxFit.contain,
                      ), // Show camera image if no image is selected
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Capture Photo",
                      style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Upload Image",
                      style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}