import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_screen.dart';


Future main() async{
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget{



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),


    );
  }
}




