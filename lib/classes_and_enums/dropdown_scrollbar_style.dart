import 'dart:ui';

///A hand-picked params from the official RawScrollbar's params
///
/// Refer to the official docs for the full documentation.
///
///https://api.flutter.dev/flutter/widgets/RawScrollbar-class.html
class DropdownScrollbarStyle {
  final bool isAlwaysShown;
  final Radius radius;
  final double thickness;
  final Color thumbColor;
  final double minThumbLength;
  final bool interactive;

  const DropdownScrollbarStyle({
    this.isAlwaysShown = false,
    this.radius = const Radius.circular(10),
    this.thickness = 5,
    this.thumbColor = const Color(0xaa000000),
    this.minThumbLength = 18,
    this.interactive = false,
  });
}
