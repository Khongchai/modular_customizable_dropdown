import 'dart:math';

import 'package:modular_customizable_dropdown/classes_and_enums/clamp_result.dart';

ClampResult clampDropdownHeightToPreventScreenOverflow({
  /// Make sure that the passed in offset has already gone through the y inversion
  /// check.
  required double inversionCheckedAbsoluteDropdownTopPos,
  required double dropdownHeight,
  required double screenHeight,
}) {
  final topSubtract = max(0, inversionCheckedAbsoluteDropdownTopPos) -
      inversionCheckedAbsoluteDropdownTopPos;

  final inversionCheckedAbsoluteDropdownBottomPos =
      inversionCheckedAbsoluteDropdownTopPos + dropdownHeight;
  final bottomSubtract =
      min(screenHeight, inversionCheckedAbsoluteDropdownBottomPos) -
          inversionCheckedAbsoluteDropdownBottomPos;

  final ySubtract = topSubtract + bottomSubtract;

  final overflowCheckedHeight = dropdownHeight - ySubtract.abs();

  return ClampResult(
      overflowCheckedHeight: overflowCheckedHeight, topSubtract: topSubtract);
}
