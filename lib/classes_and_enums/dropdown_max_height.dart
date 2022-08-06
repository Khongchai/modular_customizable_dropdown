class DropdownMaxHeight {
  ///Define the max height of the dropdown using the number of dropdown rows,
  ///for example, if byRows = 3, the height of the dropdown will be equal to the height
  ///of three rows. The user will have to scroll if the list grows larger.
  ///
  /// This will be ignored if byPixels is provided
  ///
  /// This is double because sometimes, you don't want, for example, 5 exact rows,
  /// but something more like 5.5 (only show half of the 6th rows) just to let the
  /// user know  that the dropdown is scrollable -- that there is more stuff below.
  final double byRows;

  ///Define the max height of the dropdown using explicit pixels, for example, byPixels = 300,
  ///and the dropdown won't grow taller than 300 pixels
  ///
  /// byRows will be ignored if this params is provided
  final double? byPixels;

  const DropdownMaxHeight({this.byRows = 5, this.byPixels});
}
