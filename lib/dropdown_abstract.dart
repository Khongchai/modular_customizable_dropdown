import "package:flutter/material.dart";

abstract class Dropdown {
  late final Color borderColor;
  late final double borderThickness;
  late final List<String> dropdownValues;
  late final Function(String selectedValue) onValueSelect;
  late final BorderRadius borderRadius;
  late final List<BoxShadow> boxShadow;

  ///Space between the dropdown and the target widget.
  late final double topMargin;

  ///Your standard material elevation.
  late final double elevation;

  ///If not given, the dropdown will grow to be as large as the child needs.
  late final double maxHeight;

  ///Whether or not to collapse the dropdown when a value is selected.
  late final bool collapseOnSelect;

  ///Allows user to click outside dropdown to dismiss
  ///
  ///Setting this to false may cause the dropdown to flow over other elements while scrolling(including the appbar).
  late final bool barrierDismissible;

  ///The color of a dropdown when tapped
  late final LinearGradient onTapItemColor;

  ///The dropdown itself does not have a padding, so setting this would be equivalent to setting the dropdown's background color.
  late final LinearGradient defaultItemColor;

  ///Target to attach the dropdown to
  late final Widget target;

  late final TextStyle defaultTextStyle;

  ///Style for dropdown text when tapped
  late final TextStyle onTapTextStyle;
}
