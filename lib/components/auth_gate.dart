import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../pages/user/account.dart';
import '../pages/user/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: appData.firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          }
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, authSnapshot) {
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (FirebaseAuth.instance.currentUser != null &&
                  FirebaseAuth.instance.currentUser!.displayName != null) {
                return const AccountPage();
              }
              return const LoginPage();
            },
          );
        });
  }
}
