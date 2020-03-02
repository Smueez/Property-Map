
import 'package:flutter/material.dart';
import 'package:logo_demo/screens/place_details.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOGO',
      debugShowCheckedModeBanner: false,
      home: PlacesDetails()
    );
  }
}