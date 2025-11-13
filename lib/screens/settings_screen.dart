import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/tts_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final ttsProvider = Provider.of<TTSProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Accessibility Settings
          _buildSectionHeader('Accessibility'),
          
          SwitchListTile(
            title: const Text('High Contrast Mode'),
            subtitle: const Text('Improves visibility for visual impairments'),
            value: settingsProvider.highContrast,
            onChanged: (value) {
              settingsProvider.setHighContrast(value);
            },
          ),
          
          ListTile(
            title: const Text('Text Scale'),
            subtitle: Slider(
              value: settingsProvider.textScale,
              min: 0.8,
              max: 2.0,
              divisions: 12,
              label: settingsProvider.textScale.toStringAsFixed(1),
              onChanged: (value) {
                settingsProvider.setTextScale(value);
              },
            ),
          ),
          
          const Divider(),
          
          // Audio Settings
          _buildSectionHeader('Audio'),
          
          SwitchListTile(
            title: const Text('Sound Enabled'),
            value: settingsProvider.soundEnabled,
            onChanged: (value) {
              settingsProvider.setSoundEnabled(value);
            },
          ),
          
          SwitchListTile(
            title: const Text('Vibration Enabled'),
            value: settingsProvider.vibrationEnabled,
            onChanged: (value) {
              settingsProvider.setVibrationEnabled(value);
            },
          ),
          
          const Divider(),
          
          // Speech Settings
          _buildSectionHeader('Speech'),
          
          ListTile(
            title: const Text('Language'),
            subtitle: FutureBuilder<List<dynamic>>(
              future: ttsProvider.getLanguages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('Loading...');
                }
                return DropdownButton<String>(
                  value: settingsProvider.selectedLanguage,
                  isExpanded: true,
                  items: snapshot.data!.map((lang) {
                    return DropdownMenuItem(
                      value: lang.toString(),
                      child: Text(lang.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      settingsProvider.setSelectedLanguage(value);
                      ttsProvider.setLanguage(value);
                    }
                  },
                );
              },
            ),
          ),
          
          ListTile(
            title: const Text('Voice'),
            subtitle: FutureBuilder<List<dynamic>>(
              future: ttsProvider.getVoices(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('Loading voices...');
                }
                
                final voices = snapshot.data!;
                if (voices.isEmpty) {
                  return const Text('No voices available');
                }
                
                // Get current voice name
                final currentVoice = ttsProvider.selectedVoice;
                final currentVoiceName = currentVoice?['name'] ?? 
                    (voices.isNotEmpty && voices[0] is Map 
                        ? (voices[0] as Map)['name']?.toString() 
                        : 'Default');
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: currentVoiceName,
                      isExpanded: true,
                      hint: const Text('Select a voice'),
                      items: voices.map((voice) {
                        if (voice is Map) {
                          final name = voice['name']?.toString() ?? 'Unknown';
                          final locale = voice['locale']?.toString() ?? '';
                          final displayName = '$name ($locale)';
                          return DropdownMenuItem<String>(
                            value: name,
                            child: Text(displayName),
                          );
                        }
                        return DropdownMenuItem<String>(
                          value: voice.toString(),
                          child: Text(voice.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          // Find the voice map with this name
                          final selectedVoiceMap = voices.firstWhere(
                            (voice) => voice is Map && voice['name'] == value,
                            orElse: () => voices.isNotEmpty ? voices[0] : {},
                          );
                          
                          if (selectedVoiceMap is Map) {
                            ttsProvider.setVoice(
                              Map<String, String>.from(
                                selectedVoiceMap.map((key, value) => 
                                  MapEntry(key.toString(), value.toString())
                                )
                              )
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Preview the current voice
                          ttsProvider.speak('Hello, this is a voice preview');
                        },
                        icon: const Icon(Icons.volume_up, size: 18),
                        label: const Text('Preview Voice'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          
          ListTile(
            title: const Text('Speech Rate'),
            subtitle: Slider(
              value: ttsProvider.speechRate,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: ttsProvider.speechRate.toStringAsFixed(1),
              onChanged: (value) {
                ttsProvider.setSpeechRate(value);
              },
            ),
          ),
          
          ListTile(
            title: const Text('Volume'),
            subtitle: Slider(
              value: ttsProvider.volume,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: ttsProvider.volume.toStringAsFixed(1),
              onChanged: (value) {
                ttsProvider.setVolume(value);
              },
            ),
          ),
          
          ListTile(
            title: const Text('Pitch'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Slider(
                  value: ttsProvider.pitch,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  label: ttsProvider.pitch.toStringAsFixed(1),
                  onChanged: (value) {
                    ttsProvider.setPitch(value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lower (0.5)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'Higher (2.0)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


