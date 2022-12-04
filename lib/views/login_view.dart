//import state to bring code from other developers and
//we need import our main.dart
//vs code shortcut ctrl . to all errors and import that code

//This is when our users want to login
//Similar implementation to maindart with register view
//comments provided within Main.dart to clarify code and functionality

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return (Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email here',
                    ),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'Enter your password here',
                    ),
                  ),

                  //For our Login view instead of creating instance of user email pw we need to login
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      //Sign in instead of create
                      //when things go wrong - exception
                      //We need to create an exception using try for login of our user
                      try {
                        // try block can be accompanied by more catch block to catch more exceptions
                        final userCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email, password: password);
                        print(userCredential);
                      } on FirebaseAuthException catch (e) {
                        // format catching specific exception with on and classname exception in handling
                        // print(e.code); errors code
                        // if statement on e.code if user not found print that user not found
                        if (e.code == 'user-not-found') {
                          print('User not found');
                        } else if (e.code == 'wrong-password') {
                          // another exception if user login and the password is wrong
                          print('Wrong Password');
                        }
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              ));
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}
