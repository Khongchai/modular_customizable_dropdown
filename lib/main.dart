import 'package:flutter/material.dart';
import 'package:really_customizable_dropdown/really_customizable_text_dropdown/really_customizable_text_dropdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  static const searchList = [
    "Apple",
    "Banana",
    "Grape",
    "Guava",
    "Kiwi",
    "Watermelon"
  ];

  @override
  Widget build(BuildContext context) {
    final halfWidth = MediaQuery.of(context).size.width / 2;
    return SafeArea(
      child: Scaffold(
          body: SizedBox(
              child: Center(
                  child: SizedBox(
                      width: halfWidth,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ReallyCustomizableTextDropdown(
                                  dropDownTopPadding: 8,
                                  searchItems: searchList),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: halfWidth,
                              height: 100,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: halfWidth,
                              height: 100,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: halfWidth,
                              height: 100,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: halfWidth,
                              height: 100,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: halfWidth,
                              height: 100,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: halfWidth,
                              height: 100,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: halfWidth,
                              height: 100,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: halfWidth,
                              height: 100,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: halfWidth,
                              height: 100,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ))))),
    );
  }
}
