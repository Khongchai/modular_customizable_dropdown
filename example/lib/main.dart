import 'package:flutter/material.dart';
import "package:modular_customizable_dropdown/modular_customizable_dropdown.dart";

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
    "Piano",
    "Conductor"
  ];
  List<String> dropdownValues2 = [
    "Mathematician",
    "Scientist",
    "Programmer",
    "Engineer",
    "Teacher"
  ];

  bool showDropdown = false;

  ReactMode currentMode = ReactMode.focusReact;

  final TextEditingController _textController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  bool valuesToggle = true;

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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                const SizedBox(height: 63),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _buildDropdownCycleButton(),
                  _buildValuesToggleButton(),
                ]),
                const SizedBox(height: 63),
                ModularCustomizableDropdown.displayOnFocus(
                  focusNode: _focusNode,
                  setTextToControllerOnSelect: true,
                  textController: _textController,
                  onValueSelect: (String newVal) =>
                      setState(() => selectedValue = newVal),
                  allDropdownValues:
                      valuesToggle ? dropdownValues : dropdownValues2,
                  barrierDismissible: false,
                  style: const DropdownStyle(
                    borderColor: Colors.black,
                    borderThickness: 1,
                    dropdownAlignment: DropdownAlignment.center,
                  ),
                  targetBuilder: (focusNode, textController) => TextField(
                    controller: textController,
                    focusNode: focusNode,
                  ),
                )
              ])),
        ),
      ),
    );
  }

  Widget _buildValuesToggleButton() {
    return TextButton(
      child: Text(valuesToggle ? "First List" : "Second List"),
      onPressed: () => setState(() => valuesToggle = !valuesToggle),
    );
  }

  Widget _buildDropdownCycleButton() {
    if (currentMode == ReactMode.tapReact) {
      return TextButton(
          onPressed: () => setState(() => currentMode = ReactMode.focusReact),
          child: Row(
            children: const [
              Text("Tap-based"),
              Icon(Icons.chevron_right_rounded),
            ],
          ));
    } else {
      return TextButton(
          onPressed: () => setState(() => currentMode = ReactMode.tapReact),
          child: Row(
            children: const [
              Icon(Icons.chevron_left_rounded),
              Text("Focus-based"),
            ],
          ));
    }
  }
}
