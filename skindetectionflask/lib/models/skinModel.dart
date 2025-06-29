class SkinResult {
  final int? id;
  final String imagePath, label, timestamp;
  final double confidence;

  SkinResult({this.id, required this.imagePath, required this.label, required this.confidence, required this.timestamp});

  Map<String, dynamic> toMap() => {
        'id': id,
        'imagePath': imagePath,
        'label': label,
        'confidence': confidence,
        'timestamp': timestamp,
      };

  factory SkinResult.fromMap(Map<String, dynamic> m) => SkinResult(
        id: m['id'],
        imagePath: m['imagePath'],
        label: m['label'],
        confidence: m['confidence'],
        timestamp: m['timestamp'],
      );
}