import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/services.dart';
import 'package:simple_candlestick_chart/simple_candlestick_chart.dart';
import 'package:interactive_chart/interactive_chart.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var data = <CandleData>[];
  bool _isClicked = false;

  @override
  void initState() {
    rootBundle.loadString('assets/sample_candles.json').then((json) {
      CandleData map(item) => CandleData(
        timestamp: item[0],
        open : double.parse(item[1]),
        high : double.parse(item[2]),
        low : double.parse(item[3]),
        close : double.parse(item[4]),
        volume : double.parse(item[5])
      );
      final items = jsonDecode(json) as List<dynamic>;
      setState(() {
        data = items.map<CandleData>(map).toList().reversed.toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const  BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Image(
                          image: AssetImage('assets/logo.png'),
                          height: 70,
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Correct",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                            Text(
                              "Answers",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Text(
                              "0/12",
                              style:  TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                  const Text(
                    "Question No. 1",
                    style:  TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Will this graph go up or down?",
                    style:  TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 50),
                    Flexible(
                      child: data.length > 3? DecoratedBox(
                        decoration: const BoxDecoration(
                            color: Colors.white
                        ),
                        child: InteractiveChart(
                          candles: data,
                          style: const ChartStyle(
                            timeLabelHeight: 0,
                            timeLabelStyle: TextStyle(
                              color: Colors.transparent,
                            ),
                            priceLabelWidth: 0,
                            priceLabelStyle: TextStyle(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ) :
                          const CircularProgressIndicator(),
                    ),
                    // SizedBox(
                    //   height: 300,
                    //   child: DecoratedBox(
                    //     decoration: const BoxDecoration(
                    //         color: Colors.white
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: SimpleCandlestickChart(
                    //         data: data,
                    //         increaseColor: Colors.teal,
                    //         decreaseColor: Colors.pinkAccent,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Candlesticks(
                    //   candles: candles,
                    // ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 75
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _isClicked = true;
                            });
                          },
                          child: const Text(
                              "UP",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                          ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal:60
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isClicked = true;
                          });
                        },
                        child: const Text(
                          "DOWN",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: _isClicked,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Your answer is correct!",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        MaterialButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {},
                          child: Ink(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 255, 255, 255),
                                  Color.fromARGB(155, 255, 255, 255)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: Container(
                              constraints: const BoxConstraints(
                                minHeight: 30.0,
                                maxWidth: 300,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                                child: Text(
                                  "View Explanation",
                                  style:  TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )),
                        ),
                      ]
                    ),
                  ),
                ],
              ),
          ),
        ),
      ),
    );
  }

  Future<List<Candle>> getChartData() async {
    final jsonData = await services.rootBundle.loadString('assets/sample_candles.json');
    final list = json.decode(jsonData) as List<dynamic>;
    return list.map((e) => Candle.fromJson(e)).toList().reversed.toList();
  }
}
