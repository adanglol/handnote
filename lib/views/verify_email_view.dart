//Now we will be working on email verification
import 'package:flutter/material.dart';
import 'dart:developer' as console show log;

import 'package:hand_in_need/constants/routes.dart';
import 'package:hand_in_need/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    //give scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text(
              "We've sent an email verification. Please open in order to verify your account"),
          const Text(
              "If you have not recieved an email verification yet press the button below to do so!"),
          // button will send email to verify user when pressed
          TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text('Send Email Verification')),
          // restart button
          TextButton(
            onPressed: () async {
              // Signing out our user when they click restart button
              await AuthService.firebase().logOut();
              // Take our user to register page
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Center(
              child: Text('Restart'),
            ),
          ),
        ],
      ),
    );
  }
}
