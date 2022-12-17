import 'package:flutter/material.dart';
import 'package:hand_in_need/constants/routes.dart';
import 'package:hand_in_need/services/auth/auth_exceptions.dart';
import 'package:hand_in_need/services/auth/auth_service.dart';
import '../utilities/show_error_dialogue.dart';

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
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                // Where on our try if we can login take us to our notes view page for our app
                // pushNamedAndRemoveUntil have screen want to put something on top
                // pushing popular term mobile dev had screen push button puts another screen on top
                // Dart always important suffix param with commas
                // We need to check if the user is verified so they cant sign in without doing so
                // get the current user
                final user = AuthService.firebase().currentUser;
                // checking if user is verified
                if (user?.isEmailVerified ?? false) {
                  //users email is verifed
                  //take us to our main route of the app
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  //users email is not verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
                //catching fire base auth exceptions and generic giving  3 cases and we need alert for each case
              } on UserNotFoundAuthException {
                // going display alert using new function
                await showErrorDialog(
                  context,
                  'User Not Found',
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Looks like the password you typed was incorrect please try again',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Authentication error',
                );
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
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Not Registered yet? Register Here!')),
        ],
      )),
    );
  }
}
