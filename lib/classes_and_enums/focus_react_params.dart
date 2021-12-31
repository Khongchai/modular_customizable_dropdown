import "package:flutter/material.dart";

class FocusReactParams {
  ///targetBuilder is essential for triggering markNeedsBuild on the dropdown
  final Widget Function(
      FocusNode focusNode, TextEditingController textController) targetBuilder;
  final TextEditingController textController;
  final FocusNode focusNode;
  final bool setTextToControllerOnSelect;

  const FocusReactParams({
    required this.targetBuilder,
    required this.focusNode,
    required this.textController,
    required this.setTextToControllerOnSelect,
  });
}
