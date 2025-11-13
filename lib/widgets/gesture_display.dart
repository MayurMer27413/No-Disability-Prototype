import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gesture_provider.dart';
import '../providers/tts_provider.dart';
import '../providers/settings_provider.dart';

class GestureDisplay extends StatelessWidget {
  const GestureDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final gestureProvider = Provider.of<GestureProvider>(context);
    final ttsProvider = Provider.of<TTSProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    final gesture = gestureProvider.currentGesture;
    final isProcessing = gestureProvider.isProcessing;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: settingsProvider.highContrast
            ? Colors.grey[900]
            : Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Processing Indicator
          if (isProcessing)
            const CircularProgressIndicator()
          else if (gesture != null) ...[
            // Gesture Name
            Text(
              'Gesture: ${gesture.gestureName}',
              style: TextStyle(
                fontSize: 20 * settingsProvider.textScale,
                fontWeight: FontWeight.bold,
                color: settingsProvider.highContrast
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            
            // Confidence Score
            Text(
              'Confidence: ${(gesture.confidence * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 16 * settingsProvider.textScale,
                color: settingsProvider.highContrast
                    ? Colors.grey[300]
                    : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            
            // Text Representation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: settingsProvider.highContrast
                    ? Colors.grey[800]
                    : Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                gesture.textRepresentation,
                style: TextStyle(
                  fontSize: 24 * settingsProvider.textScale,
                  fontWeight: FontWeight.bold,
                  color: settingsProvider.highContrast
                      ? Colors.white
                      : Colors.blue[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            
            // Speak Button
            ElevatedButton.icon(
              onPressed: ttsProvider.isSpeaking
                  ? null
                  : () {
                      if (settingsProvider.soundEnabled) {
                        ttsProvider.speak(gesture.textRepresentation);
                      }
                    },
              icon: Icon(
                ttsProvider.isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
              ),
              label: Text(
                ttsProvider.isSpeaking ? 'Speaking...' : 'Speak',
                style: TextStyle(
                  fontSize: 18 * settingsProvider.textScale,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                minimumSize: Size(200 * settingsProvider.textScale, 50),
              ),
            ),
          ] else ...[
            // No Gesture Detected
            Icon(
              Icons.back_hand,
              size: 64,
              color: settingsProvider.highContrast
                  ? Colors.grey[600]
                  : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Show a hand gesture to the camera',
              style: TextStyle(
                fontSize: 18 * settingsProvider.textScale,
                color: settingsProvider.highContrast
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

