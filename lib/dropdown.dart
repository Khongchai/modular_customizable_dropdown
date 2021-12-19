import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:really_customizable_dropdown/classes_and_enums/dropdown_action_repository.dart';
import 'package:really_customizable_dropdown/classes_and_enums/dropdown_style.dart';
import 'package:really_customizable_dropdown/classes_and_enums/focus_react_params.dart';
import 'package:really_customizable_dropdown/classes_and_enums/mode.dart';
import 'package:really_customizable_dropdown/classes_and_enums/tap_react_params.dart';
import 'package:really_customizable_dropdown/utils/filter_out_values_that_do_not_match_query_string.dart';

import 'widgets/full_screen_dismissible_area.dart';
import 'widgets/list_tile_that_changes_color_on_tap.dart';

/// A dropdown extension for any widget.
///
/// Pass any widget as the _target_ of this dropdown, and the dropdown will automagically appear below
/// the widget when you click on it!
class ReallyCustomizableDropdown extends StatefulWidget {
  final DropdownStyle style;

  /// When the asTextFieldDropdown factory constructor is called, dropdown will allow
  /// an additional ability to filter the list based on the textController's value.
  final List<String> allDropdownValues;

  /// Action to perform when the value is tapped.
  final Function(String selectedValue) onValueSelect;

  /// Allows user to click outside dropdown to dismiss
  ///
  /// Setting this to false may cause the dropdown to flow over other elements while scrolling(including the appbar).
  final bool barrierDismissible;

  ///Declare mode separately for explicitness.
  final ReactMode reactMode;
  final TapReactParams? tapReactParams;
  final FocusReactParams? focusReactParams;

  const ReallyCustomizableDropdown({
    required this.reactMode,
    required this.onValueSelect,
    required this.allDropdownValues,
    required this.barrierDismissible,
    required this.style,
    this.tapReactParams,
    this.focusReactParams,
    Key? key,
  })  : assert((tapReactParams != null && reactMode == ReactMode.tapReact) ||
            (focusReactParams != null && reactMode == ReactMode.focusReact)),
        super(key: key);

  factory ReallyCustomizableDropdown.displayOnTap({
    required Function(String selectedValue) onValueSelect,
    required List<String> allDropdownValues,
    required Widget target,
    bool barrierDismissible = true,
    DropdownStyle style = const DropdownStyle(),
    Key? key,
  }) {
    return ReallyCustomizableDropdown(
      reactMode: ReactMode.tapReact,
      onValueSelect: onValueSelect,
      allDropdownValues: allDropdownValues,
      tapReactParams: TapReactParams(target: target),
      style: style,
      barrierDismissible: barrierDismissible,
    );
  }

  factory ReallyCustomizableDropdown.displayOnFocus({
    required Function(String selectedValue) onValueSelect,
    required List<String> dropdownValues,
    required Widget Function(
            FocusNode focusNode, TextEditingController textController)
        targetBuilder,
    required TextEditingController textController,
    required FocusNode focusNode,
    required bool setTextToControllerOnSelect,
    bool barrierDismissible = true,
    DropdownStyle style = const DropdownStyle(),
    Key? key,
  }) {
    return ReallyCustomizableDropdown(
      reactMode: ReactMode.focusReact,
      onValueSelect: onValueSelect,
      allDropdownValues: dropdownValues,
      focusReactParams: FocusReactParams(
          textController: textController,
          focusNode: focusNode,
          setTextToControllerOnSelect: setTextToControllerOnSelect,
          targetBuilder: targetBuilder),
      style: style,
      barrierDismissible: barrierDismissible,
    );
  }

  @override
  _ReallyCustomizableDropdownState createState() =>
      _ReallyCustomizableDropdownState();
}

class _ReallyCustomizableDropdownState
    extends State<ReallyCustomizableDropdown> {
  late OverlayEntry _overlayEntry;

  late final DropdownActionRepository dropdownActionRepository;

  final LayerLink _layerLink = LayerLink();

  bool buildOverlayEntry = true;

  List<String> valuesToDisplay = [];

  @override
  void initState() {
    // dropdownActionRepository = DropdownActionRepository(
    //     reactMode: widget.reactMode,
    //     setState: (fn) => setState(() {
    //           fn();
    //         }));
    // dropdownActionRepository.initState(
    //     valuesToDisplay: valuesToDisplay,
    //     allDropdownValues: widget.allDropdownValues,
    //     dismissOverlay: dismissOverlay,
    //     buildAndAddOverlay: buildAndAddOverlay);
    if (widget.reactMode == ReactMode.tapReact) {
      valuesToDisplay = widget.allDropdownValues;
    } else {
      widget.focusReactParams!.focusNode.addListener(() {
        if (widget.focusReactParams!.focusNode.hasFocus) {
          buildAndAddOverlay();
        } else {
          _overlayEntry.remove();
        }
      });

      widget.focusReactParams!.textController.addListener(() {
        valuesToDisplay = filterOutValuesThatDoNotMatchQueryString(
            queryString: widget.focusReactParams!.textController.text,
            valuesToFilter: widget.allDropdownValues);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (buildOverlayEntry) {
            buildAndAddOverlay();
          } else {
            dismissOverlay();
          }
        },
        child: widget.reactMode == ReactMode.tapReact
            ? widget.tapReactParams!.target
            : widget.focusReactParams!.targetBuilder(
                widget.focusReactParams!.focusNode,
                widget.focusReactParams!.textController),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  OverlayEntry _buildOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    Widget dismissibleWrapper({required Widget child}) =>
        widget.barrierDismissible
            ? SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(children: [
                  FullScreenDismissibleArea(dismissOverlay: dismissOverlay),
                  child,
                ]))
            : Stack(children: [child]);

    return OverlayEntry(
      builder: (context) => dismissibleWrapper(
          child: Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          offset: Offset(0, size.height + widget.style.topMargin),
          link: _layerLink,
          showWhenUnlinked: false,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: widget.style.borderRadius,
              boxShadow: widget.style.boxShadow,
            ),
            constraints: BoxConstraints(
              maxHeight: widget.style.maxHeight,
            ),
            child: Material(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: widget.style.borderRadius,
                    side: BorderSide(
                      width: widget.style.borderThickness,
                      style: BorderStyle.solid,
                      color: widget.style.borderColor,
                    )),
                color: Colors.transparent,
                elevation: 0,
                child: ListView.builder(
                    itemCount: valuesToDisplay.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return _buildDropdownRow(valuesToDisplay[index]);
                    })),
          ),
        ),
      )),
    );
  }

  Widget _buildDropdownRow(
    String str,
  ) {
    return ListTileThatChangesColorOnTap(
      onTap: () {
        if (widget.reactMode == ReactMode.focusReact &&
            widget.focusReactParams!.setTextToControllerOnSelect) {
          widget.focusReactParams!.textController.text = str;
        }
        widget.onValueSelect(str);
        if (widget.style.collapseOnSelect) {
          dismissOverlay();
        }
      },
      defaultBackgroundColor: widget.style.defaultItemColor,
      onTapBackgroundColor: widget.style.onTapItemColor,
      defaultTextStyle: widget.style.defaultTextStyle,
      onTapTextStyle: widget.style.onTapTextStyle,
      title: str,
    );
  }

  void buildAndAddOverlay() {
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context)!.insert(_overlayEntry);
    setState(() {
      buildOverlayEntry = false;
    });
  }

  void dismissOverlay() {
    if (widget.reactMode == ReactMode.tapReact) {
      _overlayEntry.remove();
      setState(() {
        buildOverlayEntry = true;
      });
    } else {
      widget.focusReactParams!.focusNode.unfocus();
    }
  }
}
