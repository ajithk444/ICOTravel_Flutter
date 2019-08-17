// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';


// class LoginScreen extends StatefulWidget {
//   LoginScreen({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
  
//   Future<void> _signInAnonymously() async {
//     try {
//       await FirebaseAuth.instance.signInAnonymously();
//     } catch (e) {
//       print(e); // TODO: show dialog with error
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Sign in')),
//       body: Center(
//         child: RaisedButton(
//           child: Text('Sign in anonymously'),
//           onPressed: _signInAnonymously,
//         ),
//       ),
//     );
//   }
// }
