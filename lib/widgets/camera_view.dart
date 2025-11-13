import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../providers/gesture_provider.dart';
import 'package:image/image.dart' as img;

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  int _currentCameraIndex = 0;
  bool _isSwitchingCamera = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        return;
      }

      // Find back camera first, or use first available camera
      _currentCameraIndex = _findCameraIndex(CameraLensDirection.back) ?? 0;

      await _initializeCameraController();
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _initializeCameraController() async {
    if (_cameras == null || _cameras!.isEmpty) return;

    try {
      // Dispose previous controller if exists
      await _controller?.dispose();

      _controller = CameraController(
        _cameras![_currentCameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      
      // Start image stream for real-time processing
      _controller!.startImageStream(_processCameraImage);
      
      setState(() {
        _isInitialized = true;
        _isSwitchingCamera = false;
      });
    } catch (e) {
      debugPrint('Error initializing camera controller: $e');
      setState(() {
        _isSwitchingCamera = false;
      });
    }
  }

  int? _findCameraIndex(CameraLensDirection direction) {
    if (_cameras == null) return null;
    for (int i = 0; i < _cameras!.length; i++) {
      if (_cameras![i].lensDirection == direction) {
        return i;
      }
    }
    return null;
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2 || _isSwitchingCamera) {
      return;
    }

    setState(() {
      _isSwitchingCamera = true;
      _isInitialized = false;
    });

    try {
      // Stop image stream
      await _controller?.stopImageStream();
      
      // Determine target camera direction
      final currentDirection = _currentCameraDirection;
      final targetDirection = currentDirection == CameraLensDirection.back
          ? CameraLensDirection.front
          : CameraLensDirection.back;
      
      // Find camera with target direction
      final targetIndex = _findCameraIndex(targetDirection);
      
      if (targetIndex != null) {
        _currentCameraIndex = targetIndex;
      } else {
        // If target direction not found, just switch to next available camera
        _currentCameraIndex = (_currentCameraIndex + 1) % _cameras!.length;
      }

      // Reinitialize with new camera
      await _initializeCameraController();
    } catch (e) {
      debugPrint('Error switching camera: $e');
      setState(() {
        _isSwitchingCamera = false;
      });
    }
  }

  CameraLensDirection get _currentCameraDirection {
    if (_cameras == null || _currentCameraIndex >= _cameras!.length) {
      return CameraLensDirection.back;
    }
    return _cameras![_currentCameraIndex].lensDirection;
  }

  bool get _canSwitchCamera {
    return _cameras != null && _cameras!.length > 1 && !_isSwitchingCamera;
  }

  void _processCameraImage(CameraImage image) {
    if (!_isInitialized) return;

    final gestureProvider = Provider.of<GestureProvider>(context, listen: false);
    
    final modelImage = _convertCameraImageToModelImage(image);
    if (modelImage != null) {
      gestureProvider.processFrame(modelImage);
    }
  }

  img.Image? _convertCameraImageToModelImage(CameraImage camImage) {
    final int width = camImage.width;
    final int height = camImage.height;

    if (camImage.format.group != ImageFormatGroup.yuv420) {
      debugPrint('Unsupported camera image format: ${camImage.format.group}');
      return null;
    }

    final yPlane = camImage.planes[0];
    final uPlane = camImage.planes[1];
    final vPlane = camImage.planes[2];

    final int uvRowStride = uPlane.bytesPerRow;
    final int uvPixelStride = uPlane.bytesPerPixel ?? 1;

    final rgbImage = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      final int yRowOffset = y * yPlane.bytesPerRow;
      final int uvRowOffset = (y ~/ 2) * uvRowStride;

      for (int x = 0; x < width; x++) {
        final int yIndex = yRowOffset + x;
        final int uvIndex = uvRowOffset + (x ~/ 2) * uvPixelStride;

        final int yValue = yPlane.bytes[yIndex];
        final int uValue = uPlane.bytes[uvIndex];
        final int vValue = vPlane.bytes[uvIndex];

        final double yf = yValue.toDouble();
        final double uf = uValue.toDouble() - 128.0;
        final double vf = vValue.toDouble() - 128.0;

        int r = (yf + 1.403 * vf).round();
        int g = (yf - 0.344 * uf - 0.714 * vf).round();
        int b = (yf + 1.770 * uf).round();

        if (r < 0) r = 0; if (r > 255) r = 255;
        if (g < 0) g = 0; if (g > 255) g = 255;
        if (b < 0) b = 0; if (b > 255) b = 255;

        rgbImage.setPixelRgb(x, y, r, g, b);
      }
    }

    int rotationDegrees = 0;
    if (_controller != null) {
      rotationDegrees = _controller!.description.sensorOrientation;
    }

    img.Image processedImage = rgbImage;

    if (rotationDegrees != 0) {
      processedImage = img.copyRotate(rgbImage, angle: rotationDegrees.toDouble());
    }

    if (_currentCameraDirection == CameraLensDirection.front) {
      processedImage = img.flipHorizontal(processedImage);
    }

    final resized = img.copyResize(
      processedImage,
      width: 64,
      height: 64,
      interpolation: img.Interpolation.average,
    );

    return resized;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        // Camera Preview
        SizedBox.expand(
          child: CameraPreview(_controller!),
        ),
        
        // Overlay for hand detection visualization
        Positioned.fill(
          child: CustomPaint(
            painter: HandLandmarkPainter(),
          ),
        ),
        
        // Camera Switch Button
        if (_canSwitchCamera)
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              onPressed: _isSwitchingCamera ? null : _switchCamera,
              backgroundColor: Colors.black54,
              child: _isSwitchingCamera
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(
                      _currentCameraDirection == CameraLensDirection.back
                          ? Icons.camera_front
                          : Icons.camera_rear,
                      color: Colors.white,
                    ),
              tooltip: _currentCameraDirection == CameraLensDirection.back
                  ? 'Switch to Front Camera'
                  : 'Switch to Back Camera',
            ),
          ),
      ],
    );
  }
}

class HandLandmarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw hand landmarks overlay
    // This would be populated with actual landmarks from MediaPipe
    // Placeholder: Draw sample landmarks
    // In production, this would use actual landmark data
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

