import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_calculator/components/radio_buttons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Calculator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Basic Stock Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum TranactionType { buy, sell }

// ignore: non_constant_identifier_names
const String NO_RESULT_TEXT = "No Result";

class _MyHomePageState extends State<MyHomePage> {
  static const double tMul = 1.005;
  static const double slMul = 0.998;
  static const double rsiDiv = 0.8;

  final inputOneController = TextEditingController();
  final inputTwoController = TextEditingController();
  TranactionType transaction = TranactionType.buy;
  bool calcMore = false;
  String result = NO_RESULT_TEXT;

  void _onRadioValueChanged(TranactionType value) {
    setState(() {
      transaction = value;
    });
  }

  void _reset() {
    setState(() {
      result = NO_RESULT_TEXT;
    });
    inputOneController.clear();
    inputTwoController.clear();
  }

  void _setResult() {
    double input_1 = double.parse(inputOneController.text.trim());
    double input_2 = double.parse(inputTwoController.text.trim().isNotEmpty
        ? inputTwoController.text.trim()
        : "0.0");

//BUY - Calculation for buy transaction.
    if (transaction == TranactionType.buy) {
      double t1 = input_1 * tMul;
      double t2 = input_1 * pow(tMul, 2);
      double t3 = input_1 * pow(tMul, 3);

      double sl1 = input_1 * slMul;
      double sl2 = input_1 * pow(slMul, 2);
      double sl3 = input_1 * pow(slMul, 3);

      String advResult = "";
      if (calcMore && inputOneController.text.trim().isNotEmpty) {
        double rsi = input_2 / rsiDiv;
        double strength = rsi / input_2;
        advResult = '\n-----\nRSI = $rsi \nStrength = $strength';
      }
      String allResult =
          'T1 = $t1 \nT2 = $t2 \nT3 = $t3 \n----- \nSL1 = $sl1 \nSL2 = $sl2 \nSL3 = $sl3 $advResult';
      setState(() {
        result = allResult;
      });
    }

    //SELL - Calculation for sell transaction.
    else if (transaction == TranactionType.sell) {
      double t1 = input_1 / tMul;
      double t2 = input_1 / pow(tMul, 2);
      double t3 = input_1 / pow(tMul, 3);

      double sl1 = input_1 / slMul;
      double sl2 = input_1 / pow(slMul, 2);
      double sl3 = input_1 / pow(slMul, 3);

      String advResult = "";
      if (calcMore && inputTwoController.text.trim().isNotEmpty) {
        double rsi = input_2 * rsiDiv;
        double strength = input_2 / rsi;
        advResult = '\n-----\nRSI = $rsi \nStrength = $strength';
      }
      String allResult =
          'T1 = $t1 \nT2 = $t2 \nT3 = $t3 \n----- \nSL1 = $sl1 \nSL2 = $sl2 \nSL3 = $sl3 $advResult';
      setState(() {
        result = allResult;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    inputOneController.dispose();
    inputTwoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Container(
                    // height: 50,
                    alignment: Alignment.bottomRight,
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height / 3,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border.all(
                          color: Colors.blue.shade300,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        result,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ),
                RadioButtons(
                    onValueChanged: _onRadioValueChanged, value: transaction),
                TextField(
                  controller: inputOneController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a price',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Row(
                    children: [
                      Text(
                        'Calculate RSI and Strength',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Switch(
                        // This bool value toggles the switch.
                        value: calcMore,
                        activeColor: Colors.blue,
                        onChanged: (bool value) {
                          // This is called when the user toggles the switch.
                          setState(() {
                            calcMore = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: calcMore,
                  child: TextField(
                    controller: inputTwoController,
                    enabled: calcMore,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a value',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'(^\d*\.?\d*)')),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (inputOneController.text.trim().isEmpty) {
                              const snackBar = SnackBar(
                                content: Text('Please enter a price!'),
                                showCloseIcon: true,
                                closeIconColor: Colors.white,
                                backgroundColor: Colors.amber,
                              );

                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              _setResult();
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 32.0),
                            child: Text("CALCULATE"),
                          )),
                      const SizedBox(width: 24), // give it width
                      OutlinedButton(
                          style: result == NO_RESULT_TEXT
                              ? null
                              : OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    width: 1.5,
                                    color: Colors.blue,
                                  ),
                                ),
                          onPressed: result == NO_RESULT_TEXT
                              ? null
                              : () {
                                  _reset();
                                },
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text("RESET"),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
