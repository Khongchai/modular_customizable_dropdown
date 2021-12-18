import "package:flutter/material.dart";
import 'package:really_customizable_dropdown/utils/filter_out_values_that_do_not_match_query_string.dart';

import 'widgets/full_screen_dismissible_area.dart';
import 'widgets/list_tile_that_changes_color_on_tap.dart';

///A dropdown extension for a text widget.
///
/// Instead of a tap-based overlay, this widget displays the dropdown based on the focus state of the target
/// text input.
///
/// Do not explicitly pass the focusNode and textController to your textField, rather, use
/// the one passes by this dropdown instead. This is to ensure that the dropdown and the target
/// share the same focus node and controller.
///
///To allow for both gradient and solid color, in many places, the LinearGradient class is used instead of the Color class.
///
///If a solid, single color is what you want, simply provide LinearGradient(colors: [yourSingleColor, yourSingleColor]) --
///in other words, a LinearGradient instance with the same color provided at least twice in the colors array.
class ReallyCustomizableTextDropdown extends StatefulWidget {
  final Color borderColor;
  final double borderThickness;
  final List<String> dropdownValues;
  final Function(String selectedValue) onValueSelect;
  final BorderRadius borderRadius;
  final List<BoxShadow> boxShadow;

  ///Space between the dropdown and the target widget.
  final double topMargin;

  ///Your standard material elevation.
  final double elevation;

  ///If not given, the dropdown will grow to be as large as the child needs.
  final double maxHeight;

  ///Whether or not to collapse the dropdown when a value is selected.
  final bool collapseOnSelect;

  ///Allows user to click outside dropdown to dismiss
  ///
  ///Setting this to false may cause the dropdown to flow over other elements while scrolling(including the appbar).
  final bool barrierDismissible;

  ///The color of a dropdown when tapped
  final LinearGradient onTapItemColor;

  ///The dropdown itself does not have a padding, so setting this would be equivalent to setting the dropdown's background color.
  final LinearGradient defaultItemColor;

  final TextStyle defaultTextStyle;

  ///Style for dropdown text when tapped
  final TextStyle onTapTextStyle;

  final Widget Function(
      FocusNode focusNode, TextEditingController textController) targetBuilder;
  final TextEditingController textController;
  final FocusNode focusNode;
  final bool setTextToControllerOnSelect;

  const ReallyCustomizableTextDropdown({
    required this.onValueSelect,
    required this.dropdownValues,
    required this.targetBuilder,
    required this.focusNode,
    required this.textController,
    required this.setTextToControllerOnSelect,
    this.boxShadow = const [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        blurRadius: 10,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: Color.fromRGBO(35, 64, 98, 0.5),
        blurRadius: 25,
      ),
    ],
    this.onTapItemColor =
        const LinearGradient(colors: [Color(0xff63e9f2), Color(0xff65dbc2)]),
    this.defaultItemColor =
        const LinearGradient(colors: [Color(0xff5fbce8), Color(0xff5ffce8)]),
    this.defaultTextStyle = const TextStyle(color: Colors.white),
    this.onTapTextStyle = const TextStyle(color: Colors.black),
    this.elevation = 3,
    this.borderColor = const Color(0x00000000),
    this.borderThickness = 0,
    this.maxHeight = 200,
    this.collapseOnSelect = true,
    this.topMargin = 0,
    this.barrierDismissible = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(9)),
    Key? key,
  }) : super(key: key);

  @override
  _ReallyCustomizableTextDropdownState createState() =>
      _ReallyCustomizableTextDropdownState();
}

class _ReallyCustomizableTextDropdownState
    extends State<ReallyCustomizableTextDropdown> {
  late OverlayEntry _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  List<String> _valuesToDisplay = [];

  @override
  void initState() {
    super.initState();

    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        buildAndAddOverlay();
      } else {
        _overlayEntry.remove();
      }
    });

    widget.textController.addListener(() {
      setState(() {
        _valuesToDisplay = filterOutValuesThatDoNotMatchQueryString(
            queryString: widget.textController.text,
            valuesToFilter: widget.dropdownValues);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
        link: _layerLink,
        child: widget.targetBuilder(widget.focusNode, widget.textController));
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
          offset: Offset(0, size.height + widget.topMargin),
          link: _layerLink,
          showWhenUnlinked: false,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              boxShadow: widget.boxShadow,
            ),
            constraints: BoxConstraints(
              maxHeight: widget.maxHeight,
            ),
            child: Material(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: widget.borderRadius,
                    side: BorderSide(
                      width: widget.borderThickness,
                      style: BorderStyle.solid,
                      color: widget.borderColor,
                    )),
                color: Colors.transparent,
                elevation: 0,
                child: ListView.builder(
                    itemCount: _valuesToDisplay.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return _buildDropdownRow(_valuesToDisplay[index]);
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
        if (widget.setTextToControllerOnSelect) {
          widget.textController.text = str;
        }

        widget.onValueSelect(str);

        if (widget.collapseOnSelect) {
          FocusScope.of(context).unfocus();
        }
      },
      defaultBackgroundColor: widget.defaultItemColor,
      onTapBackgroundColor: widget.onTapItemColor,
      defaultTextStyle: widget.defaultTextStyle,
      onTapTextStyle: widget.onTapTextStyle,
      title: str,
    );
  }

  void buildAndAddOverlay() {
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context)!.insert(_overlayEntry);
  }

  void dismissOverlay() {
    widget.focusNode.unfocus();
  }
}
