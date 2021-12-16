import "package:flutter/material.dart";

class FullScreenDismissibleArea extends StatelessWidget {
  final VoidCallback dismissOverlay;
  const FullScreenDismissibleArea({required this.dismissOverlay, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GestureDetector(
        onTap: dismissOverlay,
        child: Container(
          color: Colors.transparent,
          width: 1 / 0,
          height: 1 / 0,
        ),
      ),
    );
  }
}
