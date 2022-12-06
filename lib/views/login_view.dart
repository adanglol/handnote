//import state to bring code from other developers and
//we need import our main.dart
//vs code shortcut ctrl . to all errors and import that code

//This is when our users want to login
//Similar implementation to maindart with register view
//comments provided within Main.dart to clarify code and functionality

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    //need add scaffold has body parameter
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Login')),
      ),
      body: (Column(
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

          // Create a new Text button that will direct us to our register view to sign up
          // Name Routes Navigator and push and MaterialPageRoute
          // Route its journey with start and end with start and end with view
          // 2 types of routes - either new screen anon route , Named route tell about route before so when app created it knows there is route goes to certain screen

          //We need to define a register and login route for our app
          TextButton(
              onPressed: () {
                //when button press nukes the screen and displays only the route directed in this case register
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/register/', (route) => false);
              },
              child: const Text('Not Registered yet? Register Here!')),
        ],
      )),
    );
  }
}
