import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupies/auth/authentication.dart';
import 'package:groupies/home/home_page.dart';
import 'package:groupies/main.dart';



class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          // User is logged in
          return HomePage();
        } else {
          // User is NOT logged in
          return AuthenticationPage();
        }
      },
    );
  }
}