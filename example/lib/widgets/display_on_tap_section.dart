import "package:flutter/material.dart";
import "package:modular_customizable_dropdown/modular_customizable_dropdown.dart";

class DisplayOnTapSection extends StatelessWidget {
  final Function(String selectedValue) onValueSelect;
  final List<String> dropdownValues;
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
            widthScale: 1.2,
            borderColor: Colors.black,
            borderThickness: 1,
            //Bottom center with a bit of extra relative margin
            // dropdownAlignment: DropdownAlignment(0, 1.03),
            dropdownAlignment: DropdownAlignment.center,
            dropdownScrollbarStyle: DropdownScrollbarStyle(),
            //Can also do explicit margin, of course, though a bit verbose...
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
