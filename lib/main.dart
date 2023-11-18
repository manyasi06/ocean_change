import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Sets up firebase, firestore, and widget capabilities

void main() async {
  // Connect widgets to Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file for firestore emulator
  await  dotenv.load(fileName: ".env");

  // Initialize firebase app instance
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Determines whether to use firestore emulator based on .env file
  if (dotenv.env['LOCAL_FIRESTORE'] == "true") {
   try {
     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080,sslEnabled: false);
     
     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099); 
     FirebaseAuth.instance.setSettings( appVerificationDisabledForTesting: true, forceRecaptchaFlow: true);
       } catch (e) {
     // ignore: avoid_print
     print(e);
   }
 }

  // Run the app
  runApp(const App());
}
