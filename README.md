# rudra_officer

A new Flutter project.

## Getting Started

## iOS Firebase Setup

Place the Firebase iOS config file at:

```text
ios/Runner/GoogleService-Info.plist
```
## Pending iOS Upload Steps


After adding the file, make sure it is also included in the Xcode Runner target resources. If `GoogleService-Info.plist` is not referenced in `ios/Runner.xcodeproj/project.pbxproj`, the iOS build may not bundle it.


These steps must be completed on a Mac with Xcode and access to the Apple Developer account:

1. Install CocoaPods dependencies:

```bash
cd ios
pod install
cd ..
```

2. Open the workspace in Xcode:

```text
ios/Runner.xcworkspace
```

Do not open `ios/Runner.xcodeproj` after CocoaPods is installed.

3. In Xcode, select the `Runner` target and configure signing:

- Set the Apple Developer Team.
- Confirm the bundle identifier is `com.pwd.rudraofficer`.
- Enable automatic signing or use the correct provisioning profile.

4. Enable Push Notifications:

- Enable Push Notifications capability in Xcode.
- Enable Push Notifications for the app identifier in Apple Developer.
- Upload the APNs key or certificate in Firebase Console > Project Settings > Cloud Messaging.

5. Build and archive:

```bash
flutter build ios --release
```

Then archive from Xcode and upload to App Store Connect.

6. Before upload, verify on a real iPhone:

- Firebase initializes without crashing.
- FCM token is generated after login.
- Google Maps loads.
- Camera and photo selection permissions show correct prompts.
- Location permission works.
- Pothole detection model loads.
