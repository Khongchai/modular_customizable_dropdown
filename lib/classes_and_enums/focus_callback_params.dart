import "package:flutter/material.dart";

class CallbackReactParams {
  final Widget Function(void Function(bool toggleState) toggleDropdown)
      targetBuilder;

  const CallbackReactParams({
    required this.targetBuilder,
  });
}
