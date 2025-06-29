import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class SkinPredictorPage extends StatefulWidget {
  @override
  _SkinPredictorPageState createState() => _SkinPredictorPageState();
}

class _SkinPredictorPageState extends State<SkinPredictorPage> {
  File? _image;
  String? topLabel;
  double? topConfidence;

  Future pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        topLabel = null;
        topConfidence = null;
      });
      await uploadImage(_image!);
    }
  }

  Future<void> uploadImage(File image) async {
    final uri = Uri.parse("http://192.168.1.102:8000/predict");

    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final decoded = jsonDecode(responseBody);

      setState(() {
        topLabel = decoded['class'];
        topConfidence = decoded['confidence'];
      });
    } else {
      setState(() {
        topLabel = null;
        topConfidence = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sunucu hatası: ${response.statusCode}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cilt Hastalığı Tespiti')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_image != null) Image.file(_image!, height: 200),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: pickImage, child: const Text("Resim Seç")),
            const SizedBox(height: 16),
            if (topLabel != null && topConfidence != null)
              Text(
                "Tahmin: $topLabel (%${topConfidence!.toStringAsFixed(2)})",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
