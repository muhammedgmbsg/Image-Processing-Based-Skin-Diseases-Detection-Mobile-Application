import 'dart:io';

import 'package:flutter/material.dart';
import 'package:skindetectionflask/core/database/databaseHelper.dart';
import 'package:skindetectionflask/imagePicker.dart';
import 'package:skindetectionflask/main.dart';
import 'package:skindetectionflask/models/skinModel.dart';

/// 4) SONUÇLARIM SAYFASI
class ResultsListPage extends StatefulWidget {
  @override
  _ResultsListPageState createState() => _ResultsListPageState();
}

class _ResultsListPageState extends State<ResultsListPage> {
  late Future<List<SkinResult>> _future;

  @override
  void initState() {
    super.initState();
    _future = DatabaseHelper.instance.getAllResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sonuçlarım',style: TextStyle(color: Colors.white),), backgroundColor: Colors.blue
      ,leading: InkWell(
        onTap: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ImagePickerPage()));
        },
        child: Icon(Icons.arrow_back_ios_new,color: Colors.white,)),),
      body: FutureBuilder<List<SkinResult>>(
        future: _future,
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator(
            color: Colors.blue,
          ));
          final list = snap.data!;
          if (list.isEmpty) return const Center(child: Text('Henüz sonuç yok.'));
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final r = list[i];
              return ListTile(
                leading: Image.file(File(r.imagePath), width: 50, fit: BoxFit.cover),
                title: Text(r.label),
                subtitle: Text('Güven: %${r.confidence.toStringAsFixed(2)}'),
                trailing: Text(r.timestamp.split('T').first),
              );
            },
          );
        },
      ),
    );
  }
}
