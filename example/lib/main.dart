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
              const ExtraScrollSpace(),
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
