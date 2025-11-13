import 'package:flutter/material.dart';
import '../widgets/camera_view.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final TextEditingController _gestureNameController = TextEditingController();
  final TextEditingController _textMappingController = TextEditingController();
  bool _isRecording = false;
  int _samplesRecorded = 0;
  static const int _requiredSamples = 50;

  @override
  void dispose() {
    _gestureNameController.dispose();
    _textMappingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Train Custom Gesture'),
      ),
      body: Column(
        children: [
          // Camera Preview
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const CameraView(),
              ),
            ),
          ),
          
          // Training Form
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _gestureNameController,
                    decoration: const InputDecoration(
                      labelText: 'Gesture Name',
                      hintText: 'e.g., my_custom_gesture',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: _textMappingController,
                    decoration: const InputDecoration(
                      labelText: 'Text Representation',
                      hintText: 'e.g., Hello World',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Recording Status
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isRecording ? Colors.red[50] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _isRecording ? 'Recording...' : 'Ready to Record',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _isRecording ? Colors.red[700] : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: _samplesRecorded / _requiredSamples,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _isRecording ? Colors.red : Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Samples: $_samplesRecorded / $_requiredSamples',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Record Button
                  ElevatedButton.icon(
                    onPressed: _canRecord() ? _toggleRecording : null,
                    icon: Icon(_isRecording ? Icons.stop : Icons.fiber_manual_record),
                    label: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: _isRecording ? Colors.red : Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Save Button
                  ElevatedButton.icon(
                    onPressed: _canSave() ? _saveGesture : null,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Gesture'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canRecord() {
    return _gestureNameController.text.isNotEmpty &&
           _textMappingController.text.isNotEmpty;
  }

  bool _canSave() {
    return _samplesRecorded >= _requiredSamples &&
           _gestureNameController.text.isNotEmpty &&
           _textMappingController.text.isNotEmpty;
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        _startRecording();
      } else {
        _stopRecording();
      }
    });
  }

  void _startRecording() {
    // Start collecting gesture samples
    // In production, this would capture frames and store them for training
    _samplesRecorded = 0;
    _simulateRecording();
  }

  void _stopRecording() {
    // Stop collecting samples
  }

  void _simulateRecording() {
    if (!_isRecording) return;
    
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_isRecording && mounted) {
        setState(() {
          _samplesRecorded++;
        });
        if (_samplesRecorded < _requiredSamples) {
          _simulateRecording();
        } else {
          setState(() {
            _isRecording = false;
          });
        }
      }
    });
  }

  void _saveGesture() {
    // Save the trained gesture
    // In production, this would:
    // 1. Train the model with collected samples
    // 2. Update gesture mapping
    // 3. Save to local storage
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Gesture "${_gestureNameController.text}" saved successfully!',
        ),
        backgroundColor: Colors.green,
      ),
    );
    
    // Reset form
    _gestureNameController.clear();
    _textMappingController.clear();
    setState(() {
      _samplesRecorded = 0;
      _isRecording = false;
    });
  }
}

