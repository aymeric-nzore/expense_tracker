import 'package:expense_tracker_app/features/transaction/presentation/main_page.dart';
import 'package:expense_tracker_app/features/onBoarding/presentation/on_boarding_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainPage();
          } else {
            return OnBoardingPage();
          }
        },
      ),
    );
  }
}
