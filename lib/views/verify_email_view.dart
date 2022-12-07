//Now we will be working on email verification
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as console show log;

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
          const Text('Please verify your email address'),
          // button will send email to verify user when pressed
          TextButton(
              onPressed: () async {
                // Our current user
                final user = FirebaseAuth.instance.currentUser;
                // await and send email verification need async for future dont forget
                await user?.sendEmailVerification();
              },
              child: const Text('Send Email Verification'))
        ],
      ),
    );
  }
}
