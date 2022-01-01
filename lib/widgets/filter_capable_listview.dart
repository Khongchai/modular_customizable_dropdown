import 'dart:math';

import "package:flutter/material.dart";
import 'package:modular_customizable_dropdown/classes_and_enums/dropdown_alignment.dart';
import 'package:modular_customizable_dropdown/utils/filter_out_values_that_do_not_match_query_string.dart';

class FilterCapableListView extends StatefulWidget {
  final List<String> allDropdownValues;
  final String queryString;
  final Widget Function(String dropdownValue) listBuilder;

  ///The alignment is used to calculate the center point for the animated
  ///height transition.
  ///
  /// For example, if the y alignment is DropdownAlignment.center,
  /// the dropdown should begin its animation at the center and expand upward and downward.
  ///
  /// If the alignment is DropdownAlignment.bottomCenter, bottomLeft, or bottomRight,
  /// the animation should begin from the y == 0 position of the dropdown and expand its height downward.
  final DropdownAlignment dropdownAlignment;

  ///Height to animate to
  final double expectedDropdownHeight;
  final double targetWidth;
  const FilterCapableListView(
      {required this.allDropdownValues,
      required this.queryString,
      required this.listBuilder,
      required this.expectedDropdownHeight,
      required this.targetWidth,
      required this.dropdownAlignment,
      Key? key})
      : super(key: key);

  @override
  State<FilterCapableListView> createState() => _FilterCapableListViewState();
}

class _FilterCapableListViewState extends State<FilterCapableListView> {
  double _expectedHeight = 0;

  ///TODO refactor this out as one of the params
  static const _animationDuration = Duration(milliseconds: 100);
  late final double _animationStartPosition;

  @override
  void initState() {
    _animationStartPosition = min(max(widget.dropdownAlignment.y, -1), 1) * -1;
    Future.delayed(const Duration(milliseconds: 0), () {
      setState(() {
        _expectedHeight = widget.expectedDropdownHeight;
      });
    });
    super.initState();
  }

  ///TODO, once the animation works, refactor the widget with boxshadow to this file
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _expectedHeight,
      width: widget.targetWidth,
      child: Stack(
        alignment: AlignmentDirectional(0, _animationStartPosition),
        children: [
          AnimatedContainer(
            height: _expectedHeight,
            curve: Curves.easeIn,
            duration: _animationDuration,
            child: ListView.builder(
                itemCount: widget.allDropdownValues.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (filterOutValueThatDoNotMatchQueryString(
                      queryString: widget.queryString,
                      valueToFilter: widget.allDropdownValues[index])) {
                    return widget.listBuilder(widget.allDropdownValues[index]);
                  }
                  return const SizedBox();
                }),
          ),
        ],
      ),
    );
  }
}
