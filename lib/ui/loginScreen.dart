import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Size _size;
  final _formKey = GlobalKey<FormState>();
  final _myController = TextEditingController();

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      width: _size.width,
      height: _size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFF654EA3), const Color(0xFFEAAFC8)])),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text('iShuttle',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 31,
                )),
            SizedBox(
              height: 30,
            ),
            Text(
              'Live Shuttle Tracking System',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
              ),
            ),
            //LoginForm(),
          ],
        ),
      ),
    ));
  }
}
