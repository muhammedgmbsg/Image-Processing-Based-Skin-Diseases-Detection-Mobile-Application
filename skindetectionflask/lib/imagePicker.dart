import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skindetectionflask/components/drawer.dart';
import 'package:skindetectionflask/core/database/databaseHelper.dart';
import 'package:skindetectionflask/main.dart';
import 'package:skindetectionflask/models/skinModel.dart';
import 'package:skindetectionflask/resultScreen.dart';

/// 2) GELİŞTİRİLMİŞ “RESİM SEÇME” EKRANI + DRAWER
class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  File? _image;
  bool _loading = false;

  Future<void> pickImage(BuildContext context) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
      await _uploadAndSave(context,_image!);
    }
  }

Future<void> _uploadAndSave(BuildContext context, File img) async {
    setState(() => _loading = true);
    final uri = Uri.parse("http://127.0.0.1:8000/predict");
    final req = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', img.path));

    try {
      final res = await req.send();
      final body = await res.stream.bytesToString();
      final data = jsonDecode(body);

      if (res.statusCode == 200) {
        final now = DateTime.now().toIso8601String();
        // kaydet
        await DatabaseHelper.instance.insertResult(SkinResult(
          imagePath: img.path,
          label: data['class'],
          confidence: data['confidence'],
          timestamp: now,
        ));
        // sonuç sayfasına geç
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ResultPage(
            label: data['class'], confidence: data['confidence'])));

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sunucu hatası: ${res.statusCode}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Cilt Fotoğrafı Yükle',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      drawer: AppDrawer(),
      body: Container(
        padding: const EdgeInsets.all(24),
        color: Colors.blue,
        child: Column(
          children: [
            const Text(
              'Lütfen cildinizden bir fotoğraf seçin ya da tekrar yükleyin.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _image == null
                  ? Container(
                      color: Colors.white24,
                      child: const Center(
                        child: Icon(Icons.photo_outlined, size: 80, color: Colors.white70),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_image!, width: double.infinity, fit: BoxFit.cover),
                    ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library, color: Colors.blue),
              label: Text(_image == null ? 'Resim Seç' : 'Resmi Değiştir',
                  style: const TextStyle(color: Colors.blue)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _loading 
    ? null 
    : () => pickImage(context),
            ),
            if (_loading) const Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}