//Now we will be working on email verification
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as console show log;

import 'package:hand_in_need/constants/routes.dart';
import 'package:hand_in_need/services/auth/auth_service.dart';
import 'package:hand_in_need/services/auth/bloc/auth_bloc.dart';
import 'package:hand_in_need/services/auth/bloc/auth_event.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
                "We've sent an email verification. Please open in order to verify your account"),
            const Text(
                "If you have not recieved an email verification yet press the button below to do so!"),
            // button will send email to verify user when pressed
            TextButton(
                onPressed: () {
                  //  send email verification - an event that comes from our Auth Bloc
                  context
                      .read<AuthBloc>()
                      .add(const AuthEventSendEmailVerification());
                },
                child: const Text('Send Email Verification')),
            // restart button
            TextButton(
              onPressed: () {
                // log us out - event come from Auth Bloc
                context.read<AuthBloc>().add(const AuthEventLogout());
              },
              child: const Center(
                child: Text('Restart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
