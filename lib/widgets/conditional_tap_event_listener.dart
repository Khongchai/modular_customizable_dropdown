import "package:flutter/material.dart";
import 'package:modular_customizable_dropdown/classes_and_enums/mode.dart';

class ConditionalTapEventListener extends StatefulWidget {
  final Widget listenerChild;
  final ReactMode reactMode;
  final VoidCallback onTap;
  const ConditionalTapEventListener(
      {required this.onTap,
      required this.reactMode,
      required this.listenerChild,
      Key? key})
      : super(key: key);

  @override
  State<ConditionalTapEventListener> createState() =>
      _ConditionalTapEventListenerState();
}

class _ConditionalTapEventListenerState
    extends State<ConditionalTapEventListener> {
  bool pointerDown = false;
  @override
  Widget build(BuildContext context) {
    if (widget.reactMode != ReactMode.tapReact) {
      return widget.listenerChild;
    } else {
      return Listener(
          onPointerDown: (_) {
            setState(() => pointerDown = true);
          },
          onPointerCancel: (_) => setState(() {
                pointerDown = false;
              }),
          onPointerUp: (_) {
            setState(() => pointerDown = false);
            widget.onTap();
          },
          child: widget.listenerChild);
    }
  }
}
