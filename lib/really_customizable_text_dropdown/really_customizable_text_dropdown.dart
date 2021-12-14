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

class CardXTextDropdown extends StatefulWidget {
  //Input variables
  final String hintText;
  final EdgeInsets inputPadding;
  final Color inputBorderColor;
  final double inputBorderThickness;

  //Dropdown variables
  final Color backgroundColor;
  final double dropDownTopPadding;
  final List<String> dropdownValues;
  final Color dropdownBorderColor;
  final double dropdownBorderThickness;
  final double dropdownElevation;
  final Function(String selectedValue) onValueSelect;

  ///Provide 1 color in the colors array for a solid, single color
  final LinearGradient highlightColor;

  const CardXTextDropdown(
      {required this.onValueSelect,
      required this.dropDownTopPadding,
      required this.backgroundColor,
      required this.highlightColor,
      required this.dropdownElevation,
      required this.hintText,
      required this.dropdownValues,
      required this.inputPadding,
      required this.inputBorderColor,
      required this.dropdownBorderColor,
      required this.dropdownBorderThickness,
      required this.inputBorderThickness,
      Key? key})
      : super(key: key);

  @override
  _CardXTextDropdownState createState() => _CardXTextDropdownState();
}

class _CardXTextDropdownState extends State<CardXTextDropdown> {
  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  late OverlayEntry _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry = _buildOverlayEntry();
        Overlay.of(context)!.insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Padding(
        padding: widget.inputPadding,
        child: Row(
          children: [
            Flexible(
              child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration:
                      InputDecoration.collapsed(hintText: widget.hintText)),
            ),
            Icon(Icons.arrow_downward_rounded),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  OverlayEntry _buildOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
        builder: (context) => SizedBox(
              width: 1 / 0,
              height: 1 / 0,
              child: Stack(
                children: [
                  const FullScreenDismissibleArea(),
                  Positioned(
                    width: size.width,
                    child: CompositedTransformFollower(
                      offset:
                          Offset(0, size.height + widget.dropDownTopPadding),
                      link: _layerLink,
                      showWhenUnlinked: false,
                      child: Material(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                              side: BorderSide(
                                width: widget.dropdownBorderThickness,
                                style: BorderStyle.solid,
                                color: widget.dropdownBorderColor,
                              )),
                          color: widget.backgroundColor,
                          elevation: widget.dropdownElevation,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            children: widget.dropdownValues
                                .map((string) => GestureDetector(
                                    child: ListTile(
                                        onTap: () {
                                          widget.onValueSelect(string);
                                          _controller.text = string;
                                          FocusScope.of(context).unfocus();
                                        },
                                        title: Text(string))))
                                .toList(),
                          )),
                    ),
                  ),
                ],
              ),
            ));
  }
}

class FullScreenDismissibleArea extends StatelessWidget {
  const FullScreenDismissibleArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
