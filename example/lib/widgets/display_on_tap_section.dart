import "package:flutter/material.dart";
import "package:modular_customizable_dropdown/modular_customizable_dropdown.dart";

class DisplayOnTapSection extends StatelessWidget {
  final Function(DropdownValue selectedValue) onValueSelect;
  final List<DropdownValue> dropdownValues;
  final String selectedValue;
  const DisplayOnTapSection(
      {required this.dropdownValues,
      required this.onValueSelect,
      required this.selectedValue,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Display on Tap", style: TextStyle(color: Colors.blue)),
        const SizedBox(height: 20),
        ModularCustomizableDropdown.displayOnTap(
          onValueSelect: onValueSelect,
          allDropdownValues: dropdownValues,
          style: const DropdownStyle(
            dropdownMaxHeight: DropdownMaxHeight(
              // Means show 4 rows with the 4th rows having only half its full
              // height.
              byRows: 3.5,
            ),
            dropdownWidth: DropdownWidth(scale: 0.7),
            onTapInkColor: Colors.red,
            explicitMarginBetweenDropdownAndTarget: 5,
            alignment: Alignment.topLeft,
            descriptionStyle: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            // Can also do explicit margin.
            // explicitMarginBetweenDropdownAndTarget: 5,
            invertYAxisAlignmentWhenOverflow: true,
          ),
          target: ElevatedButton(
            child:
                SizedBox(width: 150, child: Align(child: Text(selectedValue))),
            style: ElevatedButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: const BorderSide(
                  width: 1.0,
                  color: Colors.black,
                )),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
