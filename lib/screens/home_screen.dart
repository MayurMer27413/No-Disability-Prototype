import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers/gesture_provider.dart';
import '../providers/tts_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/camera_view.dart';
import '../widgets/gesture_display.dart';
import '../screens/settings_screen.dart';
import '../screens/training_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasPermission = false;
  bool _isRequestingPermission = false;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermission();
  }

  Future<void> _checkAndRequestPermission() async {
    setState(() {
      _isRequestingPermission = true;
    });

    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        _hasPermission = true;
        _isRequestingPermission = false;
      });
      _initializeServices();
    } else {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        setState(() {
          _hasPermission = true;
          _isRequestingPermission = false;
        });
        _initializeServices();
      } else {
        setState(() {
          _hasPermission = false;
          _isRequestingPermission = false;
        });
      }
    }
  }

  Future<void> _initializeServices() async {
    final gestureProvider = Provider.of<GestureProvider>(context, listen: false);
    final ttsProvider = Provider.of<TTSProvider>(context, listen: false);
    
    await Future.wait([
      gestureProvider.initialize(),
      ttsProvider.initialize(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gesture Recognition'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.school),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TrainingScreen()),
              );
            },
          ),
        ],
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(settingsProvider.textScale),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: settingsProvider.highContrast
                ? Colors.black
                : Theme.of(context).scaffoldBackgroundColor,
          ),
          child: _buildBody(settingsProvider),
        ),
      ),
    );
  }

  Widget _buildBody(SettingsProvider settingsProvider) {
    if (_isRequestingPermission) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Requesting camera permission...'),
          ],
        ),
      );
    }

    if (!_hasPermission) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 64,
                color: settingsProvider.highContrast
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
              const SizedBox(height: 24),
              Text(
                'Camera Permission Required',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: settingsProvider.highContrast
                      ? Colors.white
                      : Colors.grey[900],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Please grant camera permission to use gesture recognition',
                style: TextStyle(
                  fontSize: 16,
                  color: settingsProvider.highContrast
                      ? Colors.grey[300]
                      : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _checkAndRequestPermission,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Grant Permission'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Camera View
        Expanded(
          flex: 2,
          child: CameraView(),
        ),
        
        // Gesture Display
        Expanded(
          flex: 1,
          child: GestureDisplay(),
        ),
      ],
    );
  }
}

