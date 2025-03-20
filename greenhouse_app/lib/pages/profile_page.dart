import 'package:greenhouse_app/pages/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker package
import 'dart:io'; // Import for File
import '../services/auth_service.dart';
import '../services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "";
  String userEmail = "";
  File? _profileImage; // To store the selected image file
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    var userData = await _authService.getUserData();
    setState(() {
      userName = userData['name'] ?? "";
      userEmail = userData['email'] ?? "";
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image from the gallery
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 15),
            child: GestureDetector(
              onTap:
                  _pickImage, // Allow image picking when the avatar is tapped
              child: CircleAvatar(
                radius: 62,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: _profileImage == null
                    ? const CircleAvatar(
                        radius: 60,
                        foregroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1464863979621-258859e62245?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3386&q=80'),
                      )
                    : CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            FileImage(_profileImage!), // Use selected image
                      ),
              ),
            ),
          ),
          Center(
            child: Text(
              userName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Center(
            child: Text(
              userEmail,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 25),
          ListTile(
            title: const Text("My orders"),
            leading: const Icon(IconlyLight.bag),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrdersPage(),
                  ));
            },
          ),
          ListTile(
            title: const Text("About us"),
            leading: const Icon(IconlyLight.infoSquare),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Logout"),
            leading: const Icon(Icons.logout),
            onTap: () async {
              await _authService.logout();
              Navigator.pushReplacementNamed(context, '/signin');
            },
          ),
        ],
      ),
    );
  }
}