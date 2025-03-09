import 'package:flutter/material.dart';
import 'dart:io';

class ImageDisplayPage extends StatelessWidget {
  final File image;

  const ImageDisplayPage({super.key, required this.image, required List boxes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Selected Image",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff083C27),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Image.file(
          image,
          width: 300,
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
