import "package:flutter/material.dart";

import 'dropdown_alignment.dart';
import 'dropdown_max_height.dart';

///To allow for both gradient and solid color, in many places, the LinearGradient class is used instead of the Color class.
///
///If a solid, single color is what you want, simply provide LinearGradient(colors: [yourSingleColor, yourSingleColor]) --
///in other words, a LinearGradient instance with the same color provided at least twice in the colors array.
class DropdownStyle {
  final Color borderColor;
  final double borderThickness;
  final BorderRadius borderRadius;
  final List<BoxShadow> boxShadows;

  final DropdownMaxHeight dropdownMaxHeight;

  ///The color of a dropdown when tapped
  final LinearGradient onTapItemColor;

  ///The dropdown itself does not have a padding, so setting this would be equivalent to setting the dropdown's background color.
  final LinearGradient defaultItemColor;

  ///Scale the width of the dropdown relative to either the parent's width, or the provided dropdownWidth.
  final double widthScale;

  ///If provided, the dropdown will no longer scale itself according to the width of its parent.
  final double? width;

  ///### Why
  ///While DropdownAlignment is also capable of providing margin between the target and the dropdown,
  ///situation sometimes calls for explicit margins in pixels. This is the param for that.
  ///
  ///### But
  ///
  ///If you use this with alignment positions that position the dropdown over the target widget -- the dropdown
  ///is positioned in such a way that you don't really see any margin, because it's right on top of the target widget,
  ///then using this is pointless.
  final double explicitMarginBetweenDropdownAndTarget;

  ///Style for dropdown text when tapped
  final TextStyle onTapTextStyle;

  final Duration onTapColorTransitionDuration;

  final TextStyle defaultTextStyle;

  final DropdownAlignment dropdownAlignment;

  final Duration transitionInDuration;

  ///Whether or not to swap the alignment, for example, from bottomCenter to topCenter when
  ///the bottom of the dropdown exceeds the screen height.
  final bool invertYAxisAlignmentWhenOverflow;

  const DropdownStyle({
    required this.invertYAxisAlignmentWhenOverflow,
    this.boxShadows = const [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        blurRadius: 10,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: Color.fromRGBO(35, 64, 98, 0.5),
        blurRadius: 25,
      ),
    ],
    this.explicitMarginBetweenDropdownAndTarget = 0,
    this.onTapItemColor =
        const LinearGradient(colors: [Color(0xff63e9f2), Color(0xff65dbc2)]),
    this.transitionInDuration = const Duration(milliseconds: 100),
    this.defaultItemColor =
        const LinearGradient(colors: [Color(0xff5fbce8), Color(0xff5ffce8)]),
    this.defaultTextStyle = const TextStyle(color: Colors.white),
    this.dropdownAlignment = DropdownAlignment.bottomCenter,
    this.onTapTextStyle = const TextStyle(color: Colors.black),
    this.borderColor = const Color(0x00000000),
    this.borderThickness = 0,
    this.dropdownMaxHeight = const DropdownMaxHeight(),
    this.borderRadius = const BorderRadius.all(Radius.circular(9)),
    this.onTapColorTransitionDuration = const Duration(milliseconds: 0),
    this.widthScale = 1,
    this.width,
  });
}
