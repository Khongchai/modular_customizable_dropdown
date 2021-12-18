import "package:flutter/material.dart";

@Deprecated("To be replaced with card_x_dropdown.dart")
class CardXTextDropdown extends StatefulWidget {
  //Input variables
  final String hintText;
  final EdgeInsets inputPadding;

  ///Provide your preferred pointing-down arrow
  final Widget trailingArrowDownIcon;

  //Dropdown variables
  final Color backgroundColor;
  final double dropdownTopMargin;
  final List<String> dropdownValues;
  final Color dropdownBorderColor;
  final double dropdownBorderThickness;
  final double dropdownElevation;
  final double maxHeight;
  final Function(String selectedValue) onValueSelect;

  ///Provide 1 color in the colors array for a solid, single color
  final LinearGradient highlightColor;

  const CardXTextDropdown(
      {required this.onValueSelect,
      required this.backgroundColor,
      required this.highlightColor,
      required this.dropdownElevation,
      required this.hintText,
      required this.dropdownValues,
      required this.inputPadding,
      required this.dropdownBorderColor,
      required this.dropdownBorderThickness,
      required this.maxHeight,
      required this.trailingArrowDownIcon,
      this.dropdownTopMargin = 11,
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

  List<String> valuesToDisplay = [];

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

    _controller.addListener(() {
      setState(() {
        valuesToDisplay = _filterOutValuesThatDoNotMatchQueryString(
            queryString: _controller.text,
            valuesToFilter: widget.dropdownValues);
      });
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
                  autofocus: false,
                  textAlignVertical: TextAlignVertical.center,
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration.collapsed(
                    hintText: widget.hintText,
                  )),
            ),
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
                  ///TODO, is this necessary? ask the SD Team
                  // const FullScreenDismissibleArea(),
                  Positioned(
                    width: size.width,
                    child: CompositedTransformFollower(
                      offset: Offset(0, size.height + widget.dropdownTopMargin),
                      link: _layerLink,
                      showWhenUnlinked: false,
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: widget.maxHeight,
                        ),
                        child: Material(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                                side: BorderSide(
                                  width: widget.dropdownBorderThickness,
                                  style: BorderStyle.solid,
                                  color: widget.dropdownBorderColor,
                                )),
                            color: widget.backgroundColor,
                            elevation: widget.dropdownElevation,
                            child: ListView.builder(
                                itemCount: valuesToDisplay.length,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return _buildDropdownRow(
                                      valuesToDisplay[index]);
                                })),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  List<String> _filterOutValuesThatDoNotMatchQueryString(
      {required String queryString, required List<String> valuesToFilter}) {
    if (queryString == "" || queryString == " ") {
      return valuesToFilter;
    }

    RegExp reg = RegExp(
      "(${RegExp.escape(queryString)})\\S*",
      caseSensitive: false,
      multiLine: false,
    );
    return valuesToFilter.where((value) => reg.hasMatch(value)).toList();
  }

  Widget _buildDropdownRow(
    String str,
  ) {
    return ListTile(
        onTap: () {
          widget.onValueSelect(str);
          _controller.text = str;
          FocusScope.of(context).unfocus();
        },
        title: Text(str));
  }
}
