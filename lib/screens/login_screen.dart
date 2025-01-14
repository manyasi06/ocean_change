import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:ocean_change/screens/create_account_screen.dart';
import 'package:ocean_change/screens/password_reset_screen.dart';
import '../models/user_data.dart';
import '../widgets/login/show_login_error.dart';
import '../widgets/login/google_sign_in_button.dart';

// Login screen for users using google sign in for android and firebase auth
// for other sign in methods

class LoginScreen extends StatefulWidget {
  static const String routeName = 'LoginScreen';
  const LoginScreen({super.key});

  @override
  // Creates the mutable state for this widget at a given location in the tree
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  UserData userData = UserData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ocean Change')),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // Shows Google sign in button for Android
              Platform.isAndroid ? const GoogleSignInButton() : Container(),
              Padding(
                // Text for sign in based on platform
                  padding: const EdgeInsets.fromLTRB(0, 24, 0, 6),
                  child: Platform.isAndroid
                      ? const Text("Or sign in with email and password.")
                      : const Text('Sign in with email and password.')),
              TextFormField(
                // Saves entered email into userData.email
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a username";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    userData.email = value!;
                  }),
              TextFormField(
                // Saves entered password into userData.password
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a password";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    userData.password = value!;
                  }),
              Padding(
                // SignIn Button
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(400, 75)
                      ),
                      onPressed: _emailSignIn,
                      child: const Text("Sign In",
                          style:
                          TextStyle(fontSize:30, fontWeight: FontWeight.bold)
                      )
                  ),
              ),
              ElevatedButton(
                //Forgot Password Button
                  onPressed: () => Navigator.pushNamed(
                      context, PasswordResetScreen.routeName),
                  child: const Text("Forgot Password?")
              ),
              const Spacer(),
              Padding(
                // Create User Text
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 10),
                  child: Platform.isAndroid
                      ? const Text("New user who can't sign in with a Google account?",
                      style: TextStyle(fontSize: 15))
                      : Container()
              ),
              Padding(
                // Create Account Button
                  padding: const EdgeInsets.only(bottom: 50),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 75)),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, CreateAccountScreen.routeName);
                        },
                      child: const Text("Create Account",
                          style:
                          TextStyle(fontSize:20, fontWeight: FontWeight.bold))
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _emailSignIn() async {
    var logger = Logger();
    // checks if formKey fields above are filled in
    if (formKey.currentState!.validate()) {
      // saves formKey fields
      formKey.currentState!.save();
      try {
        // connects to firestore users
        var userDocs = FirebaseFirestore.instance
            .collection("users")
            // .where("email", isEqualTo: userData.email.trim())
            .get(const GetOptions(source: Source.server));

        var found = false;

        // matches email to firestore users
        await userDocs.then((QuerySnapshot value){
          if (value.size == 0){
            const Text("User not found");
            return;
          }else {
            for (var element in value.docs) {
              Text(element.get("email"));
              if (element.get("email") == userData.email) {
                found = true;
              }
            }
          }
        }, onError: (e) => print("Error Completeing getting the user"));
        print("\nThis is found $found");
        if(!found){
          throw Exception('User not registered for app');
        }

        // attempts login with FirebaseAuth

        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: userData.email!, password: userData.password!);
      } on FirebaseAuthException catch (e) {
        showFireBaseAuthError(context, e.message!);
      } on Exception catch (e2){
        // ignore: use_build_context_synchronously
        showFireBaseAuthError(context, "User not registered for app");
      }
    }
  }
}
