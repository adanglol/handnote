import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_in_need/constants/routes.dart';
import 'package:hand_in_need/services/auth/auth_exceptions.dart';
import 'package:hand_in_need/services/auth/bloc/auth_bloc.dart';
import 'package:hand_in_need/services/auth/bloc/auth_event.dart';
import 'package:hand_in_need/services/auth/bloc/auth_state.dart';
import 'package:hand_in_need/utilities/dialogs/error_dialouge.dart';
import 'package:hand_in_need/utilities/dialogs/loading_dialouge.dart';

// Where on our try if we can login take us to our notes view page for our app
// pushNamedAndRemoveUntil have screen want to put something on top
// pushing popular term mobile dev had screen push button puts another screen on top
// Dart always important suffix param with commas
// We need to check if the user is verified so they cant sign in without doing so
// get the current user
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  // keep hold of Close dialouge
  CloseDialogue? _closeDialougeHandle;

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        // handle exceptions here
        // UserNotFound , WrongPassword , and GenericAuth
        if (state is AuthStateLoggedOut) {
          // looking at our close dialouge handle
          final closeDialouge = _closeDialougeHandle;
          // look at our state and if we have it and display correct behavior accordingly
          // not loading now but were before
          // sum it up loading logic
          if (!state.isLoading && closeDialouge != null) {
            // closing dialouge
            closeDialouge();
            _closeDialougeHandle = null;
            // if state is loading and we dont have loading dialouge yet on screen we have to show it
          } else if (state.isLoading && closeDialouge == null) {
            // show dialouge loading
            _closeDialougeHandle =
                showLoadingDialouge(context: context, text: 'Loading...');
          }
          if (state.exception is UserNotFoundAuthException ||
              state.exception is WrongPasswordAuthException) {
            await showErrorDialouge(context,
                'Looks like you typed in the wrong credentials or have not logged in with an account please try again');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialouge(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
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
            // need implement bloc listener for our exceptions when trying to login
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                // use context for authbloc
                // using bloc to login and seperate our logic
                context.read<AuthBloc>().add(AuthEventLogin(email, password));
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
                  // grab auth bloc
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());
                },
                child: const Text('Not Registered yet? Register Here!')),
          ],
        )),
      ),
    );
  }
}
