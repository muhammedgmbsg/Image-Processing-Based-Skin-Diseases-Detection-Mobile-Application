import 'package:flutter/material.dart';
import 'package:skindetectionflask/imagePicker.dart';
import 'package:skindetectionflask/myResultScreen.dart';

/// 5) Uygulama Drawer’ı
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text('Hoşgeldiniz', style: TextStyle(color: Colors.white, fontSize: 24)),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Ana Sayfa'),
          onTap: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ImagePickerPage())),
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Sonuçlarım'),
          onTap: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ResultsListPage())),
        ),
      ]),
    );
  }
} 