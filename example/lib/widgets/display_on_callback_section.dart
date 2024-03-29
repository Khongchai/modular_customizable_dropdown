import "package:flutter/material.dart";
import "package:modular_customizable_dropdown/modular_customizable_dropdown.dart";

class DisplayOnCallbackSection extends StatefulWidget {
  final Function(DropdownValue selectedValue) onValueSelect;
  final List<DropdownValue> dropdownValues;
  final String selectedValue;
  const DisplayOnCallbackSection(
      {required this.dropdownValues,
      required this.onValueSelect,
      required this.selectedValue,
      Key? key})
      : super(key: key);

  @override
  State<DisplayOnCallbackSection> createState() =>
      _DisplayOnCallbackSectionState();
}

class _DisplayOnCallbackSectionState extends State<DisplayOnCallbackSection> {
  late Function(bool) toggleDropdown;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Display on Callback", style: TextStyle(color: Colors.blue)),
        const SizedBox(height: 20),
        ModularCustomizableDropdown.displayOnCallback(
          onValueSelect: widget.onValueSelect,
          allDropdownValues: widget.dropdownValues,
          barrierDismissible: true,
          style: const DropdownStyle(
            onTapInkColor: Colors.amber,
            dropdownWidth: DropdownWidth(scale: 1.2),
            dropdownMaxHeight: DropdownMaxHeight(
              byRows: 7,
            ),
            //Bottom center with a bit of extra relative margin
            // alignment: Alignment(0, -1.03),
            alignment: Alignment.topCenter,
            //Can also do explicit margin, of course, though a bit verbose...
            // explicitMarginBetweenDropdownAndTarget: 5,
            invertYAxisAlignmentWhenOverflow: true, // true is the default value
          ),
          targetBuilder: (_toggleDropdown) {
            toggleDropdown = _toggleDropdown;
            return const Text("This is the dropdown's target");
          },
          collapseOnSelect: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          child: const SizedBox(
              child: Text("Click to Show Dropdown at the target")),
          style: ElevatedButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: const BorderSide(
                width: 1.0,
                color: Colors.black,
              )),
          onPressed: () {
            toggleDropdown(true);
          },
        ),
      ],
    );
  }
}
