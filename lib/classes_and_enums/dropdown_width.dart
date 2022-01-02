class DropdownWidth {
  /// Will scale its width relative to the parent widget.
  ///
  /// This is the default behavior.
  final double scale;

  /// Will size itself according to the provided pixels.
  ///
  /// The scale property will be ignored if this is provided.
  final double? byPixels;

  const DropdownWidth({this.scale = 1, this.byPixels});
}
