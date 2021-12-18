import "package:flutter/material.dart";
import 'package:really_customizable_dropdown/utils/dropdown_style.dart';
import 'package:really_customizable_dropdown/utils/mode.dart';

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
  final List<String> dropdownValues;

  /// Action to perform when the value is tapped.
  final Function(String selectedValue) onValueSelect;

  /// Allows user to click outside dropdown to dismiss
  ///
  /// Setting this to false may cause the dropdown to flow over other elements while scrolling(including the appbar).
  final bool barrierDismissible;

  /// Target to attach the dropdown to
  final Widget target;

  final ReactMode reactMode;

  const ReallyCustomizableDropdown({
    required this.reactMode,
    required this.onValueSelect,
    required this.dropdownValues,
    required this.target,
    required this.barrierDismissible,
    required this.style,
    Key? key,
  }) : super(key: key);

  factory ReallyCustomizableDropdown.displayOnTap({
    required Function(String selectedValue) onValueSelect,
    required List<String> dropdownValues,
    required Widget target,
    bool barrierDismissible = true,
    DropdownStyle style = const DropdownStyle(),
    Key? key,
  }) {
    return ReallyCustomizableDropdown(
      reactMode: ReactMode.tapReact,
      onValueSelect: onValueSelect,
      dropdownValues: dropdownValues,
      target: target,
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

  final LayerLink _layerLink = LayerLink();

  bool buildOverlayEntry = true;

  List<String> valuesToDisplay = [];

  @override
  void initState() {
    valuesToDisplay = widget.dropdownValues;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (buildOverlayEntry) {
            addOverlay();
          } else {
            dismissOverlay();
          }
        },
        child: widget.target,
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

    Widget content = Positioned(
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
                itemBuilder: (context, index) =>
                    _buildDropdownRow(valuesToDisplay[index]),
              )),
        ),
      ),
    );

    Widget dismissibleWrapper({required Widget child}) =>
        widget.barrierDismissible
            ? SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(children: [
                  FullScreenDismissibleArea(dismissOverlay: dismissOverlay),
                  content,
                ]))
            : Stack(children: [content]);

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => dismissibleWrapper(child: content),
    );

    return overlayEntry;
  }

  Widget _buildDropdownRow(
    String str,
  ) {
    return ListTileThatChangesColorOnTap(
      onTap: () {
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

  void addOverlay() {
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context)!.insert(_overlayEntry);
    setState(() {
      buildOverlayEntry = false;
    });
  }

  void dismissOverlay() {
    _overlayEntry.remove();
    setState(() {
      buildOverlayEntry = true;
    });
  }
}
