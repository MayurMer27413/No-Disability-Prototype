package com.gesturetospeech.app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    // MediaPipe removed; no native channels needed

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // No-op: Flutter handles inference entirely in Dart now
    }

    override fun onDestroy() {
        super.onDestroy()
        // No native resources to close
    }
}

