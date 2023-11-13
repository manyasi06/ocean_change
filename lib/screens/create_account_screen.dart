import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_data.dart';
import '../widgets/login/show_login_error.dart';

// Create account screen for users

class CreateAccountScreen extends StatefulWidget {
  static const String routeName = 'CreateAccountScreen';
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final formKey = GlobalKey<FormState>();
  UserData userData = UserData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ocean Change')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Center(
                  child: Text("Enter the fields below to create a new account")
              ),
              TextFormField(
                // Email field for account creation
                  key: const Key('email_field'),
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return "Please enter an email";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    userData.email = value!;
                  }
              ),
              TextFormField(
                // Password field for account creation
                  key: const Key('password_field'),
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (value) {
                    // Checks for password complexity
                    RegExp check = RegExp(r'^(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])(?=.*[a-z])(?=.*[A-Z]).{8,}$');
                    if (value!.isEmpty) {
                      return "Please enter a password";
                    } 
                    else if (check.hasMatch(value) == false) {
                      return "Password Requirements:\n"
                             "- Must be at least 8 characters long\n"
                             "- Must contain uppercase and lowercase letters\n"
                             "- Must contain at least one digit (0-9)\n"
                             "- Must contain at least one special character [ !@#\$%^&*(),.?\":{}|<> ]";
                    }
                    else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    userData.password = value!;
                  }),
              ElevatedButton(
                // Button to start account creation
                  onPressed: _createAccount,
                  child: const Text("Create Account")
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _createAccount() async {
    // checks if formKey fields above are filled in
    if (formKey.currentState!.validate()) {
      // saves formKey fields
      formKey.currentState!.save();
      try {
        // attempts to create a new user with FirebaseAuth
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: userData.email.toString().trim(), password: userData.password!);
            FirebaseFirestore.instance.collection("users").add({
          'admin': userData.adminStatus, //default is false on creation
          'email': userData.email,
        });
      } on FirebaseAuthException catch (e) {
        if(e.code == 'email-already-in-use'){
          showFireBaseAuthError(context, "This account has been deactivated");
        }else{
          showFireBaseAuthError(context, e.message!);
        }
        
      }
    }
  }
}
