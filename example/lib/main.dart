import 'package:example/widgets/display_on_focus_section.dart';
import 'package:example/widgets/display_on_tap_section.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

enum ReactMode {
  tapReact,
  focusReact,
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  GlobalKey<State> key = GlobalKey();

  double fabOpacity = 1.0;

  String selectedValue = "Violin";
  List<String> dropdownValues = [
    "Violin",
    "Viola",
    "Cello",
    "Double Bass",
    "Flautist",
    "Piano",
    "Conductor",
  ];

  bool showDropdown = false;

  ReactMode currentMode = ReactMode.focusReact;

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Dropdown Test"),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 100),
              DisplayOnFocusSection(
                  textEditingController: _textController,
                  dropdownValues: dropdownValues,
                  onValueSelect: (_selectedValue) =>
                      setState(() => selectedValue = _selectedValue)),
              const SizedBox(height: 50),
              DisplayOnTapSection(
                onValueSelect: (_selectedValue) =>
                    setState(() => selectedValue = _selectedValue),
                selectedValue: selectedValue,
                dropdownValues: dropdownValues,
              ),
              const SizedBox(height: 200),
              Text("Selected Value: " + selectedValue),
            ]),
          ),
        ),
      ),
    );
  }
}
