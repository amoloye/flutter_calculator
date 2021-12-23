import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExtendCalc extends StatefulWidget {
  const ExtendCalc({Key? key}) : super(key: key);

  @override
  _ExtendCalcState createState() => _ExtendCalcState();
}

class _ExtendCalcState extends State<ExtendCalc> {
  List<String> view = [" "];
  List<dynamic> displaytxt = [20];
  List<String> btntxt =[" "];

//Button Widget

  Widget Calcbutton(String btntxt, Color btncolor, Color txtcolor) {
    return Container(
      child: RaisedButton(
        onPressed: () {
          _loadResult();
          //TODO add function for button press
          calculation(btntxt);
        },
        child: Text(
          btntxt,
          style: TextStyle(
            fontSize: 35,
            color: txtcolor,
          ),
        ),
        shape: CircleBorder(),
        color: btncolor,
        padding: EdgeInsets.all(20),
      ),
    );
  }

  Widget Convbutton(String btntxt, Color btncolor, Color txtcolor) {
    return Container(
      child: RaisedButton(
        onPressed: () {
          _loadResult();
          FirebaseFirestore.instance.collection('btntxt')
              .add(finalResult);

          calculation(btntxt);
          //button function
        },
        shape: StadiumBorder(),
        child: Text(
          btntxt,
          style: TextStyle(
            fontSize: 35,
            color: txtcolor,
          ),
        ),
        color: btncolor,
        padding: EdgeInsets.all(20),
      ),
    );
  }

  //init sharedPreference state
  @override
  void initState() {
    _loadResult();
    super.initState();
  }

  //loading counter for sharedPreference
  void _loadResult() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      finalResult = (prefs.getString('result') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          //Calculator display
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    text,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 100),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //button function will be called where we will pass some arguments
              Calcbutton('AC', Colors.grey, Colors.black),
              Calcbutton('+/-', Colors.grey, Colors.black),
              Calcbutton('%', Colors.grey, Colors.black),
              Calcbutton('/', Colors.grey, Colors.white),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //button function will be called where we will pass some arguments
              Calcbutton('7', Colors.grey, Colors.white),
              Calcbutton('8', Colors.grey, Colors.white),
              Calcbutton('9', Colors.grey, Colors.white),
              Calcbutton('x', Colors.grey, Colors.white),
            ],
          ),
          SizedBox(
            height: 10,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //button function will be called where we will pass some arguments
              Calcbutton('4', Colors.grey, Colors.white),
              Calcbutton('5', Colors.grey, Colors.white),
              Calcbutton('6', Colors.grey, Colors.white),
              Calcbutton('-', Colors.grey, Colors.white),
            ],
          ),
          SizedBox(
            height: 10,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //button function will be called where we will pass some arguments
              Calcbutton('1', Colors.grey, Colors.white),
              Calcbutton('2', Colors.grey, Colors.white),
              Calcbutton('3', Colors.grey, Colors.white),
              Calcbutton('+', Colors.grey, Colors.white),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                padding: EdgeInsets.all(20.0),
                onPressed: () {
                  calculation('0');
                  //button function
                },
                shape: StadiumBorder(),
                child: Text(
                  "0",
                  style: TextStyle(fontSize: 35, color: Colors.white),
                ),
                color: Colors.grey[850],
              ),

              //my new navigation button
              RaisedButton(
                padding: EdgeInsets.all(20.0),
                onPressed: () {
                  //button function
                  Navigator.pop(context);
                },
                shape: StadiumBorder(),
                child: Icon(Icons.arrow_back),
                color: Colors.red,
              ),

              Calcbutton('.', Colors.grey, Colors.white),
              Calcbutton('=', Colors.amber, Colors.white),
            ],
          ),

          SizedBox(
            height: 10,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Convbutton('m->km', Colors.tealAccent, Colors.black),
              Convbutton('km->m', Colors.tealAccent, Colors.black)
            ],
          ),
        ]),
      ),
    );
  }

  //logic
  dynamic text = '0';
  double numOne = 0;
  double numTwo = 0;

  dynamic result = '';
  dynamic finalResult = '';
  dynamic opr = '';
  dynamic preOpr = '';

  void calculation(btnText) {
    if (btnText == 'AC') {
      text = '0';
      numOne = 0;
      numTwo = 0;
      result = '';
      finalResult = '0';
      opr = '';
      preOpr = '';
    } else if (btnText == 'm->km') {
      finalResult = convMkm();
    } else if (btnText == 'km->m') {
      finalResult = convKMm();
    } else if (opr == '=' && btnText == '=') {
      if (preOpr == '+') {
        finalResult = add();
      } else if (preOpr == '-') {
        finalResult = sub();
      } else if (preOpr == 'x') {
        finalResult = mul();
      } else if (preOpr == '/') {
        finalResult = div();
      }
    } else if (btnText == '+' ||
        btnText == '-' ||
        btnText == 'x' ||
        btnText == '/' ||
        btnText == '=') {
      if (numOne == 0) {
        numOne = double.parse(result);
      } else {
        numTwo = double.parse(result);
      }

      if (opr == '+') {
        finalResult = add();
      } else if (opr == '-') {
        finalResult = sub();
      } else if (opr == 'x') {
        finalResult = mul();
      } else if (opr == '/') {
        finalResult = div();
      }
      preOpr = opr;
      opr = btnText;
      result = '';
    } else if (btnText == '%') {
      result = numOne / 100;
      finalResult = doesContainDecimal(result);
    } else if (btnText == '.') {
      if (!result.toString().contains('.')) {
        result = result.toString() + '.';
      }
      finalResult = result;
    } else if (btnText == '+/-') {
      result.toString().startsWith('-')
          ? result = result.toString().substring(1)
          : result = '-' + result.toString();
      finalResult = result;
    } else {
      result = result + btnText;
      finalResult = result;
    }

    setState(() {
      text = finalResult;
    });
  }

  String add() {
    result = (numOne + numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String sub() {
    result = (numOne - numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String mul() {
    result = (numOne * numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String div() {
    result = (numOne / numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  //conversion

  String convMkm() {
    numOne = double.parse(result);
    result = (numOne * 1000).toString();
    return doesContainDecimal(result);
  }

  String convKMm() {
    numOne = double.parse(result);
    result = (numOne / 1000).toString();
    return doesContainDecimal(result);
  }

  String doesContainDecimal(dynamic result) {
    if (result.toString().contains('.')) {
      List<String> splitDecimal = result.toString().split('.');
      if (!(int.parse(splitDecimal[1]) > 0))
        return result = splitDecimal[0].toString();
    }
    return result;
  }
}
