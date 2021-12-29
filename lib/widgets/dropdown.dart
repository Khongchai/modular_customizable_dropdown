import 'dart:math';

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

  ///Declare mode separately for explicitness.
  final ReactMode reactMode;
  final TapReactParams? tapReactParams;
  final FocusReactParams? focusReactParams;

  ///Whether to expose the function for calling dropdown in the target builder function or not.
  final bool exposeDropdownHandler;

  final void Function(bool visible)? onDropdownVisibilityChange;

  ///Whether or not to swap the alignment, for example, from bottomCenter to topCenter when
  ///the bottom of the dropdown exceeds the screen height.
  final bool invertYAxisAlignmentWhenOverflow;

  const ModularCustomizableDropdown({
    required this.reactMode,
    required this.onValueSelect,
    required this.allDropdownValues,
    required this.exposeDropdownHandler,
    required this.barrierDismissible,
    required this.dropdownStyle,
    required this.invertYAxisAlignmentWhenOverflow,
    this.onDropdownVisibilityChange,
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
    Function(bool)? onDropdownVisible,
    bool invertYAxisAlignmentWhenOverflow = false,
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
      onDropdownVisibilityChange: onDropdownVisible,
      barrierDismissible: barrierDismissible,
      exposeDropdownHandler: false,
      invertYAxisAlignmentWhenOverflow: invertYAxisAlignmentWhenOverflow,
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
      focusReactParams: FocusReactParams(
          textController: textController,
          focusNode: focusNode,
          setTextToControllerOnSelect: setTextToControllerOnSelect,
          targetBuilder: targetBuilder),
      dropdownStyle: style,
      onDropdownVisibilityChange: onDropdownVisible,
      barrierDismissible: barrierDismissible,
      exposeDropdownHandler: false,
      invertYAxisAlignmentWhenOverflow: invertYAxisAlignmentWhenOverflow,
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
  OverlayEntry? _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  bool buildOverlayEntry = true;

  bool pointerDown = false;

  ///For obtaining size before paint
  GlobalKey offstageListTileKey = GlobalKey();

  @override
  void initState() {
    if (widget.reactMode == ReactMode.focusReact) {
      widget.focusReactParams!.focusNode.addListener(() {
        if (widget.focusReactParams!.focusNode.hasFocus) {
          _buildAndAddOverlay();
        } else {
          _overlayEntry!.remove();
        }
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
        child: Listener(
          onPointerDown: (_) {
            setState(() => pointerDown = true);
          },
          onPointerCancel: (_) => setState(() {
            pointerDown = false;
          }),
          onPointerUp: (_) {
            if (buildOverlayEntry &&
                pointerDown &&
                widget.reactMode == ReactMode.tapReact) {
              _buildAndAddOverlay();
            } else {
              _dismissOverlay();
            }
            setState(() => pointerDown = false);
          },
          child: Column(
            children: [
              //Offstage widget size to see whether we need to move the dropdown to the
              //top of the current widget when height exceeds screen height.
              Offstage(
                  offstage: true,
                  child: ListTileThatChangesColorOnTap(
                    onTap: () {},
                    key: offstageListTileKey,
                    onTapColorTransitionDuration: const Duration(seconds: 0),
                    defaultBackgroundColor:
                        widget.dropdownStyle.defaultItemColor,
                    onTapBackgroundColor: widget.dropdownStyle.onTapItemColor,
                    defaultTextStyle: widget.dropdownStyle.defaultTextStyle,
                    onTapTextStyle: widget.dropdownStyle.onTapTextStyle,
                    title: "",
                  )),
              widget.reactMode == ReactMode.tapReact
                  ? widget.tapReactParams!.target
                  : widget.focusReactParams!.targetBuilder(
                      widget.focusReactParams!.focusNode,
                      widget.focusReactParams!.textController),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  OverlayEntry _buildOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size targetSize = renderBox.size;

    final targetPos = renderBox.localToGlobal(Offset.zero);
    final dropdownAlignment = widget.dropdownStyle.dropdownAlignment;

    //Calculate x alignment
    final xAlignment = dropdownAlignment.x;
    final targetWidth = widget.dropdownStyle.width ?? targetSize.width;
    final dropdownWidth = (targetWidth) * widget.dropdownStyle.widthScale;
    final xCenter = ((dropdownWidth - targetSize.width) / 2);
    final dropdownRelativeXOffset = (xCenter * -xAlignment) - xCenter;

    //Calculate y alignment
    final yAlignment = dropdownAlignment.y;
    final singleTileHeight =
        ((offstageListTileKey.currentContext!.findRenderObject()) as RenderBox)
            .size
            .height;
    final targetHeight = targetSize.height;
    final expectedDropdownHeight = min(
        singleTileHeight * widget.allDropdownValues.length,
        widget.dropdownStyle.maxHeight);
    final yCenter = expectedDropdownHeight / 2 + targetHeight / 2;
    //For y values, 1 unit of alignment equals half of th dropdown height + target's half of target's height.
    final yOffset = yCenter * yAlignment;
    final dropdownRelativeYOffset = targetHeight -
        yCenter +
        yOffset; //<< everything after this is just to calculate the wrap around

    final dropdownAbsoluteYOffset = targetPos.dy + dropdownRelativeYOffset;
    final dropdownBottomPos = dropdownAbsoluteYOffset + expectedDropdownHeight;

    //Once threshold exceeded,
    //invert the y alignment if invertYAxisAlignmentWhenOverflow == true
    const screenTop = 0;
    final isYOverflow =
        dropdownBottomPos > MediaQuery.of(context).size.height ||
            dropdownAbsoluteYOffset < screenTop;

    final wrapAroundCalculatedDropdownYPos =
        isYOverflow && widget.invertYAxisAlignmentWhenOverflow
            ? targetHeight - yCenter + (yCenter * -yAlignment)
            : targetHeight - yCenter + (yCenter * yAlignment);

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
                  offset: Offset(dropdownRelativeXOffset,
                      wrapAroundCalculatedDropdownYPos),
                  link: _layerLink,
                  showWhenUnlinked: false,
                  child: StatefulBuilder(builder: (context, setState) {
                    return Container(
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
                              widget.focusReactParams?.textController.text ??
                                  "",
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ));
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
          _dismissOverlay();
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

  void _buildAndAddOverlay() {
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context)!.insert(_overlayEntry!);
    setState(() {
      buildOverlayEntry = false;
    });
    _onDropdownVisible(true);
  }

  void _dismissOverlay() {
    if (widget.reactMode == ReactMode.tapReact) {
      _overlayEntry!.remove();
      setState(() {
        buildOverlayEntry = true;
      });
    } else {
      widget.focusReactParams!.focusNode.unfocus();
    }
    _onDropdownVisible(false);
  }

  void _onDropdownVisible(bool dropdownVisible) {
    if (widget.onDropdownVisibilityChange != null) {
      widget.onDropdownVisibilityChange!(dropdownVisible);
    }
  }
}
