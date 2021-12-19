import "package:flutter/material.dart";
import 'package:really_customizable_dropdown/classes_and_enums/focus_react_params.dart';
import 'package:really_customizable_dropdown/classes_and_enums/mode.dart';
import 'package:really_customizable_dropdown/utils/filter_out_values_that_do_not_match_query_string.dart';

///Mode-based action for the dropdown
class DropdownActionRepository {
  final ReactMode reactMode;
  final void Function(void Function() fn) setState;

  DropdownActionRepository({
    required this.reactMode,
    required this.setState,
  });

  initState({
    required List<String> valuesToDisplay,
    required List<String> allDropdownValues,
    required VoidCallback dismissOverlay,
    required VoidCallback buildAndAddOverlay,
    FocusReactParams? focusReactParams,
  }) {
    if (reactMode == ReactMode.tapReact) {
      setState(() {
        valuesToDisplay = allDropdownValues;
      });
    } else {
      focusReactParams!.focusNode.addListener(() {
        if (focusReactParams.focusNode.hasFocus) {
          buildAndAddOverlay();
        } else {
          dismissOverlay();
        }
      });

      focusReactParams.textController.addListener(() {
        setState(() {
          valuesToDisplay = filterOutValuesThatDoNotMatchQueryString(
              queryString: focusReactParams.textController.text,
              valuesToFilter: allDropdownValues);
        });
      });
    }
  }
}
