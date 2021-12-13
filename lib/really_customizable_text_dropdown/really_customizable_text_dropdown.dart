import "package:flutter/material.dart";

///What needs to be done
///Ensure that the dropdown itself and the text widget are modular and are not aware of each other's internal states.
///
///
/// TextWidget's args:
///   FocusNode,
///   Controller,
///   Other TextWidget's args
///
/// DropDown's args:
///   searchItems,
///   currentSearchQuery,
///   textFieldWidget (for CompositedTransformTarget),
///   position (Offset class),
///   width,
///   height,
///   containerBorderRadius,
///   backgroundColor (accepts LinearGradient),
///   suggestionColor (accepts LinearGradient),
///   spaceBetweenSearchItems,
///   onSelect,
///   borderColor,
///   borderThickness,
///   someAnimationArgs...
///
///
///
class ReallyCustomizableTextDropdown extends StatefulWidget {
  final List<String> searchItems;
  final num dropDownTopPadding;
  const ReallyCustomizableTextDropdown(
      {required this.dropDownTopPadding, required this.searchItems, Key? key})
      : super(key: key);

  @override
  _ReallyCustomizableTextDropdownState createState() =>
      _ReallyCustomizableTextDropdownState();
}

class _ReallyCustomizableTextDropdownState
    extends State<ReallyCustomizableTextDropdown> {
  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  late OverlayEntry _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context)!.insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
        builder: (context) => SizedBox(
              width: 1 / 0,
              height: 1 / 0,
              child: Stack(
                children: [
                  _buildFullScreenFocusDismissibleArea(),
                  Positioned(
                    width: size.width,
                    child: CompositedTransformFollower(
                      offset:
                          Offset(0, size.height + widget.dropDownTopPadding),
                      link: _layerLink,
                      showWhenUnlinked: false,
                      child: Material(
                          elevation: 4.0,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            children: widget.searchItems
                                .map((string) => GestureDetector(
                                    child: ListTile(
                                        onTap: () {}, title: Text(string))))
                                .toList(),
                          )),
                    ),
                  ),
                ],
              ),
            ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration:
              const InputDecoration.collapsed(hintText: 'Enter some values')),
    );
  }

  Widget _buildFullScreenFocusDismissibleArea() {
    return Positioned(
      left: 0,
      top: 0,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Colors.transparent,
          width: 1 / 0,
          height: 1 / 0,
        ),
      ),
    );
  }
}
