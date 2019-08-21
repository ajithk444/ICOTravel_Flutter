import 'package:flutter/material.dart';
import 'package:flutter_fire_login/ui/homeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ICOTravel',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        //fontFamily: 'Lobster Two'
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(title: 'ICOTravel'),
    );
  }
}
