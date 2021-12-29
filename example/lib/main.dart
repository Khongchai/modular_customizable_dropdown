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
    "Flautist",
    "Piano",
    "Conductor",
  ];

  bool showDropdown = false;

  ReactMode currentMode = ReactMode.focusReact;

  final TextEditingController _textController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  final itemToAppend = "happy";

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
              const Text("Display on Focus",
                  style: TextStyle(color: Colors.blue)),
              const SizedBox(height: 100),
              ModularCustomizableDropdown.displayOnFocus(
                focusNode: _focusNode,
                setTextToControllerOnSelect: true,
                textController: _textController,
                onValueSelect: (String newVal) =>
                    setState(() => selectedValue = newVal),
                allDropdownValues: dropdownValues,
                style: const DropdownStyle(
                  borderColor: Colors.black,
                  borderThickness: 1,
                  dropdownAlignment: DropdownAlignment(0, 1.1),
                ),
                invertYAxisAlignmentWhenOverflow: true,
                targetBuilder: (focusNode, textController) => SizedBox(
                  width: 200,
                  child: TextField(
                    controller: textController,
                    focusNode: focusNode,
                  ),
                ),
              ),
              const SizedBox(height: 100),
              const Text("Display on Tap",
                  style: TextStyle(color: Colors.blue)),
              const SizedBox(height: 20),
              ModularCustomizableDropdown.displayOnTap(
                onValueSelect: (String newVal) {
                  setState(() {
                    selectedValue = newVal;
                  });
                  _textController.text = newVal;
                },
                allDropdownValues: dropdownValues,
                barrierDismissible: false,
                style: const DropdownStyle(
                  widthScale: 1.2,
                  borderColor: Colors.black,
                  borderThickness: 1,
                  //Bottom center with a bit of extra relative margin
                  dropdownAlignment: DropdownAlignment(0, 1.03),
                  //Can also do explicit margin, of course, though a bit verbose...
                  // explicitMarginBetweenDropdownAndTarget: 5,
                ),
                target: ElevatedButton(
                  child: SizedBox(
                      width: 150, child: Align(child: Text(selectedValue))),
                  style: ElevatedButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: const BorderSide(
                        width: 1.0,
                        color: Colors.black,
                      )),
                  onPressed: () {},
                ),
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
