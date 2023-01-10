// Widgets
// show key word for import get only show specific part could come it handy for importing a lot stf stl
// You can give alias with as and name ex as devtools
// print can print a object but log cannot it needs to be a string so we use .toString method that every Object class has
import 'dart:developer' as console show log;
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// abstract firebase in UI code
import 'package:hand_in_need/services/auth/auth_service.dart';
// Register and Login View files for our App
import 'package:hand_in_need/views/login_view.dart';
import 'package:hand_in_need/views/notes/create_update_note_view.dart';
import 'package:hand_in_need/views/notes/notes_view.dart';
import 'package:hand_in_need/views/register_view.dart';
import 'package:hand_in_need/views/verify_email_view.dart';
// routes for various screens
import 'constants/routes.dart';

// 8:12 Stateless vs Stateful
// Hot reload keeps state
// State is just data that is mutated by application or both like pressing button
// Widgets
// Stateful Widget widget contains information that can be changed as user interacts or as time goes by or widget seems fit
// Stateless widget can not contain mutable pieces of information and does not manage any internally

// Main.dart is going to serve to be the homepage for our app
// help us move between signing in as well as transition and such

// Remember when using git
// git log
// git add --all
// git commit -am "step2"
// git push

// git tag ""
// git status
// git push --tags

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),

    home: const HomePage(),
    // parameter called routes for linking different part of page like register and login
    // takes in map as argument
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

// comment it out we are going to implement a new homepage that is incrementing app to learn more about Bloc and how to use it
// Ensure that the current user in app is non null and email is verified
// We are gon send email to this email and click link

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     //remove scaffold in our main we dont want embed others
//     return FutureBuilder(
//       // dont wanna push widgets in future builder
//       // for future references and implementation
//       // remedy future we are going to auth service so we are not directly talking firebase in UI
//       future: AuthService.firebase().initialize(),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             // Check our current user logged in to our app
//             final user = AuthService.firebase().currentUser;
//             // print(user); debugg purposes and prints current user crendentials

//             // accomodate condition to return correct widget if user verified print verfied
//             // if user is present or not null
//             if (user != null) {
//               //check if the user email is verified
//               if (user.isEmailVerified) {
//                 // when user is present and email has been verified take us to our app home widget
//                 return const NotesView();
//               } else {
//                 // need to verify email
//                 return const VerifyEmailView();
//               }
//             } else {
//               // if user is null send them to login view to login
//               return const LoginView();
//             }
//           // fault back to if not done or loading in this case
//           default:
//             //instead of returning loading we can use widget to do so
//             // need to fix presentation
//             return const CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }

// Our new homepage to learn about bloc
// it increments and decrement
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // adding our Text editing controller to listen text
  late final TextEditingController _controller;

  @override
  void initState() {
    // instantiate controller
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // when we are done with it
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // now we use Bloc to build our UI
    // we will be using Bloc provider and Bloc Consumer
    return BlocProvider(
      create: (context) {
        return CounterBloc();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Testing Bloc'),
        ),
        // where we will have our Bloc consumer in body
        // combination of bloc listener and builder
        // we need it becasue upoun every press of plus andn minus we want clear text which is our listener
        // we also need builder to build UI based on curretn state of Bloc
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            // upoun any new states produced by bloc want clear text editing controller
            _controller.clear();
          },
          builder: (context, state) {
            // check for invalid value
            final invalidValue =
                (state is CounterStateInvalidNumber) ? state.invalidValue : '';
            // reason behind this is so we can display error message to user should there be invalid value
            // we have to return widget
            // column display vertical row horizontal
            return Column(
              children: [
                Text(
                  'Current Value is ${state.value}',
                ),
                // create a visibility widget which incase the current state is counterstateinvalidnumber gonna display error message
                Visibility(
                  visible: state is CounterStateInvalidNumber,
                  child: Text('Invalid input: $invalidValue'),
                ),
                // add text so user can enter text in Main UI
                TextField(
                  // adding our controller
                  controller: _controller,
                  // hint text
                  decoration:
                      const InputDecoration(hintText: 'Enter a number here'),
                  keyboardType: TextInputType.number,
                ),
                // where we will have our increment and decrement buttons
                Row(
                  // two text buttons here
                  children: [
                    // inc
                    TextButton(
                      onPressed: () {
                        // when + button pressed convey text information from controller to bloc
                        // do this by using read
                        // then add new event pass our controller text
                        context
                            .read<CounterBloc>()
                            .add(IncrementEvent(_controller.text));
                      },
                      child: const Icon(Icons.add),
                    ),
                    // dec
                    TextButton(
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(DecrementEvent(_controller.text));
                      },
                      child: const Icon(Icons.minimize_rounded),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// every bloc has 2 important properties state and a event
// event goes in bloc state comes out of bloc
// state describes state of bloc

// OUR STATES
// Counter
// Valid
// Invalid

// we need a counter state class
@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

// valid state
class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

// invalid state
class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;
  const CounterStateInvalidNumber({
    // value cause invalid
    required this.invalidValue,
    // previous value
    required int previousValue,
  }) : super(previousValue);
}

// OUR EVENTS
// Counter
// Increase
// Decrease

// counter event
@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

// increment counter event
class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

// increment counter event
class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

// create bloc need define event and state
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  // we have counter block what it does calls super
  // super means initial state
  // every bloc has to have initial state thats what being passed to super
  CounterBloc() : super(const CounterStateValid(0)) {
    // need to grab events as they come the UI will pass the events like inc and dec event
    // how use function called on
    on<IncrementEvent>(((event, emit) {
      // our event is our increment event
      // gonna parse string in inc event as int
      //if it cant parse int will be null
      final integer = int.tryParse(event.value);
      // if we have  value of null meaning that string could not be parsed as int
      if (integer == null) {
        //  use emit
        // emit is function of its own allows pass state out our bloc
        // this case it is counter state invalid number since value could not be parse
        emit(CounterStateInvalidNumber(
          // event where value is invalid
          invalidValue: event.value,
          // previous value is always stored in state
          previousValue: state.value,
        ));
      } else {
        // if we could grab int
        emit(CounterStateValid(state.value + integer));
      }
    }));
    // Decrement event
    on<DecrementEvent>((event, emit) {
      // similar with increment event
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalidNumber(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        // we can decrement it
        emit(CounterStateValid(state.value - integer));
      }
    });
  }
}
