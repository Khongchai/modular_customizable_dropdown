import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:really_customizable_dropdown/dropdown.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  GlobalKey<State> key = GlobalKey();

  double fabOpacity = 1.0;

  String selectedValue = "Violin";
  List<String> values = [
    "Violin",
    "Viola",
    "Cello",
    "Double Bass",
    "Piano",
    "Conductor"
  ];
  bool showDropdown = false;

  final TextEditingController _textController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Scrolling."),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(top: 100),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text("Selected value: $selectedValue"),
            const SizedBox(height: 50),
            ReallyCustomizableDropdown.displayOnTap(
                onValueSelect: ((newValue) =>
                    setState(() => selectedValue = newValue)),
                allDropdownValues: values,
                target: SizedBox(width: 200, child: Text(selectedValue))),
            const SizedBox(height: 50),
            ReallyCustomizableDropdown.displayOnFocus(
              setTextToControllerOnSelect: true,
              textController: _textController,
              onValueSelect: ((newValue) =>
                  setState(() => selectedValue = newValue)),
              dropdownValues: values,
              targetBuilder: (focusNode, textController) => Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.brown),
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  focusNode: focusNode,
                  controller: textController,
                ),
              ),
              focusNode: _focusNode,
            )
          ]),
        ),
        floatingActionButton: Opacity(
          opacity: fabOpacity,
          child: FloatingActionButton(
            onPressed: () {
              print("YAY");
            },
          ),
        ),
      ),
    );
  }
}
