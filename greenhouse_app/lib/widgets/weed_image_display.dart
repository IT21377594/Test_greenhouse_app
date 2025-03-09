import 'package:flutter/material.dart';
import 'dart:io';

class ImageDisplayPage extends StatelessWidget {
  final File image;
  final List<dynamic> boxes;

  const ImageDisplayPage({super.key, required this.image, required this.boxes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Detection Result"), backgroundColor: Colors.green),
      body: Center(
        child: Stack(
          children: [
            Image.file(image, width: 300, height: 300, fit: BoxFit.cover),
            ...boxes.map((box) {
              return Positioned(
                left: box[0] * 300, // Scale based on image size
                top: box[1] * 300,
                width: (box[2] - box[0]) * 300,
                height: (box[3] - box[1]) * 300,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                  ),
                  child: const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.all(2),
                      child: Text(
                        "Weed",
                        style: TextStyle(
                            color: Colors.white,
                            backgroundColor: Colors.red,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
