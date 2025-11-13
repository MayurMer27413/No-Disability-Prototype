import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import 'training_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gesture to Speech'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            tooltip: 'Settings',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) {
              if (value == 'logout') {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                authProvider.logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
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
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome Section
                  _buildWelcomeSection(context, settingsProvider),
                  const SizedBox(height: 32),
                  
                  // Main Action Cards
                  _buildActionCard(
                    context: context,
                    settingsProvider: settingsProvider,
                    title: 'Start Gesture Recognition',
                    description: 'Open camera to recognize hand gestures and convert them to speech',
                    icon: Icons.camera_alt,
                    iconColor: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  _buildActionCard(
                    context: context,
                    settingsProvider: settingsProvider,
                    title: 'Train Custom Gestures',
                    description: 'Teach the app to recognize your own unique hand gestures',
                    icon: Icons.school,
                    iconColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TrainingScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  _buildActionCard(
                    context: context,
                    settingsProvider: settingsProvider,
                    title: 'Settings',
                    description: 'Configure accessibility options, speech settings, and preferences',
                    icon: Icons.settings,
                    iconColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // Quick Info Section
                  _buildQuickInfoSection(context, settingsProvider),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, SettingsProvider settingsProvider) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: settingsProvider.highContrast
              ? [Colors.grey[900]!, Colors.grey[800]!]
              : [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.back_hand,
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 28 * settingsProvider.textScale,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Recognize hand gestures and convert them to speech instantly',
            style: TextStyle(
              fontSize: 16 * settingsProvider.textScale,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required SettingsProvider settingsProvider,
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: settingsProvider.highContrast
                ? Colors.grey[900]
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18 * settingsProvider.textScale,
                        fontWeight: FontWeight.bold,
                        color: settingsProvider.highContrast
                            ? Colors.white
                            : Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14 * settingsProvider.textScale,
                        color: settingsProvider.highContrast
                            ? Colors.grey[400]
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: settingsProvider.highContrast
                    ? Colors.grey[400]
                    : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickInfoSection(BuildContext context, SettingsProvider settingsProvider) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: settingsProvider.highContrast
            ? Colors.grey[900]
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: settingsProvider.highContrast
                    ? Colors.white
                    : Colors.blue[700],
              ),
              const SizedBox(width: 8),
              Text(
                'Quick Tips',
                style: TextStyle(
                  fontSize: 18 * settingsProvider.textScale,
                  fontWeight: FontWeight.bold,
                  color: settingsProvider.highContrast
                      ? Colors.white
                      : Colors.grey[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipItem(
            context,
            settingsProvider,
            Icons.lightbulb_outline,
            'Ensure good lighting for better gesture recognition',
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            context,
            settingsProvider,
            Icons.back_hand,
            'Keep your hand clearly visible in the camera frame',
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            context,
            settingsProvider,
            Icons.volume_up,
            'Use the speak button to hear the recognized text',
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(
    BuildContext context,
    SettingsProvider settingsProvider,
    IconData icon,
    String text,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: settingsProvider.highContrast
              ? Colors.grey[400]
              : Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14 * settingsProvider.textScale,
              color: settingsProvider.highContrast
                  ? Colors.grey[300]
                  : Colors.grey[700],
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

