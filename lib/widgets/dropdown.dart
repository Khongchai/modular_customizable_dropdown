import 'dart:math';

import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:modular_customizable_dropdown/classes_and_enums/dropdown_alignment.dart';
import 'package:modular_customizable_dropdown/classes_and_enums/focus_callback_params.dart';
import 'package:modular_customizable_dropdown/utils/calculate_dropdown_pos.dart';
import 'package:modular_customizable_dropdown/widgets/animated_listview.dart';
import 'package:modular_customizable_dropdown/widgets/conditional_tap_event_listener.dart';

import '../classes_and_enums/dropdown_style.dart';
import '../classes_and_enums/focus_react_params.dart';
import '../classes_and_enums/mode.dart';
import '../classes_and_enums/tap_react_params.dart';
import 'full_screen_dismissible_area.dart';
import 'list_tile_that_changes_color_on_tap.dart';

/// A dropdown extension for any widget.
///
/// I have provided three factory constructors to help you get started,
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

  const ModularCustomizableDropdown({
    required this.reactMode,
    required this.onValueSelect,
    required this.allDropdownValues,
    required this.barrierDismissible,
    required this.dropdownStyle,
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
    bool barrierDismissible = true,
    DropdownStyle style =
        const DropdownStyle(invertYAxisAlignmentWhenOverflow: true),
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
    bool setTextToControllerOnSelect = true,
    bool collapseOnSelect = true,
    bool barrierDismissible = true,
    Function(bool)? onDropdownVisible,
    DropdownStyle style =
        const DropdownStyle(invertYAxisAlignmentWhenOverflow: true),
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
    );
  }

  ///Expose a toggle callback in the target builder method.
  factory ModularCustomizableDropdown.displayOnCallback({
    required Function(String selectedValue) onValueSelect,
    required List<String> allDropdownValues,
    required Widget Function(void Function(bool toggleState) toggleDropdown)
        targetBuilder,
    required bool collapseOnSelect,
    bool barrierDismissible = true,
    DropdownStyle style =
        const DropdownStyle(invertYAxisAlignmentWhenOverflow: true),
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
                    onTapInkColor: widget.dropdownStyle.onTapInkColor,
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
    final targetWidth =
        widget.dropdownStyle.dropdownWidth.byPixels ?? targetSize.width;
    final targetHeight = targetSize.height;

    final singleTileHeight =
        ((offstageListTileKey.currentContext!.findRenderObject()) as RenderBox)
            .size
            .height;
    final maxDropdownHeight = widget.dropdownStyle.dropdownMaxHeight.byPixels ??
        widget.dropdownStyle.dropdownMaxHeight.byRows * singleTileHeight;
    final expectedDropdownHeight = min(
        singleTileHeight * widget.allDropdownValues.length, maxDropdownHeight);
    final dropdownWidth =
        targetWidth * widget.dropdownStyle.dropdownWidth.scale;
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
            widget.dropdownStyle.invertYAxisAlignmentWhenOverflow);

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

    final invertDir = dropdownOffset.isYInverted ? -1 : 1;
    final DropdownAlignment newAlignment =
        DropdownAlignment(dropdownAlignment.x, dropdownAlignment.y * invertDir);

    return OverlayEntry(
      builder: (context) => dismissibleWrapper(
        child: Positioned(
          width: dropdownWidth,
          child: CompositedTransformFollower(
              offset: Offset(dropdownOffset.x,
                  dropdownOffset.y + explicitDropdownTargetMargin * invertDir),
              link: _layerLink,
              showWhenUnlinked: false,
              child: AnimatedListView(
                animationCurve: widget.dropdownStyle.transitionInCurve,
                singleTileHeight: singleTileHeight,
                dropdownScrollbarStyle:
                    widget.dropdownStyle.dropdownScrollbarStyle,
                animationDuration: widget.dropdownStyle.transitionInDuration,
                borderThickness: widget.dropdownStyle.borderThickness,
                borderColor: widget.dropdownStyle.borderColor,
                borderRadius: widget.dropdownStyle.borderRadius,
                boxShadows: widget.dropdownStyle.boxShadows,
                targetWidth: targetWidth,
                allDropdownValues: widget.allDropdownValues,
                dropdownAlignment: newAlignment,
                listBuilder: (dropdownValue) {
                  return _buildDropdownRow(dropdownValue);
                },
                queryString: widget.focusReactParams?.textController.text ?? "",
                expectedDropdownHeight: expectedDropdownHeight,
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
      onTapInkColor: widget.dropdownStyle.onTapInkColor,
      onTapColorTransitionDuration:
          widget.dropdownStyle.onTapColorTransitionDuration,
      defaultBackgroundColor: widget.dropdownStyle.defaultItemColor,
      onTapBackgroundColor: widget.dropdownStyle.onTapItemColor,
      defaultTextStyle: widget.dropdownStyle.defaultTextStyle,
      onTapTextStyle: widget.dropdownStyle.onTapTextStyle,
      title: str,
    );
  }

  ///For building and disposing dropdown
  void _toggleOverlay(bool predicate) {
    if (predicate) {
      _buildAndAddOverlay();
    } else {
      _dismissOverlay();
    }
  }

  ///Should not be called by any function other than _toggleOverlay()
  void _buildAndAddOverlay() {
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context)!.insert(_overlayEntry!);
    setState(() {
      inBuildingPhase = false;
    });
    _onDropdownVisible(true);
  }

  ///Should not be called by any function other than _toggleOverlay()
  void _dismissOverlay() {
    if (inBuildingPhase != true) {
      _overlayEntry!.remove();

      ///Mark dropdown as build-able.
      setState(() => inBuildingPhase = true);

      widget.focusReactParams?.focusNode.unfocus();

      _onDropdownVisible(false);
    }
  }

  ///Should not be called by any function other than _dismissOverlay()
  void _onDropdownVisible(bool dropdownVisible) {
    if (widget.onDropdownVisibilityChange != null) {
      widget.onDropdownVisibilityChange!(dropdownVisible);
    }
  }
}
