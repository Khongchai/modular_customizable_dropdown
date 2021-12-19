import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:really_customizable_dropdown/dropdown.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  GlobalKey<State> key = GlobalKey();

  double fabOpacity = 1.0;

  String selectedValue = "Violin";
  List<String> values = [
    "Violin",
    "Viola",
    "Cello",
    "Double Bass",
    "Piano",
    "Conductor"
  ];
  bool showDropdown = false;

  final TextEditingController _textController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Scrolling."),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(top: 100),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text("Selected value: $selectedValue"),
            const SizedBox(height: 50),
            ReallyCustomizableDropdown.displayOnTap(
                onValueSelect: ((newValue) =>
                    setState(() => selectedValue = newValue)),
                dropdownValues: values,
                target: SizedBox(width: 200, child: Text(selectedValue))),
            const SizedBox(height: 50),
            ReallyCustomizableDropdown.displayOnFocus(
              setTextToControllerOnSelect: true,
              textController: _textController,
              onValueSelect: ((newValue) =>
                  setState(() => selectedValue = newValue)),
              dropdownValues: values,
              targetBuilder: (focusNode, textController) => Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.brown),
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  focusNode: focusNode,
                  controller: textController,
                ),
              ),
              focusNode: _focusNode,
            )
          ]),
        ),
        floatingActionButton: Opacity(
          opacity: fabOpacity,
          child: FloatingActionButton(
            onPressed: () {
              print("YAY");
            },
          ),
        ),
      ),
    );
  }
}

class MyObservableWidget extends StatefulWidget {
  const MyObservableWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyObservableWidgetState();
}

class MyObservableWidgetState extends State<MyObservableWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(height: 100.0, color: Colors.green);
  }
}

class ContainerWithBorder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(), color: Colors.grey),
    );
  }
}

enum VisibilityStats { onscreen, offscreen }

VisibilityStats detectVisibility(GlobalKey widgetKey, BuildContext context) {
  VisibilityStats visStat = VisibilityStats.offscreen;

  final RenderObject? box = widgetKey.currentContext?.findRenderObject();
  if (box != null) {
    final double yPosition = (box as RenderBox).localToGlobal(Offset.zero).dy;
    if (0 < yPosition && yPosition < context.size!.height) {
      visStat = VisibilityStats.onscreen;
    } else {
      visStat = VisibilityStats.offscreen;
    }
  }

  return visStat;
}
