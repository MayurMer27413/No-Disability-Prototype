class GestureResult {
  final String gestureName;
  final double confidence;
  final String textRepresentation;
  final DateTime timestamp;

  GestureResult({
    required this.gestureName,
    required this.confidence,
    required this.textRepresentation,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'GestureResult(name: $gestureName, confidence: ${confidence.toStringAsFixed(2)}, text: $textRepresentation)';
  }
}

