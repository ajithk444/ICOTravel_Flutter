import 'package:flutter/material.dart';
import 'package:flutter_fire_login/ui/homeScreen.dart';
import 'package:flutter_fire_login/ui/loginScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        fontFamily: 'Lobster Two'
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen()// HomeScreen(title: 'ICOTravel'),
    );
  }
}
