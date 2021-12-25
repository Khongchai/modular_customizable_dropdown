import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:modular_customizable_dropdown/widgets/filter_capable_listview.dart';

import '../classes_and_enums/dropdown_style.dart';
import '../classes_and_enums/focus_react_params.dart';
import '../classes_and_enums/mode.dart';
import '../classes_and_enums/tap_react_params.dart';
import 'full_screen_dismissible_area.dart';
import 'list_tile_that_changes_color_on_tap.dart';

/// A dropdown extension for any widget.
///
/// Pass any widget as the _target_ of this dropdown, and the dropdown will automagically appear below
/// the widget when you click on it!
class ModularCustomizableDropdown extends StatefulWidget {
  final DropdownStyle dropdownStyle;

  /// When the asTextFieldDropdown factory constructor is called, dropdown will allow
  /// an additional ability to filter the list based on the textController's value.
  final List<String> allDropdownValues;

  /// Action to perform when the value is tapped.
  final Function(String selectedValue) onValueSelect;

  /// Allows user to click outside dropdown to dismiss
  ///
  /// Setting this to false may cause the dropdown to flow over other elements while scrolling(including the appbar).
  ///
  /// So, most of the time, pass true. Pass false when you wanna test something.
  final bool barrierDismissible;

  ///Declare mode separately for explicitness.
  final ReactMode reactMode;
  final TapReactParams? tapReactParams;
  final FocusReactParams? focusReactParams;

  ///Whether to expose the function for calling dropdown in the target builder function
  final bool exposeDropdownHandler;

  const ModularCustomizableDropdown({
    required this.reactMode,
    required this.onValueSelect,
    required this.allDropdownValues,
    required this.barrierDismissible,
    required this.exposeDropdownHandler,
    required this.dropdownStyle,
    this.tapReactParams,
    this.focusReactParams,
    Key? key,
  })  : assert((tapReactParams != null && reactMode == ReactMode.tapReact) ||
            (focusReactParams != null && reactMode == ReactMode.focusReact)),
        super(key: key);

  factory ModularCustomizableDropdown.displayOnTap({
    required Function(String selectedValue) onValueSelect,
    required List<String> allDropdownValues,
    required Widget target,
    bool barrierDismissible = true,
    DropdownStyle style = const DropdownStyle(),
    Key? key,
  }) {
    return ModularCustomizableDropdown(
      reactMode: ReactMode.tapReact,
      onValueSelect: onValueSelect,
      allDropdownValues: allDropdownValues,
      tapReactParams: TapReactParams(target: target),
      dropdownStyle: style,
      barrierDismissible: barrierDismissible,
      exposeDropdownHandler: false,
    );
  }

  factory ModularCustomizableDropdown.displayOnFocus({
    required Function(String selectedValue) onValueSelect,
    required List<String> allDropdownValues,
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
    return ModularCustomizableDropdown(
      reactMode: ReactMode.focusReact,
      onValueSelect: onValueSelect,
      allDropdownValues: allDropdownValues,
      focusReactParams: FocusReactParams(
          textController: textController,
          focusNode: focusNode,
          setTextToControllerOnSelect: setTextToControllerOnSelect,
          targetBuilder: targetBuilder),
      dropdownStyle: style,
      barrierDismissible: barrierDismissible,
      exposeDropdownHandler: false,
    );
  }

  //TODO expose a function for displaying the dropdown manually
  // factory ModularCustomizableDropdown.customControl({})

  @override
  _ModularCustomizableDropdownState createState() =>
      _ModularCustomizableDropdownState();
}

class _ModularCustomizableDropdownState
    extends State<ModularCustomizableDropdown> {
  late OverlayEntry _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  bool buildOverlayEntry = true;

  List<String> _valuesToDisplay = [];

  bool pointerDown = false;

  bool beginQuerying = false;

  @override
  void initState() {
    if (widget.reactMode == ReactMode.focusReact) {
      widget.focusReactParams!.focusNode.addListener(() {
        if (widget.focusReactParams!.focusNode.hasFocus) {
          buildAndAddOverlay();
        } else {
          _overlayEntry.remove();
        }
      });

      // widget.focusReactParams!.textController.addListener(() {
      //   _valuesToDisplay = filterOutValuesThatDoNotMatchQueryString(
      //       queryString: widget.focusReactParams!.textController.text,
      //       valuesToFilter: widget.allDropdownValues);
      // });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
        link: _layerLink,
        child: Listener(
          //TODO check what happens to all the focus based components
          //Using pointer down and up to create a custom onTap event.
          //This allow the child to still react to pointer events and call functions or display animations
          //while still showing dropdowns.
          onPointerDown: (_) {
            setState(() => pointerDown = true);
          },
          onPointerUp: (_) {
            if (buildOverlayEntry) {
              buildAndAddOverlay();
            } else {
              dismissOverlay();
            }
            setState(() => pointerDown = false);
          },
          child: widget.reactMode == ReactMode.tapReact
              ? widget.tapReactParams!.target
              : widget.focusReactParams!.targetBuilder(
                  widget.focusReactParams!.focusNode,
                  widget.focusReactParams!.textController),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  OverlayEntry _buildOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    final alignment = widget.dropdownStyle.dropdownAlignment.x;
    final width = widget.dropdownStyle.width ?? size.width;
    final dropdownWidth = (width) * widget.dropdownStyle.widthScale;
    final diff = ((dropdownWidth - size.width) / 2);
    final centerOffset = -diff + (diff * alignment * -1);

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
        width: dropdownWidth,
        child: CompositedTransformFollower(
          offset: Offset(
              centerOffset, size.height + widget.dropdownStyle.topMargin),
          link: _layerLink,
          showWhenUnlinked: false,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: widget.dropdownStyle.borderRadius,
              boxShadow: widget.dropdownStyle.boxShadow,
            ),
            constraints: BoxConstraints(
              maxHeight: widget.dropdownStyle.maxHeight,
            ),
            child: Material(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: widget.dropdownStyle.borderRadius,
                  side: BorderSide(
                    width: widget.dropdownStyle.borderThickness,
                    style: BorderStyle.solid,
                    color: widget.dropdownStyle.borderColor,
                  )),
              color: Colors.transparent,
              elevation: 0,
              child: FilterCapableListView(
                allDropdownValues: widget.allDropdownValues,
                listBuilder: (dropdownValue) =>
                    _buildDropdownRow(dropdownValue),
                queryString: widget.focusReactParams?.textController.text ?? "",
              ),
            ),
          ),
        ),
      )),
    );
  }

  _buildDropdownRow(
    String str,
  ) {
    return ListTileThatChangesColorOnTap(
      onTap: () {
        if (widget.reactMode == ReactMode.focusReact &&
            widget.focusReactParams!.setTextToControllerOnSelect) {
          widget.focusReactParams!.textController.text = str;
        }
        widget.onValueSelect(str);
        if (widget.dropdownStyle.collapseOnSelect) {
          dismissOverlay();
        }
      },
      onTapColorTransitionDuration:
          widget.dropdownStyle.onTapColorTransitionDuration,
      defaultBackgroundColor: widget.dropdownStyle.defaultItemColor,
      onTapBackgroundColor: widget.dropdownStyle.onTapItemColor,
      defaultTextStyle: widget.dropdownStyle.defaultTextStyle,
      onTapTextStyle: widget.dropdownStyle.onTapTextStyle,
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
