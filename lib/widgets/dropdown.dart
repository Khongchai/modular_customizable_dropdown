import 'dart:math';

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:modular_customizable_dropdown/classes_and_enums/dropdown_value.dart';
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
/// Pass any widget as the _target_ of this dropdown, and the dropdown will
/// automagically appear below the widget when you click on it!
class ModularCustomizableDropdown extends StatefulWidget {
  final DropdownStyle dropdownStyle;

  /// When the asTextFieldDropdown factory constructor is called, dropdown will allow
  /// an additional ability to filter the list based on the textController's value.
  final List<DropdownValue> allDropdownValues;

  /// Action to perform when the value is tapped.
  final Function(String selectedValue) onValueSelect;

  /// Allows user to click outside dropdown to dismiss
  ///
  /// Setting this to false may cause the dropdown to flow over other elements
  /// while scrolling(including the appbar).
  ///
  /// So, most of the time, pass true. Pass false when you wanna test something.
  final bool barrierDismissible;

  /// Dispose dropdown on value select?
  final bool collapseOnSelect;

  /// The modes the dropdown should react to
  final ReactMode reactMode;

  /// React to only tap events.
  ///
  /// This will still work with widgets that absorb tap events like buttons and
  /// text fields;
  /// however, FocusReactParams is still preferred over this for text fields.
  final TapReactParams? tapReactParams;

  /// React to focus.
  ///
  /// Really, this is meant primarily for text fields. The dropdown will show when
  /// focusNode.hasFocus is true. Works both when the widget is tapped or when the focus
  /// is triggered programmatically.
  final FocusReactParams? focusReactParams;

  /// React to callback events.
  ///
  /// When you would like to trigger the dropdown by clicking on something else
  /// other than the target widget.
  final CallbackReactParams? callbackReactParams;

  /// A key that targets the overlayEntry widget (the dropdown).
  ///
  /// The normal "key", is actually the parent of the target and the offStage dropdown.
  /// The overlayEntryKey lives in another tree.
  /// If you want to target the dropdown only, use this instead.
  @visibleForTesting
  final Key? overlayEntryKey;

  /// A key that targets the offStage widget.
  ///
  /// The normal "key", is actually the key of the parent of the offStage widget.
  @visibleForTesting
  final Key? offStageWidgetKey;

  /// For testing the final "visible" height of the dropdown
  @visibleForTesting
  final Key? listviewKey;

  /// For obtaining the individual height of each of the dropdown rows.
  @visibleForTesting
  final List<GlobalKey>? rowKeys;

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
    this.rowKeys,
    this.listviewKey,
    this.offStageWidgetKey,
    this.overlayEntryKey,
    Key? key,
  })  : assert((tapReactParams != null && reactMode == ReactMode.tapReact) ||
            (focusReactParams != null && reactMode == ReactMode.focusReact) ||
            (callbackReactParams != null &&
                reactMode == ReactMode.callbackReact)),
        super(key: key);

  ///Automatically displays the dropdown when the target is clicked
  factory ModularCustomizableDropdown.displayOnTap({
    required Function(String selectedValue) onValueSelect,
    required List<DropdownValue> allDropdownValues,
    required Widget target,
    Function(bool)? onDropdownVisible,
    bool barrierDismissible = true,
    DropdownStyle style =
        const DropdownStyle(invertYAxisAlignmentWhenOverflow: true),
    bool collapseOnSelect = true,
    Key? key,
    @visibleForTesting Key? overlayEntryKey,
    @visibleForTesting Key? offStageWidgetKey,
    @visibleForTesting Key? listviewKey,
    @visibleForTesting List<GlobalKey>? rowKeys,
  }) {
    return ModularCustomizableDropdown(
      rowKeys: rowKeys,
      listviewKey: listviewKey,
      overlayEntryKey: overlayEntryKey,
      offStageWidgetKey: offStageWidgetKey,
      key: key,
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

  /// Same as displayOnTap, but also triggers dropdown when the target is in focus
  ///
  /// This is still a bit stable, there's more work to be done...
  ///
  /// Don't use in prod...yet
  @Deprecated("This factory constructor is no longer maintained.")
  factory ModularCustomizableDropdown.displayOnFocus({
    required Function(String selectedValue) onValueSelect,
    required List<DropdownValue> allDropdownValues,
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
    @visibleForTesting Key? listviewKey,
    @visibleForTesting Key? overlayEntryKey,
    @visibleForTesting Key? offStageWidgetKey,
    @visibleForTesting List<GlobalKey>? rowKeys,
  }) {
    return ModularCustomizableDropdown(
      rowKeys: rowKeys,
      listviewKey: listviewKey,
      offStageWidgetKey: offStageWidgetKey,
      overlayEntryKey: overlayEntryKey,
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
    required List<DropdownValue> allDropdownValues,
    required Widget Function(void Function(bool toggleState) toggleDropdown)
        targetBuilder,
    required bool collapseOnSelect,
    bool barrierDismissible = true,
    DropdownStyle style =
        const DropdownStyle(invertYAxisAlignmentWhenOverflow: true),
    Key? key,
    @visibleForTesting Key? listviewKey,
    @visibleForTesting Key? overlayEntryKey,
    @visibleForTesting Key? offStageWidgetKey,
  }) {
    return ModularCustomizableDropdown(
      listviewKey: listviewKey,
      offStageWidgetKey: offStageWidgetKey,
      overlayEntryKey: overlayEntryKey,
      key: key,
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

  /// true = is about to be expanded.
  /// false = dismissed.
  bool _isInBuildingPhase = true;

  /// For obtaining size before paint
  late List<GlobalKey> _offStageListTileKeys;

  /// For obtaining the width of the offstage list tile.
  ///
  /// Basically an offstage for the those off-staged.
  final GlobalKey _offStageTargetKey = GlobalKey();
  double? _offStageTargetWidth;

  late double _preCalculateDropdownHeight;
  late List<double> _tileHeights;

  @override
  void initState() {
    if (widget.reactMode == ReactMode.focusReact) {
      widget.focusReactParams!.focusNode.addListener(() {
        _toggleOverlay(widget.focusReactParams!.focusNode.hasFocus);
      });
    }

    _beginPostStateUpdateStage();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ModularCustomizableDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget != widget) {
      _beginPostStateUpdateStage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
        link: _layerLink,
        child: ConditionalTapEventListener(
          reactMode: widget.reactMode,
          onTap: () {
            if (widget.allDropdownValues.isNotEmpty) {
              _toggleOverlay(_isInBuildingPhase);
            }
          },
          child: Column(
            // height 182
            mainAxisSize: MainAxisSize.min,
            children: [
              // Offstage widget size to see whether we need to move the dropdown to the
              // top of the current widget when height exceeds screen height.

              // No need to calculate anything if we're removing the dropdown.
              if (_isInBuildingPhase)
                Offstage(
                    key: widget.offStageWidgetKey,
                    offstage: true,
                    child: SizedBox(
                      width: _offStageTargetWidth,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        // Need to offstage the target as well to get the proper width.
                        SizedBox(
                          key: _offStageTargetKey,
                          child: _buildTarget(),
                        ),
                        for (int i = 0;
                            i < widget.allDropdownValues.length;
                            i++)
                          ListTileThatChangesColorOnTap(
                            key: _offStageListTileKeys[i],
                            onTap: null,
                            onTapInkColor: widget.dropdownStyle.onTapInkColor,
                            spaceBetweenTitleAndDescription: widget
                                .dropdownStyle.spaceBetweenValueAndDescription,
                            onTapColorTransitionDuration:
                                const Duration(seconds: 0),
                            defaultBackgroundColor: const LinearGradient(
                                colors: [Colors.black, Colors.black]),
                            onTapBackgroundColor: const LinearGradient(
                                colors: [Colors.black, Colors.black]),
                            defaultTextStyle:
                                widget.dropdownStyle.defaultTextStyle,
                            onTapTextStyle: widget.dropdownStyle.onTapTextStyle,
                            descriptionTextStyle:
                                widget.dropdownStyle.descriptionStyle,
                            title: widget.allDropdownValues[i].value,
                            description:
                                widget.allDropdownValues[i].description,
                          ),
                      ]),
                    )),

              _buildTarget(),
            ],
          ),
        ));
  }

  /// Should be called both in initState() and didUpdateWidget()
  ///
  /// This sets in motion all the calculation necessary to make sure that the dropdown
  /// sizes and positions itself correctly.
  void _beginPostStateUpdateStage() {
    // Reset in case barrierDismissible = false and the width of the target changes.
    _offStageTargetWidth = null;

    _updateListTileKeys();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      try {
        _precalculateDropdownHeight();
      } on StateError catch (e) {
        debugPrint("Range error caught.");
        if (widget.allDropdownValues.isEmpty) {
          debugPrint("The passed in dropdown values list has length === 0");
          debugPrint(
              "With length zero, when the target is tapped. Nothing will happen.");
        } else {
          debugPrint(e.toString());
        }
      }
    });
  }

  // Abstraction - 1 stuff below.

  void _updateListTileKeys() {
    void genKey() {
      _offStageListTileKeys =
          widget.allDropdownValues.map((e) => GlobalKey()).toList();
    }

    if (!kDebugMode) {
      genKey();
      return;
    }

    if (widget.rowKeys?.isNotEmpty == true) {
      _offStageListTileKeys = widget.rowKeys!;
    } else {
      genKey();
    }
  }

  void _precalculateDropdownHeight() {
    assert(
        widget.dropdownStyle.dropdownMaxHeight.byPixels != 0 &&
            widget.dropdownStyle.dropdownMaxHeight.byRows != 0,
        "The dropdown can't have a height of 0");

    // If the width of the offStageTarget has not yet been obtained, call this method
    // again the next frame with the newly obtained width.
    if (_offStageTargetWidth == null) {
      setState(() {
        final width = _offStageTargetKey.currentContext?.size?.width;
        _offStageTargetWidth = width;
      });

      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        _precalculateDropdownHeight();
      });
      return;
    }

    final List<double> heights = [];
    for (final key in _offStageListTileKeys) {
      heights.add(key.currentContext!.size!.height);
    }

    late final double dropdownMaxHeight;

    if (widget.dropdownStyle.dropdownMaxHeight.byPixels != null) {
      dropdownMaxHeight = widget.dropdownStyle.dropdownMaxHeight.byPixels!;
    } else {
      final int rowsAmount = min(
          widget.dropdownStyle.dropdownMaxHeight.byRows.ceil(),
          widget.allDropdownValues.length);

      // If the provided row ratio is 2.5, then the third row should have only
      // half the height.
      // And we only do this when the height of the provided byRows is smaller than
      // the total length, otherwise we'll be truncating the height of the wrong
      // row.
      if (rowsAmount < widget.allDropdownValues.length) {
        final double lastVisibleRowHeightRatio =
            widget.dropdownStyle.dropdownMaxHeight.byRows % 1;
        heights[rowsAmount - 1] *=
            (lastVisibleRowHeightRatio != 0 ? lastVisibleRowHeightRatio : 1);
      }

      dropdownMaxHeight = heights
          .sublist(0, rowsAmount)
          .reduce((value, element) => value + element);
    }

    // The actual height of the dropdown when rows is rendered.
    final totalDropdownHeight =
        heights.reduce((value, element) => value + element);

    _tileHeights = heights;
    _preCalculateDropdownHeight = min(totalDropdownHeight, dropdownMaxHeight);
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

    final dropdownWidth =
        targetWidth * widget.dropdownStyle.dropdownWidth.scale;
    final dropdownAlignment = widget.dropdownStyle.alignment;

    final dropdownOffset = calculateDropdownPos(
        dropdownAlignment: dropdownAlignment,
        dropdownHeight: _preCalculateDropdownHeight,
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
    final Alignment newAlignment =
        Alignment(dropdownAlignment.x, dropdownAlignment.y * invertDir);

    return OverlayEntry(
      builder: (context) => dismissibleWrapper(
        child: Positioned(
          key: widget.overlayEntryKey,
          width: dropdownWidth,
          child: CompositedTransformFollower(
              offset: Offset(dropdownOffset.x,
                  dropdownOffset.y + explicitDropdownTargetMargin * invertDir),
              link: _layerLink,
              showWhenUnlinked: false,
              child: AnimatedListView(
                listviewKey: widget.listviewKey,
                animationCurve: widget.dropdownStyle.transitionInCurve,
                listOfTileHeights: _tileHeights,
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
                listBuilder: (dropdownValue, dropdownDescription) {
                  return _buildDropdownRow(dropdownValue, dropdownDescription);
                },
                queryString: widget.focusReactParams?.textController.text ?? "",
                expectedDropdownHeight: _preCalculateDropdownHeight,
              )),
        ),
      ),
    );
  }

  Widget _buildDropdownRow(String dropdownValue, String? dropdownDescription,
      {Key? key}) {
    return ListTileThatChangesColorOnTap(
      key: key,
      onTap: () {
        if (widget.reactMode == ReactMode.focusReact &&
            widget.focusReactParams!.setTextToControllerOnSelect) {
          widget.focusReactParams!.textController.text = dropdownValue;
        }
        widget.onValueSelect(dropdownValue);
        if (widget.collapseOnSelect) {
          _toggleOverlay(false);
        }
      },
      onTapInkColor: widget.dropdownStyle.onTapInkColor,
      spaceBetweenTitleAndDescription:
          widget.dropdownStyle.spaceBetweenValueAndDescription,
      onTapColorTransitionDuration:
          widget.dropdownStyle.onTapColorTransitionDuration,
      defaultBackgroundColor: widget.dropdownStyle.defaultItemColor,
      onTapBackgroundColor: widget.dropdownStyle.onTapItemColor,
      defaultTextStyle: widget.dropdownStyle.defaultTextStyle,
      onTapTextStyle: widget.dropdownStyle.onTapTextStyle,
      title: dropdownValue,
      descriptionTextStyle: widget.dropdownStyle.descriptionStyle,
      description: dropdownDescription,
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
      _isInBuildingPhase = false;
    });
    _onDropdownVisible(true);
  }

  ///Should not be called by any function other than _toggleOverlay()
  void _dismissOverlay() {
    if (_isInBuildingPhase != true) {
      _overlayEntry!.remove();

      ///Mark dropdown as build-able.
      setState(() => _isInBuildingPhase = true);

      widget.focusReactParams?.focusNode.unfocus();

      _onDropdownVisible(false);
    }
  }

  ///Should not be called by any function other than _dismissOverlay()
  void _onDropdownVisible(bool dropdownVisible) {
    widget.onDropdownVisibilityChange?.call(dropdownVisible);
  }
}
