// Widgets
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Register and Login View files for our App
import 'package:hand_in_need/views/login_view.dart';
import 'package:hand_in_need/views/register_view.dart';

import 'firebase_options.dart';

// 8:12 Stateless vs Stateful
// Hot reload keeps state
// State is just data that is mutated by application or both like pressing button
//Widgets
// Stateful Widget widget contains information that can be changed as user interacts or as time goes by or widget seems fit
// Stateless widget can not contain mutable pieces of information and does not manage any internally

// Main.dart is going to serve to be the homepage for our app
// help us move between signing in as well as transition and such
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
  ));
}

// Ensure that the current user in app is non null and email is verified
// We are gon send email to this email and click link
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // Check our current user logged in to our app
              final user = FirebaseAuth.instance.currentUser;
              // if condition check whether our user is null or not use operator if left exist take value other wise false
              if (user?.emailVerified ?? false) {
                print('Email has been verified'); // true
              } else {
                // false
                print('You need to verify your email first');
              }
              return Text('Done');
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}
