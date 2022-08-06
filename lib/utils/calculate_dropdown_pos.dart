import 'package:flutter/cupertino.dart';
import 'package:modular_customizable_dropdown/classes_and_enums/vector2.dart';

Vector2 calculateDropdownPos({
  required double targetWidth,
  required double targetHeight,
  required double dropdownHeight,
  required double dropdownWidth,
  required Alignment alignment,
  required double targetAbsoluteY,
  required double screenHeight,
  required bool invertYAxisAlignmentWhenOverflow,
}) {
  //Calculate x alignment
  final xAlignment = alignment.x;
  final xCenter = ((dropdownWidth - targetWidth) / 2);
  final dropdownRelativeXOffset = (xCenter * -xAlignment) - xCenter;

  //Calculate y alignment
  final yAlignment = alignment.y;
  final yCenter = dropdownHeight / 2 + targetHeight / 2;
  //For y values, 1 unit of alignment equals half of the dropdown height + half of target's height.
  final yOffset = yCenter * yAlignment;
  final dropdownRelativeYOffset = targetHeight -
      yCenter +
      yOffset; //<< everything after this is just to calculate the wrap around

  final dropdownAbsoluteYOffset = targetAbsoluteY + dropdownRelativeYOffset;
  final dropdownBottomPos = dropdownAbsoluteYOffset + dropdownHeight;

  //Once threshold exceeded,
  //invert the y alignment if invertYAxisAlignmentWhenOverflow == true
  const screenTop = 0;
  final isYOverflow =
      dropdownBottomPos > screenHeight || dropdownAbsoluteYOffset < screenTop;

  final wrapAroundCalculatedDropdownYPos =
      isYOverflow && invertYAxisAlignmentWhenOverflow
          ? targetHeight - yCenter + (yCenter * -yAlignment)
          : targetHeight - yCenter + (yCenter * yAlignment);

  return Vector2(dropdownRelativeXOffset, wrapAroundCalculatedDropdownYPos,
      isYOverflow && invertYAxisAlignmentWhenOverflow);
}
