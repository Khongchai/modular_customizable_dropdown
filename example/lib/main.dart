import 'package:example/widgets/display_on_callback_section.dart';
import 'package:example/widgets/display_on_focus_section.dart';
import 'package:example/widgets/display_on_tap_section.dart';
import 'package:example/widgets/extra_scroll_space.dart';
import 'package:example/widgets/section_divider.dart';
import 'package:flutter/material.dart';
import "package:modular_customizable_dropdown/classes_and_enums/dropdown_value.dart";

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
  // Don't make final.
  final List<DropdownValue> _dropdownValues = [
    DropdownValue(
      value: "Violinist",
      description:
          "A very long description that describes this value. Hopefully, this will wrap around.",
    ),
    DropdownValue(
      value: "Violist",
    ),
    DropdownValue(
      value: "Cellist",
      description: "A medium-sized description for this value.",
    ),
    DropdownValue(
      value: "Flautist",
    ),
    DropdownValue(
      value: "Pianist",
      description:
          "A very long description that describes this value. Hopefully, this will wrap around.",
    ),
    DropdownValue(
      value: "Guitarist",
    ),
    DropdownValue(
      value: "Conductor",
      description: "A medium-sized description for this value.",
    ),
  ];
  String _selectedValue = "Violinist";

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
                  For readability, the code for each section has been divided into its own file.
                  Please see the widgets folder in the same directory.
               */
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.deepPurpleAccent),
                  ),
                  onPressed: () {
                    setState(() {
                      _dropdownValues.remove(_dropdownValues[0]);
                      debugPrint(_dropdownValues.toString());
                    });
                  },
                  child: const Text("Remove First Item From Dropdown List")),
              const Divider(
                thickness: 2,
              ),
              DisplayOnFocusSection(
                textEditingController: _textController,
                dropdownValues: _dropdownValues,
                onValueSelect: _onDropdownValueSelect,
              ),
              const SectionDivider(),
              DisplayOnTapSection(
                onValueSelect: _onDropdownValueSelect,
                selectedValue: _selectedValue,
                dropdownValues: _dropdownValues,
              ),
              const SectionDivider(),
              DisplayOnCallbackSection(
                selectedValue: _selectedValue,
                onValueSelect: _onDropdownValueSelect,
                dropdownValues: _dropdownValues,
              ),
              const SectionDivider(),
              Text("Selected Value: " + _selectedValue,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const ExtraScrollSpace(),
            ]),
          ),
        ),
      ),
    );
  }

  void _onDropdownValueSelect(DropdownValue newValue) {
    setState(() {
      _selectedValue = newValue.value;
      _textController.text = newValue.value;
    });
  }
}
