import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://192.168.8.182:8000/weed/detect-weed/";

  static Future<List<dynamic>> uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();
      String responseData = await response.stream.bytesToString();

      // Debug: Print API response in Flutter
      print("Flutter API Response: $responseData");

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(responseData);

        if (jsonResponse.containsKey('has_weeds') &&
            jsonResponse['has_weeds']) {
          print("Bounding Boxes Received in Flutter: ${jsonResponse['boxes']}");
          return jsonResponse['boxes']; // Return bounding boxes
        } else {
          print("No weeds detected.");
          return [];
        }
      } else {
        print("API Error: ${response.reasonPhrase}");
        return [];
      }
    } catch (e) {
      print("Exception in API Call: $e");
      return [];
    }
  }
}
