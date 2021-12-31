import 'dart:math';

import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:modular_customizable_dropdown/classes_and_enums/focus_callback_params.dart';
import 'package:modular_customizable_dropdown/utils/calculate_dropdown_pos.dart';
import 'package:modular_customizable_dropdown/widgets/conditional_tap_event_listener.dart';
import 'package:modular_customizable_dropdown/widgets/filter_capable_listview.dart';

import '../classes_and_enums/dropdown_style.dart';
import '../classes_and_enums/focus_react_params.dart';
import '../classes_and_enums/mode.dart';
import '../classes_and_enums/tap_react_params.dart';
import 'full_screen_dismissible_area.dart';
import 'list_tile_that_changes_color_on_tap.dart';

/// A dropdown extension for any widget.
///
/// I have provided two simple factory constructors to help you get started,
/// but you are welcome to assemble your own using the component's constructor.
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

  ///Dispose dropdown on value select?
  final bool collapseOnSelect;

  ///Declare mode separately for explicitness.
  final ReactMode reactMode;
  final TapReactParams? tapReactParams;
  final FocusReactParams? focusReactParams;
  final CallbackReactParams? callbackReactParams;

  final void Function(bool visible)? onDropdownVisibilityChange;

  ///Whether or not to swap the alignment, for example, from bottomCenter to topCenter when
  ///the bottom of the dropdown exceeds the screen height.
  final bool invertYAxisAlignmentWhenOverflow;

  const ModularCustomizableDropdown({
    required this.reactMode,
    required this.onValueSelect,
    required this.allDropdownValues,
    required this.barrierDismissible,
    required this.dropdownStyle,
    required this.invertYAxisAlignmentWhenOverflow,
    required this.collapseOnSelect,
    this.onDropdownVisibilityChange,
    this.callbackReactParams,
    this.tapReactParams,
    this.focusReactParams,
    Key? key,
  })  : assert((tapReactParams != null && reactMode == ReactMode.tapReact) ||
            (focusReactParams != null && reactMode == ReactMode.focusReact) ||
            (callbackReactParams != null &&
                reactMode == ReactMode.callbackReact)),
        super(key: key);

  ///Automatically displays the dropdown when the target is clicked
  factory ModularCustomizableDropdown.displayOnTap({
    required Function(String selectedValue) onValueSelect,
    required List<String> allDropdownValues,
    required Widget target,
    Function(bool)? onDropdownVisible,
    bool invertYAxisAlignmentWhenOverflow = false,
    bool barrierDismissible = true,
    DropdownStyle style = const DropdownStyle(),
    bool collapseOnSelect = true,
    Key? key,
  }) {
    return ModularCustomizableDropdown(
      reactMode: ReactMode.tapReact,
      onValueSelect: onValueSelect,
      collapseOnSelect: collapseOnSelect,
      allDropdownValues: allDropdownValues,
      tapReactParams: TapReactParams(target: target),
      dropdownStyle: style,
      onDropdownVisibilityChange: onDropdownVisible,
      barrierDismissible: barrierDismissible,
      invertYAxisAlignmentWhenOverflow: invertYAxisAlignmentWhenOverflow,
    );
  }

  ///Same as displayOnTap, but also triggers dropdown when the target is in focus
  factory ModularCustomizableDropdown.displayOnFocus({
    required Function(String selectedValue) onValueSelect,
    required List<String> allDropdownValues,
    required Widget Function(
            FocusNode focusNode, TextEditingController textController)
        targetBuilder,
    required TextEditingController textController,
    required FocusNode focusNode,
    required bool setTextToControllerOnSelect,
    bool collapseOnSelect = true,
    bool invertYAxisAlignmentWhenOverflow = false,
    bool barrierDismissible = true,
    Function(bool)? onDropdownVisible,
    DropdownStyle style = const DropdownStyle(),
    Key? key,
  }) {
    return ModularCustomizableDropdown(
      reactMode: ReactMode.focusReact,
      onValueSelect: onValueSelect,
      allDropdownValues: allDropdownValues,
      collapseOnSelect: collapseOnSelect,
      focusReactParams: FocusReactParams(
          textController: textController,
          focusNode: focusNode,
          setTextToControllerOnSelect: setTextToControllerOnSelect,
          targetBuilder: targetBuilder),
      dropdownStyle: style,
      onDropdownVisibilityChange: onDropdownVisible,
      barrierDismissible: barrierDismissible,
      invertYAxisAlignmentWhenOverflow: invertYAxisAlignmentWhenOverflow,
    );
  }

  ///Expose a toggle callback in the target builder method.
  factory ModularCustomizableDropdown.customControl({
    required Function(String selectedValue) onValueSelect,
    required List<String> allDropdownValues,
    required Widget target,
    required Widget Function(void Function(bool toggleState) toggleDropdown)
        targetBuilder,
    required bool collapseOnSelect,
    bool invertYAxisAlignmentWhenOverflow = false,
    bool barrierDismissible = true,
    DropdownStyle style = const DropdownStyle(),
    Key? key,
  }) {
    return ModularCustomizableDropdown(
      reactMode: ReactMode.callbackReact,
      onValueSelect: onValueSelect,
      allDropdownValues: allDropdownValues,
      collapseOnSelect: collapseOnSelect,
      callbackReactParams: CallbackReactParams(targetBuilder: targetBuilder),
      dropdownStyle: style,
      barrierDismissible: barrierDismissible,
      invertYAxisAlignmentWhenOverflow: invertYAxisAlignmentWhenOverflow,
    );
  }

  @override
  _ModularCustomizableDropdownState createState() =>
      _ModularCustomizableDropdownState();
}

class _ModularCustomizableDropdownState
    extends State<ModularCustomizableDropdown> {
  OverlayEntry? _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  bool inBuildingPhase = true;

  bool pointerDown = false;

  ///For obtaining size before paint
  final GlobalKey offstageListTileKey = GlobalKey();

  @override
  void initState() {
    if (widget.reactMode == ReactMode.focusReact) {
      widget.focusReactParams!.focusNode.addListener(() {
        _toggleOverlay(widget.focusReactParams!.focusNode.hasFocus);
      });
    }

    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
        link: _layerLink,
        child: ConditionalTapEventListener(
          reactMode: widget.reactMode,
          onTap: () {
            _toggleOverlay(inBuildingPhase);
          },
          child: Column(
            children: [
              //Offstage widget size to see whether we need to move the dropdown to the
              //top of the current widget when height exceeds screen height.
              Offstage(
                  offstage: true,
                  child: ListTileThatChangesColorOnTap(
                    onTap: null,
                    key: offstageListTileKey,
                    onTapColorTransitionDuration: const Duration(seconds: 0),
                    defaultBackgroundColor: const LinearGradient(
                        colors: [Colors.black, Colors.black]),
                    onTapBackgroundColor: const LinearGradient(
                        colors: [Colors.black, Colors.black]),
                    defaultTextStyle: const TextStyle(),
                    onTapTextStyle: const TextStyle(),
                    title: "",
                  )),

              ///Clean this up later
              _buildTarget(),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildTarget() {
    switch (widget.reactMode) {
      case ReactMode.tapReact:
        return widget.tapReactParams!.target;
      case ReactMode.focusReact:
        return widget.focusReactParams!.targetBuilder(
            widget.focusReactParams!.focusNode,
            widget.focusReactParams!.textController);
      case ReactMode.callbackReact:
        return widget.callbackReactParams!.targetBuilder(_toggleOverlay);
    }
  }

  OverlayEntry _buildOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size targetSize = renderBox.size;

    final targetPos = renderBox.localToGlobal(Offset.zero);
    final targetWidth = widget.dropdownStyle.width ?? targetSize.width;
    final targetHeight = targetSize.height;

    final singleTileHeight =
        ((offstageListTileKey.currentContext!.findRenderObject()) as RenderBox)
            .size
            .height;
    final expectedDropdownHeight = min(
        singleTileHeight * widget.allDropdownValues.length,
        widget.dropdownStyle.maxHeight);
    final dropdownWidth = targetWidth * widget.dropdownStyle.widthScale;
    final dropdownAlignment = widget.dropdownStyle.dropdownAlignment;

    final dropdownOffset = calculateDropdownPos(
        dropdownAlignment: dropdownAlignment,
        dropdownHeight: expectedDropdownHeight,
        dropdownWidth: dropdownWidth,
        targetAbsoluteY: targetPos.dy,
        targetHeight: targetHeight,
        targetWidth: targetWidth,
        screenHeight: MediaQuery.of(context).size.height,
        invertYAxisAlignmentWhenOverflow:
            widget.invertYAxisAlignmentWhenOverflow);

    final explicitDropdownTargetMargin =
        widget.dropdownStyle.explicitMarginBetweenDropdownAndTarget *
            (dropdownAlignment.y > 0 ? 1 : -1);

    Widget dismissibleWrapper({required Widget child}) =>
        widget.barrierDismissible
            ? SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(children: [
                  FullScreenDismissibleArea(dismissOverlay: _dismissOverlay),
                  child
                ]))
            : Stack(children: [child]);

    return OverlayEntry(
      builder: (context) => dismissibleWrapper(
        child: Positioned(
          width: dropdownWidth,
          child: CompositedTransformFollower(
              offset: Offset(dropdownOffset.x,
                  dropdownOffset.y + explicitDropdownTargetMargin),
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
                    listBuilder: (dropdownValue) {
                      return _buildDropdownRow(dropdownValue);
                    },
                    queryString:
                        widget.focusReactParams?.textController.text ?? "",
                  ),
                ),
              )),
        ),
      ),
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
        if (widget.collapseOnSelect) {
          _toggleOverlay(false);
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

  void _toggleOverlay(bool predicate) {
    if (predicate) {
      _buildAndAddOverlay();
    } else {
      _dismissOverlay();
    }
  }

  void _buildAndAddOverlay() {
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context)!.insert(_overlayEntry!);
    setState(() {
      inBuildingPhase = false;
    });
    _onDropdownVisible(true);
  }

  void _dismissOverlay() {
    if (inBuildingPhase != true) {
      _overlayEntry!.remove();

      ///Mark dropdown as build-able.
      setState(() => inBuildingPhase = true);

      widget.focusReactParams?.focusNode.unfocus();

      _onDropdownVisible(false);
    }
  }

  void _onDropdownVisible(bool dropdownVisible) {
    if (widget.onDropdownVisibilityChange != null) {
      widget.onDropdownVisibilityChange!(dropdownVisible);
    }
  }
}
