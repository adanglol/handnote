//import state to bring code from other developers and
//we need import our main.dart
//vs code shortcut ctrl . to all errors and import that code

//This is when our users want to login
//Similar implementation to maindart with register view
//comments provided within Main.dart to clarify code and functionality
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hand_in_need/constants/routes.dart';
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
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                // Where on our try if we can login take us to our notes view page for our app
                // pushNamedAndRemoveUntil have screen want to put something on top
                // pushing popular term mobile dev had screen push button puts another screen on top
                // Dart always important suffix param with commas
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false,
                );

                //catching fire base auth exceptions and generic giving  3 cases and we need alert for each case

              } on FirebaseAuthException catch (e) {
                // format catching specific exception with on and classname exception in handling
                // print(e.code); errors code
                // if statement on e.code if user not found print that user not found
                if (e.code == 'user-not-found') {
                  // going display alert using new function
                  await showErrorDialog(
                    context,
                    'User Not Found',
                  );
                } else if (e.code == 'wrong-password') {
                  // another exception if user login and the password is wrong
                  // alert our user
                  await showErrorDialog(
                    context,
                    'Looks like the password you typed was incorrect please try again',
                  );
                } else {
                  //generic firebase auth error
                  await showErrorDialog(
                    context,
                    'Error ${e.code}',
                  );
                }
                //generic catch block any other error that our code finds out about
              } catch (e) {
                await showErrorDialog(context, 'Error : ${e.toString()}');
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
