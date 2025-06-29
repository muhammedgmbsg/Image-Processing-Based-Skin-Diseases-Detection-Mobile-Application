import 'package:flutter/material.dart';
import 'package:skindetectionflask/imagePicker.dart';
import 'package:skindetectionflask/main.dart';

/// 1) ÜÇ SAYFALIK ONBOARDING EKRANI
class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  final List<String> images = [
    'assets/logo1.png',
    'assets/logo2.png',
    'assets/logo3.png',
  ];
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(children: [
        PageView.builder(
          controller: _controller,
          itemCount: images.length,
          onPageChanged: (i) => setState(() => _currentPage = i),
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(images[i], height: 280),
                const SizedBox(height: 30),
                Text(
                  _getText(i),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        // Dots
        Positioned(
          bottom: 100, left: 0, right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == i ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == i ? Colors.white : Colors.white54,
                borderRadius: BorderRadius.circular(4),
              ),
            )),
          ),
        ),
        // Başla butonu
        Positioned(
          bottom: 30, left: 80, right: 80,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ImagePickerPage())),
            child: const Text('Başla', style: TextStyle(fontSize: 15, color: Colors.blue)),
          ),
        ),
      ]),
    );
  }

  String _getText(int i) {
    switch (i) {
      case 0:
        return 'Yapay zeka destekli aracımız, cilt sorunlarını hızlıca tanımanıza yardımcı olur.';
      case 1:
        return 'Yalnızca bir fotoğraf yükleyin, sonuçları birkaç saniyede görün.';
      case 2:
        return 'Dermatolog önerileri ve güvenilir bilgilendirmeler ekranınızda.';
      default:
        return '';
    }
  }
}
