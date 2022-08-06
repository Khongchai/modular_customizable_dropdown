/// The value property is what you see when the dropdown is expanded,
///
/// with the optional description being the text below.
class DropdownValue {
  final String value;

  /// This goes under the dropdown value when the dropdown is expanded.
  final String? description;

  /// Any additional data:
  ///
  /// ```dart
  ///
  /// onValueSelect: (selectedValue) {
  ///   _pageTitle = selectedValue.value;
  ///   _pageDescription = selectedValue.description;
  ///   _pageBody = selectedValue.metadata as String;
  /// }
  ///
  /// ```
  final dynamic metadata;

  const DropdownValue({
    required this.value,
    this.description,
    this.metadata,
  });

  /// A simple static helper to help with when you don't need the descriptions.
  ///
  /// Without using this helper
  /// ```dart
  ///    ModularCustomizableDropdown.displayOnCallback(
  ///           onValueSelect: widget.onValueSelect,
  ///           allDropdownValues: widget.dropdownValues
  ///               .map((e) => DropdownValue(
  ///                     value: e,
  ///                   ))
  ///               .toList(),
  ///     ...
  /// ```
  ///
  /// With this helper
  /// ```dart
  ///    ModularCustomizableDropdown.displayOnCallback(
  ///           onValueSelect: widget.onValueSelect,
  ///           allDropdownValues: DropdownValue
  ///               .fromListOfStrings(widget.dropdownValues)
  ///     ...
  /// ```
  static fromListOfStrings(List<String> values) {
    return values.map((e) => DropdownValue(value: e)).toList();
  }
}
