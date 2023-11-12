import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await  dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
  runApp(const App());
}
