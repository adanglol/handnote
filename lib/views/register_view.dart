// This is our register view for our app

//create a stateless widget
//shortcut to know press stl and enter in VS code

//in flutter just create a shit ton of widgets everything in itself is a widget
//converted to a stateful widget

//Left off at 8:59:48 topics that were covered
//Future builder using ctrl . and ctrl space shortcut
//initialize app for firebase
//widgets

//keep follow video then practive and understand !
//IMPORTANT PLEASE READ
// We are going to be creating a register view and login view for our app
// we are going to need statful widget for each one
// stf is shortcut for creating a stateful widget within flutter
// stl is shortcut for stateless widget in flutter

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_in_need/services/auth/auth_exceptions.dart';
import 'package:hand_in_need/services/auth/auth_service.dart';
import 'package:hand_in_need/services/auth/bloc/auth_bloc.dart';
import 'package:hand_in_need/services/auth/bloc/auth_event.dart';
import 'package:hand_in_need/services/auth/bloc/auth_state.dart';
import 'package:hand_in_need/utilities/dialogs/error_dialouge.dart';
import 'dart:developer' as console show log;
import '../constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // create proxy to update information for our button to get
  // late is keyword tells program variable with no value will assign value before use
  // This is setting up our two text fields for user input
  late final TextEditingController _email;
  late final TextEditingController _password;

  //when app is creatd set our intances in init for our HomePage which now stateful widget
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

//dispose of them when done
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        // registration exceptions
        // --------------------------------
        // check if registering
        if (state is AuthStateRegistering) {
          // weak password
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialouge(context,
                'Your password appears to be weak please enter a more secure password!');
            // email in use
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialouge(context,
                'It appears this email is already in use try another email or login');
            // invalid email
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialouge(
                context, 'Email given is invalid please try another email');
            // generic register exception
          } else if (state.exception is GenericAuthException) {
            await showErrorDialouge(context, 'Failed to register');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Register')),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: (Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Enter your email and password to begin creating notes'),
              //grab these text fields when we click out button
              //add hint to text field hint user what to input
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                autofocus: true,
                //need make it specify email keyboard with @
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email here',
                ),
              ),

              //Password TextField Box to input pw
              TextField(
                //need to make pw field secure
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Enter your password here',
                ),
              ),
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        // upoun pressing will get email and password from user
                        final email = _email
                            .text; //.text concatenate as string its method
                        final password = _password.text;
                        // use bloc to sign up
                        context.read<AuthBloc>().add(AuthEventRegister(
                              email: email,
                              password: password,
                            ));
                      },
                      child: const Text('Sign up'),
                    ),
                    // Create a already registered login here button that takes to the login view
                    TextButton(
                        onPressed: () {
                          // bloc to login logout event so it can take us to login
                          context.read<AuthBloc>().add(const AuthEventLogout());
                        },
                        child: const Text('Already Registered? Login Here!')),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
//IMPORTANT
//If we want to rename symbol right click then choose rename symbol option
//or click on word and press f2 on keyboard
// good to have file structure
// going to have LoginView in its on dedicated file to do so New File type entire path
