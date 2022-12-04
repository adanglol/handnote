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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../firebase_options.dart';

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
    // changing Container to Scaffold (which class provides widgets for building app)
    return Scaffold(
      // create an AppBar an instance of the class
      // horizontal bar on top of our app
      appBar: AppBar(
        title: const Text('Register'),
      ),
      // implementing a register button on our app we are gonna look at body in Scaffold

      //IMPORTANT MAKES LIFE EASIER PLEASE READ
      // VS code feature you can wrap your widgets with other widgets
      // ctrl . on widget wanna wrap and shows options
      // example of center our text button

      // Want our button to register our User in Firebase which is an async task think JS
      // firebase by default create anon users if no login never null

      // Also we need to create two text fields
      // One for the email
      // Other is for the password

      body: FutureBuilder(
        //initialize our future for firebase with future parameter
        //future builder parameter to help aid in our firebase endeavors so it can do its thing in future
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),

        // Next topic connection states
        // told futurebuilder to do future which was to firebase init app
        // snapshot is the state of the object and object itself is result of future
        // future has start point line process and then end point
        // ends successfuly or fail
        // snapshot gets result of future
        // as firebase init we gon tell user we are loading

        builder: (context, snapshot) {
          // manage the states of our Object the connections states using switch statments
          // going to make each connection state print loading except for done becuase it is done
          switch (snapshot.connectionState) {
            // When our future is done and connected
            case ConnectionState.done:
              return (Column(
                children: [
                  //grab these text fields when we click out button
                  //add hint to text field hint user what to input
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
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
                  TextButton(
                    onPressed: () async {
                      // upoun pressing will get email and password from user
                      final email =
                          _email.text; //.text concatenate as string its method
                      final password = _password.text;
                      // Now with firebase we create user 8:42 in video
                      // need to await keyword since returns a FUTURE async basically need to await for the data

                      // Now we need to create a exception for when user try to register and account already created as well
                      // Also the weak password exception
                      // Another exception to catch is invalid email as well
                      try {
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: password);
                        //Output our user input in our debug to make sure it is working like JS and console log
                        print(userCredential);
                      } on FirebaseAuthException catch (e) {
                        // print(e.code);
                        if (e.code == 'weak-password') {
                          print('weak password');
                        } else if (e.code == 'email-already-in-use') {
                          print(
                              'Cannot register user with that email already in use');
                        } else if (e.code == 'invalid-email') {
                          print('Email given is invalid');
                        }
                      }
                    },
                    child: const Text('Sign up'),
                  ),
                ],
              ));
            //default is special case that means every case that I have not handled which is every state besides from done
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}
//IMPORTANT
//If we want to rename symbol right click then choose rename symbol option
//or click on word and press f2 on keyboard
// good to have file structure
// going to have LoginView in its on dedicated file to do so New File type entire path 