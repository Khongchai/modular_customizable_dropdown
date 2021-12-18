import "package:flutter/material.dart";
import 'package:really_customizable_dropdown/utils/dropdown_style.dart';

import 'widgets/full_screen_dismissible_area.dart';
import 'widgets/list_tile_that_changes_color_on_tap.dart';

///A dropdown extension for any widget.
///
///Pass any widget as the _target_ of this dropdown, and the dropdown will automagically appear below
///the widget when you click on it!
///
///To allow for both gradient and solid color, in many places, the LinearGradient class is used instead of the Color class.
///
///If a solid, single color is what you want, simply provide LinearGradient(colors: [yourSingleColor, yourSingleColor]) --
///in other words, a LinearGradient instance with the same color provided at least twice in the colors array.
class ReallyCustomizableDropdown extends StatefulWidget {
  final List<String> dropdownValues;
  final Function(String selectedValue) onValueSelect;

  ///Allows user to click outside dropdown to dismiss
  ///
  ///Setting this to false may cause the dropdown to flow over other elements while scrolling(including the appbar).
  final bool barrierDismissible;

  ///Target to attach the dropdown to
  final Widget target;

  final DropdownStyle style;

  const ReallyCustomizableDropdown({
    required this.onValueSelect,
    required this.dropdownValues,
    required this.target,
    this.barrierDismissible = true,
    this.style = const DropdownStyle(),
    Key? key,
  }) : super(key: key);

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
