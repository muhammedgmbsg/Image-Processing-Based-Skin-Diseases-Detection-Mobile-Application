import 'package:flutter/material.dart';
import 'package:skindetectionflask/components/drawer.dart';
import 'package:skindetectionflask/imagePicker.dart';
import 'package:skindetectionflask/main.dart';

class ResultPage extends StatelessWidget {
  final String label;
  final double confidence;
  const ResultPage({required this.label, required this.confidence});

  // ➤ Her hastalık için bilgilendirici metinler
  String getAdvice(String label) {
    switch (label) {
      case 'Eczema':
        return 'Egzama (Dermatit), derinin kaşınma, kızarıklık ve kabuklanma ile seyreden kronik bir durumdur. '
               'Genellikle cilt bariyerini güçlendiren nemlendiriciler ve topikal tedaviler önerilir. '
               'Stres, sıcak-soğuk gibi tetikleyicilere dikkat edin.';
      case 'Warts Molluscum and other Viral Infections':
        return 'Siğiller ve Molluscum contagiosum gibi viral enfeksiyonlar, ciltte kabarık ve kaşıntılı lezyonlara yol açar. '
               'Bağışıklığını güçlendiren tedaviler ve lokal kriyoterapi önerilir.';
      case 'Melanoma':
        return 'Melanom, cilt kanserleri arasında en agresif türdür ve derhal dermatolog kontrolü gerektirir. '
               'Asimetrik lezyonlar, renk değişimi veya hızlı büyüme var ise acil müdahale şarttır.';
      case 'Atopic Dermatitis':
        return 'Atopik dermatit, çocuklukta başlayan kronik kaşıntılı bir cilt hastalığıdır. '
               'Bol nemlendirici, yatıştırıcı banyolar ve gerektiğinde kortikosteroidli kremler kullanılabilir.';
      case 'Basal Cell Carcinoma (BCC)':
        return 'Bazal hücreli karsinom, cilt kanserleri arasında en yaygın ve genellikle yavaş ilerleyen bir türdür. '
               'Cerrahi eksizyon, kriyoterapi veya topikal tedavi seçenekleri ile başarıyla tedavi edilebilir.';
      case 'Melanocytic Nevi (NV)':
        return 'Melanositik nevüsler (benler) genellikle zararsızdır. '
               'Fakat boyut, renk veya şekil değişikliği fark ederseniz dermatoloğa başvurun.';
      case 'Benign Keratosis-like Lesions (BKL)':
        return 'Benign keratoz benzeri lezyonlar; genellikle yaşlılarda görülen, pürüzlü, iyi huylu deri büyümeleridir. '
               'Estetik amaçlı kriyoterapi veya lazer ile alınabilir.';
      case 'Psoriasis pictures Lichen Planus and related diseases':
        return 'Sedef hastalığı (psoriasis) ve liken planus gibi hastalıklar, kronik inflamatuvar lezyonlara yol açar. '
               'Topikal tedaviler, fototerapi veya sistemik ilaçlar gerekebilir.';
      case 'Seborrheic Keratoses and other Benign Tumors':
        return 'Seboreik keratoz, iyi huylu, genellikle orta yaş üzeri kişilerde görülen lezyonlardır. '
               'Estetik veya kaşıntı sorununda kriyoterapi ile çıkarılabilir.';
      case 'Tinea Ringworm Candidiasis and other Fungal Infections':
        return 'Tinea veya kandidiyazis gibi mantar enfeksiyonları; kaşıntılı, halkasal kızarıklıklar yapar. '
               'Antifungal kremler ve hijyen önlemleri uygulayın.';
      default:
        return 'Bu hastalık hakkında ayrıntılı bilgi almak için bir dermatoloğa danışın.';
    }
  }

  // ➤ Her hastalık için risk düzeyine göre renk seçimi
  Color getRiskColor(String label) {
    switch (label) {
      case 'Melanoma':
        return Colors.redAccent;          // Yüksek risk
      case 'Basal Cell Carcinoma (BCC)':
        return Colors.orangeAccent;       // Orta-yüksek risk
      case 'Seborrheic Keratoses and other Benign Tumors':
      case 'Melanocytic Nevi (NV)':
      case 'Benign Keratosis-like Lesions (BKL)':
        return Colors.green;              // Düşük risk
      default:
        return Colors.blueAccent;         // Orta risk / normal
    }
  }

  @override
  Widget build(BuildContext context) {
    final advice = getAdvice(label);
    final riskColor = getRiskColor(label);

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Sonuç',style: TextStyle(color: Colors.white),), backgroundColor: Colors.blue),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.health_and_safety, size: 60, color: Colors.white),
            const SizedBox(height: 12),
            Text(label,
                style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Güven: %${confidence.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, color: Colors.white70)),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: riskColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    advice,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh, color: Colors.blue),
              label: const Text('Yeni Resim Seç', style: TextStyle(color: Colors.blue)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ImagePickerPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
