import "package:flutter/material.dart";

class CustomDropdown extends StatefulWidget {
  //Dropdown variables
  final Color backgroundColor;
  final double dropdownTopMargin;
  final List<String> dropdownValues;
  final Color dropdownBorderColor;
  final double dropdownBorderThickness;
  final double dropdownElevation;
  final double maxHeight;

  ///Target to attach the dropdown to
  final Widget target;
  final Function(String selectedValue) onValueSelect;

  ///Provide 1 color in the colors array for a solid, single color
  final LinearGradient highlightColor;

  const CustomDropdown(
      {required this.onValueSelect,
      required this.backgroundColor,
      required this.highlightColor,
      required this.dropdownElevation,
      required this.dropdownValues,
      required this.dropdownBorderColor,
      required this.dropdownBorderThickness,
      required this.maxHeight,
      required this.target,
      this.dropdownTopMargin = 0,
      Key? key})
      : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late OverlayEntry _overlayEntry;

  GlobalKey key = GlobalKey();

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
        key: key,
        onTap: () {
          if (buildOverlayEntry) {
            _overlayEntry = _buildOverlayEntry();
            Overlay.of(context)!.insert(_overlayEntry);
            setState(() {
              buildOverlayEntry = false;
            });
          } else {
            _overlayEntry.remove();
            setState(() {
              buildOverlayEntry = true;
            });
          }
        },
        child: widget.target,
        // child: Container(
        //     color: Colors.red,
        //     padding: EdgeInsets.all(8),
        //     child: Text("loooooooooooooooooooooooooooooooooooong text")),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  OverlayEntry _buildOverlayEntry() {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
        builder: (context) => Stack(
              children: [
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
                            itemBuilder: (context, index) =>
                                _buildDropdownRow(valuesToDisplay[index]),
                          )),
                    ),
                  ),
                ),
              ],
            ));
  }

  Widget _buildDropdownRow(
    String str,
  ) {
    return ListTile(
        onTap: () {
          widget.onValueSelect(str);
          FocusScope.of(context).unfocus();
        },
        title: Text(str));
  }
}
