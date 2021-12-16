import "package:flutter/material.dart";

class AnimatedTextFieldTrailingArrow extends StatefulWidget {
  final Widget trailingIcon;
  final bool rotate;

  const AnimatedTextFieldTrailingArrow(
      {required this.rotate, required this.trailingIcon, Key? key})
      : super(key: key);

  @override
  _AnimatedTextFieldTrailingArrowState createState() =>
      _AnimatedTextFieldTrailingArrowState();
}

class _AnimatedTextFieldTrailingArrowState
    extends State<AnimatedTextFieldTrailingArrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _rotateAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rotate) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    return GestureDetector(
      child: RotationTransition(
          turns: _rotateAnimation, child: widget.trailingIcon),
    );
  }
}
