import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ocean_change/screens/email_verification_screen.dart';
import 'package:ocean_change/screens/login_screen.dart';
import 'package:ocean_change/screens/map_screen.dart';

// initial screen in the app that redirects to login or map screen based on login status

class LandingScreen extends StatelessWidget {
  static const String routeName = '/';
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // I believe this prevents black screen from appearing on startup
            Navigator.maybePop(context);
            // if account has been created but email not verified
            if (snapshot.data!.emailVerified == false) {
              return const EmailVerificationScreen();
            }
            // if account is logged in
            else {
              return const MapScreen();
            }
          } else {
            // if account is logged out or no user has been created
            Navigator.maybePop(context);
            return const LoginScreen();
          }
        });
  }
}
