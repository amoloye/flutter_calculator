
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


import 'Screen/home_screen.dart';


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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




