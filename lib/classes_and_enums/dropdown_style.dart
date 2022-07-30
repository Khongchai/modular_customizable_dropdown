import "package:flutter/material.dart";
import 'package:modular_customizable_dropdown/classes_and_enums/dropdown_scrollbar_style.dart';

import 'dropdown_alignment.dart';
import 'dropdown_max_height.dart';
import 'dropdown_width.dart';

///To allow for both gradient and solid color, in many places, the LinearGradient class is used instead of the Color class.
///
///If a solid, single color is what you want, simply provide LinearGradient(colors: [yourSingleColor, yourSingleColor]) --
///in other words, a LinearGradient instance with the same color provided at least twice in the colors array.
class DropdownStyle {
  final Color borderColor;
  final double borderThickness;
  final BorderRadius borderRadius;
  final List<BoxShadow> boxShadows;
  final DropdownScrollbarStyle dropdownScrollbarStyle;
  final DropdownMaxHeight dropdownMaxHeight;

  ///The color of a dropdown when tapped
  final LinearGradient onTapItemColor;

  ///The dropdown itself does not have a padding, so setting this would be equivalent to setting the dropdown's background color.
  final LinearGradient defaultItemColor;

  final DropdownWidth dropdownWidth;

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

  ///Material's inkwell color.
  ///
  /// Note: this won't be very noticeable if the tile's background color is not white.
  final MaterialColor onTapInkColor;

  /// The style for the values.
  final TextStyle defaultTextStyle;

  /// The style for the descriptions.
  final TextStyle? descriptionStyle;

  final DropdownAlignment dropdownAlignment;

  /// Animation duration before the dropdown becomes fully expanded.
  final Duration transitionInDuration;

  /// Animation curve for transitionInDuration
  final Curve transitionInCurve;

  /// Whether or not to swap the alignment, for example, from bottomCenter to topCenter when
  /// the bottom of the dropdown exceeds the screen height.
  final bool invertYAxisAlignmentWhenOverflow;

  const DropdownStyle({
    this.invertYAxisAlignmentWhenOverflow = true,
    this.transitionInCurve = Curves.linear,
    this.transitionInDuration = const Duration(milliseconds: 100),
    this.boxShadows = const [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.1),
        blurRadius: 10,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: Color.fromRGBO(35, 64, 98, 0.1),
        blurRadius: 25,
      ),
    ],
    this.dropdownScrollbarStyle = const DropdownScrollbarStyle(),
    this.onTapItemColor =
        const LinearGradient(colors: [Color(0xffffffff), Color(0xefffffff)]),
    this.defaultItemColor =
        const LinearGradient(colors: [Color(0xefffffff), Color(0xefffffff)]),
    this.defaultTextStyle = const TextStyle(color: Colors.black),
    this.descriptionStyle = const TextStyle(color: Colors.grey, fontSize: 12),
    this.onTapTextStyle = const TextStyle(color: Color(0xbb000000)),
    this.onTapInkColor = _blueMat,
    this.explicitMarginBetweenDropdownAndTarget = 0,
    this.dropdownAlignment = DropdownAlignment.bottomCenter,
    this.borderColor = const Color(0x00000000),
    this.borderThickness = 0,
    this.dropdownMaxHeight = const DropdownMaxHeight(),
    this.borderRadius = const BorderRadius.all(Radius.circular(9)),
    this.onTapColorTransitionDuration = const Duration(milliseconds: 50),
    this.dropdownWidth = const DropdownWidth(),
  });

  static const MaterialColor _blueMat = MaterialColor(
    _bluePrimaryValue,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(_bluePrimaryValue),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );
  static const int _bluePrimaryValue = 0xFF2196F3;
}
