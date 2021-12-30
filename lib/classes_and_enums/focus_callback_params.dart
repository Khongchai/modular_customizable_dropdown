import "package:flutter/material.dart";

class FocusCallbackParams {
  final Widget Function(VoidCallback toggleDropdown) targetBuilder;

  const FocusCallbackParams({
    required this.targetBuilder,
  });
}
