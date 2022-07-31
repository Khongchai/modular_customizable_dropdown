import "package:flutter/material.dart";
import "package:modular_customizable_dropdown/modular_customizable_dropdown.dart";

class DisplayOnFocusSection extends StatefulWidget {
  final Function(String selectedVal) onValueSelect;

  ///This is passed in from the parent because we want to also set its value when other
  ///examples set the state of the selected value.
  final TextEditingController textEditingController;
  final List<DropdownValue> dropdownValues;
  const DisplayOnFocusSection(
      {required this.dropdownValues,
      required this.textEditingController,
      required this.onValueSelect,
      Key? key})
      : super(key: key);

  @override
  _DisplayOnFocusSectionState createState() => _DisplayOnFocusSectionState();
}

class _DisplayOnFocusSectionState extends State<DisplayOnFocusSection> {
  final TextEditingController _textController = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Display on Focus", style: TextStyle(color: Colors.blue)),
      const SizedBox(height: 20),
      ModularCustomizableDropdown.displayOnFocus(
        focusNode: _focusNode,
        textController: _textController,
        onValueSelect: widget.onValueSelect,
        allDropdownValues: widget.dropdownValues,
        style: const DropdownStyle(
          dropdownMaxHeight: DropdownMaxHeight(byRows: 5),
          explicitMarginBetweenDropdownAndTarget: 10,
          alignment: Alignment.topRight,
          invertYAxisAlignmentWhenOverflow: true,
          dropdownWidth: DropdownWidth(scale: 0.7),
        ),
        targetBuilder: (focusNode, textController) {
          return SizedBox(
            width: 200,
            child: TextField(
              textAlign: TextAlign.center,
              controller: textController,
              focusNode: focusNode,
            ),
          );
        },
      ),
    ]);
  }
}
