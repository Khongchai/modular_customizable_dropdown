import "package:flutter/material.dart";

///To use a solid color, pass LinearGradient(colors: [yourSingleColor, yourSingleColor]);
class ListTileThatChangesColorOnTap extends StatefulWidget {
  final VoidCallback onTap;
  final LinearGradient onTapBackgroundColor;
  final LinearGradient defaultBackgroundColor;
  final TextStyle onTapTextStyle;
  final TextStyle defaultTextStyle;
  final String title;
  final Duration onTapColorTransitionDuration;

  const ListTileThatChangesColorOnTap(
      {required this.title,
      required this.defaultTextStyle,
      required this.onTapBackgroundColor,
      required this.defaultBackgroundColor,
      required this.onTapTextStyle,
      required this.onTap,
      required this.onTapColorTransitionDuration,
      Key? key})
      : super(key: key);

  @override
  _ListTileThatChangesColorOnTapState createState() =>
      _ListTileThatChangesColorOnTapState();
}

class _ListTileThatChangesColorOnTapState
    extends State<ListTileThatChangesColorOnTap> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    final textStyle =
        isTapped ? widget.onTapTextStyle : widget.defaultTextStyle;

    final backgroundGradient =
        isTapped ? widget.onTapBackgroundColor : widget.defaultBackgroundColor;

    final text = Text(
      widget.title,
      textAlign: TextAlign.start,
      style: textStyle,
    );

    final tile = TextButton(
        onPressed: () {
          widget.onTap();
        },
        child: text,
        style: ButtonStyle(
            alignment: Alignment.centerLeft,
            padding:
                MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(14)),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap));

    final container = AnimatedContainer(
        duration: widget.onTapColorTransitionDuration,
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: tile);

    return Listener(
        onPointerDown: (_) => isTapping(),
        onPointerUp: (_) {
          cancelTapping();
        },
        onPointerCancel: (_) => cancelTapping(),
        child: container);
  }

  void isTapping() {
    setState(() {
      isTapped = true;
    });
  }

  void cancelTapping() {
    setState(() {
      isTapped = false;
    });
  }
}
