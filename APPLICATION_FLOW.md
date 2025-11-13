# Application Flow Verification

## Complete User Flow

### 1. **Login Screen** (Entry Point)
- **Location**: `lib/screens/login_screen.dart`
- **Features**:
  - User can login with **Email** or **Phone Number**
  - Password field with show/hide toggle
  - Automatic detection of email vs phone input
  - Form validation
  - Loading state during authentication
  - Error handling with user feedback

**Validation Rules**:
- Email must contain '@'
- Phone number must contain digits
- Password must be at least 4 characters

**After Successful Login**:
- User is redirected to Dashboard
- Authentication state is saved locally

---

### 2. **Dashboard Screen**
- **Location**: `lib/screens/dashboard_screen.dart`
- **Features**:
  - Welcome section with app branding
  - Three main action cards:
    1. **Start Gesture Recognition** → Opens Camera Screen
    2. **Train Custom Gestures** → Opens Training Screen
    3. **Settings** → Opens Settings Screen
  - Quick tips section
  - Settings icon in app bar
  - Logout option in user menu (account icon)

**Navigation Options**:
- ✅ Open Camera (Gesture Recognition)
- ✅ Open Settings
- ✅ Logout

---

### 3. **Camera Screen (Gesture Recognition)**
- **Location**: `lib/screens/home_screen.dart`
- **Features**:
  - **Camera Preview**: Real-time camera feed
  - **Camera Swap Button**: 
    - Located in top-right corner
    - Switches between front and back cameras
    - Shows appropriate icon (front/back camera)
    - Loading indicator during switch
  - **Real-time Gesture Recognition**:
    - Uses MediaPipe Gesture Recognizer
    - Processes camera frames continuously
    - Detects hand gestures in real-time
  - **Gesture Display Panel**:
    - Shows recognized gesture name
    - Displays confidence score
    - Shows text representation
    - "Speak" button to convert text to speech
  - **Back Button**: Returns to Dashboard
  - **Settings & Training Icons**: Quick access in app bar

**Flow**:
1. User opens camera from dashboard
2. Camera permission is requested (if not granted)
3. Camera starts capturing frames
4. MediaPipe processes frames for gesture recognition
5. Recognized gestures are displayed
6. User can tap "Speak" to hear the text via TTS
7. User can swap cameras using the swap button

---

### 4. **Settings Screen**
- **Location**: `lib/screens/settings_screen.dart`
- **Features**:

  **Accessibility Settings**:
  - High Contrast Mode toggle
  - Text Scale slider (0.8x to 2.0x)

  **Audio Settings**:
  - Sound Enabled toggle
  - Vibration Enabled toggle

  **Speech Settings**:
  - **Language**: Dropdown to select TTS language
  - **Voice**: Dropdown to select TTS voice + Preview button
  - **Speech Rate**: Slider (0.0 to 1.0)
  - **Volume**: Slider (0.0 to 1.0)
  - **Pitch**: Slider (0.5 to 2.0) with labels

**All settings are persisted** using SharedPreferences.

---

## Complete Flow Diagram

```
┌─────────────────┐
│   Login Screen  │
│  (Email/Phone)  │
└────────┬────────┘
         │
         │ (Authenticate)
         ▼
┌─────────────────┐
│  Dashboard      │
│  - Camera       │
│  - Settings     │
│  - Training     │
└────┬───────┬────┘
     │       │
     │       └─────────────┐
     │                     │
     ▼                     ▼
┌─────────────┐    ┌──────────────┐
│   Camera    │    │   Settings   │
│   Screen    │    │   Screen     │
│             │    │              │
│ - Swap      │    │ - Voice      │
│ - Recognize │    │ - Pitch      │
│ - TTS       │    │ - Language   │
└─────────────┘    └──────────────┘
```

---

## Technical Implementation

### Authentication
- **Provider**: `lib/providers/auth_provider.dart`
- **Storage**: SharedPreferences
- **State**: Persists across app restarts

### Camera & Gesture Recognition
- **Camera**: `lib/widgets/camera_view.dart`
- **Gesture Recognition**: `lib/services/gesture_recognition_service.dart`
- **MediaPipe Integration**: `lib/services/mediapipe_gesture_service.dart`
- **Model**: `assets/models/gesture_recognizer.task`

### Text-to-Speech
- **TTS Service**: `lib/services/tts_service.dart`
- **TTS Provider**: `lib/providers/tts_provider.dart`
- **Features**: Voice selection, pitch, rate, volume control

### Settings
- **Settings Provider**: `lib/providers/settings_provider.dart`
- **Persistence**: SharedPreferences
- **Accessibility**: High contrast, text scaling

---

## Verification Checklist

### ✅ Login Flow
- [x] Login screen appears on app start
- [x] Email/Phone input with auto-detection
- [x] Password field with show/hide
- [x] Form validation
- [x] Authentication state management
- [x] Redirect to dashboard after login

### ✅ Dashboard Flow
- [x] Dashboard appears after login
- [x] "Start Gesture Recognition" card → Opens Camera
- [x] "Settings" card → Opens Settings
- [x] Settings icon in app bar
- [x] Logout option available

### ✅ Camera Flow
- [x] Camera opens from dashboard
- [x] Camera permission handling
- [x] Camera swap button (front/back)
- [x] Real-time gesture recognition
- [x] Gesture display with confidence
- [x] Text representation display
- [x] TTS "Speak" button
- [x] Back button to dashboard

### ✅ Settings Flow
- [x] Settings accessible from dashboard
- [x] Voice selection dropdown
- [x] Voice preview button
- [x] Pitch control slider (0.5-2.0)
- [x] Speech rate control
- [x] Volume control
- [x] Language selection
- [x] Accessibility options
- [x] Settings persistence

### ✅ Gesture Recognition Flow
- [x] MediaPipe model integration
- [x] Real-time frame processing
- [x] Hand detection
- [x] Gesture classification
- [x] Confidence scoring
- [x] Gesture-to-text mapping
- [x] TTS output

---

## User Journey Example

1. **User opens app** → Login screen appears
2. **User enters email/phone + password** → Clicks "Sign In"
3. **Authentication succeeds** → Dashboard appears
4. **User clicks "Start Gesture Recognition"** → Camera screen opens
5. **Camera permission granted** → Camera starts
6. **User shows hand gesture** → Gesture recognized
7. **Text appears** → "Yes" (for thumbs up)
8. **User clicks "Speak"** → TTS speaks "Yes"
9. **User clicks swap button** → Camera switches to front/back
10. **User clicks back** → Returns to dashboard
11. **User clicks "Settings"** → Settings screen opens
12. **User selects voice** → Voice dropdown shows available voices
13. **User adjusts pitch** → Slider changes pitch (0.5-2.0)
14. **User clicks "Preview Voice"** → Hears voice preview
15. **User clicks back** → Returns to dashboard
16. **User clicks account icon** → Logout menu appears
17. **User clicks "Logout"** → Returns to login screen

---

## Files Summary

### Screens
- `lib/screens/login_screen.dart` - Login with email/phone
- `lib/screens/dashboard_screen.dart` - Main dashboard
- `lib/screens/home_screen.dart` - Camera & gesture recognition
- `lib/screens/settings_screen.dart` - Settings & preferences
- `lib/screens/training_screen.dart` - Custom gesture training

### Providers
- `lib/providers/auth_provider.dart` - Authentication state
- `lib/providers/gesture_provider.dart` - Gesture recognition state
- `lib/providers/tts_provider.dart` - TTS state
- `lib/providers/settings_provider.dart` - App settings

### Services
- `lib/services/mediapipe_gesture_service.dart` - MediaPipe integration
- `lib/services/gesture_recognition_service.dart` - Gesture recognition
- `lib/services/tts_service.dart` - Text-to-speech
- `lib/services/gesture_mapping_service.dart` - Gesture-to-text mapping

### Widgets
- `lib/widgets/camera_view.dart` - Camera preview with swap
- `lib/widgets/gesture_display.dart` - Gesture results display

---

## Status: ✅ Complete

All features are implemented and the flow matches the requirements:
- ✅ Login with email/phone and password
- ✅ Dashboard with camera and settings options
- ✅ Camera screen with swap functionality
- ✅ Real-time gesture recognition
- ✅ Text conversion and TTS output
- ✅ Settings with voice selection and pitch control

