import 'package:example/widgets/display_on_callback_section.dart';
import 'package:example/widgets/display_on_focus_section.dart';
import 'package:example/widgets/display_on_tap_section.dart';
import 'package:example/widgets/extra_scroll_space.dart';
import 'package:example/widgets/section_divider.dart';
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
  List<String> dropdownValues = [
    "Violinist",
    "Violist",
    "Cellist",
    "Flautist",
    "Pianist",
    "Guitarist",
    "Conductor",
  ];
  String selectedValue = "Violinist";

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
              const ExtraScrollSpace(),
              /*
                  For readability, the code for each section has been divided into their own file.
                  Please see the widgets folder in the same directory.
               */
              DisplayOnFocusSection(
                textEditingController: _textController,
                dropdownValues: dropdownValues,
                onValueSelect: _onDropdownValueSelect,
              ),
              const SectionDivider(),
              DisplayOnTapSection(
                onValueSelect: _onDropdownValueSelect,
                selectedValue: selectedValue,
                dropdownValues: dropdownValues,
              ),
              const SectionDivider(),
              DisplayOnCallbackSection(
                selectedValue: selectedValue,
                onValueSelect: _onDropdownValueSelect,
                dropdownValues: dropdownValues,
              ),
              const SectionDivider(),
              Text("Selected Value: " + selectedValue,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const ExtraScrollSpace(),
            ]),
          ),
        ),
      ),
    );
  }

  void _onDropdownValueSelect(String newValue) {
    setState(() {
      selectedValue = newValue;
      _textController.text = newValue;
    });
  }
}
