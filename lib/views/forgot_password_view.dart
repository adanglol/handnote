// this is where our view will be to user for forgot password view

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_in_need/services/auth/bloc/auth_bloc.dart';
import 'package:hand_in_need/services/auth/bloc/auth_event.dart';
import 'package:hand_in_need/services/auth/bloc/auth_state.dart';
import 'package:hand_in_need/utilities/dialogs/error_dialouge.dart';
import 'package:hand_in_need/utilities/dialogs/password_reset_email_sent_dialouge.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  // need add text editing controller for user to enter there email so that a reset password can happen
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  // need return bloc listener to listen to our events and variables to display dialouge like if sentemail correct then we should clear text and display dialouge

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        // logic handling forgot password
        // if state is forgot password
        if (state is AuthStateForgotPassword) {
          // checking if email been sent
          if (state.hasSendEmail) {
            // clear view
            _email.clear();
            // send dialouge
            await showPasswordResetSendDialouge(context);
          }
          // if there is exception display it
          if (state.exception != null) {
            await showErrorDialouge(context,
                'We could not process your request please make sure you are a registered user');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Forgot password')),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                    'If you forgot your password no worries. Just enter your email below and we will send a email to reset your password'),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autofocus: true,
                  decoration:
                      const InputDecoration(hintText: 'Your email address...'),
                ),
                TextButton(
                  onPressed: () {
                    // where when we press button go to our auth bloc and pass forgot email and pass controller text
                    final email = _email.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthEventForgotPassword(email: email));
                  },
                  child: const Text('Send Password Reset Link'),
                ),
                // Textbutton to take our user to login screen after resetting email
                TextButton(
                    onPressed: () {
                      // send user back to login view of our application so that they can login upoun reset their password
                      context.read<AuthBloc>().add(const AuthEventLogout());
                    },
                    child: const Text('Back to Login')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
