import 'package:flutter/material.dart';
import "package:flutter_test/flutter_test.dart";
import 'package:modular_customizable_dropdown/modular_customizable_dropdown.dart';

const _firstValue = DropdownValue(value: "1st value");
const _secondValue = DropdownValue(value: "2nd value");
const _thirdValue = DropdownValue(value: "3rd value");
const _fourthValue = DropdownValue(value: "4th value");
const _fifthValue = DropdownValue(value: "5th value");

class _TestWidget extends StatefulWidget {
  final Key? buttonKey;
  final Key? dropdownKey;
  final DropdownStyle dropdownStyle;

  const _TestWidget(
      {required this.dropdownStyle, this.dropdownKey, this.buttonKey, Key? key})
      : super(key: key);

  @override
  State<_TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<_TestWidget> {
  final List<DropdownValue> _valuesList = DropdownValue.fromListOfStrings([
    "1st value",
    "2nd value",
    "3rd value",
    "4th value",
    "5th value",
  ]);

  String _selectedValue = "";

  void _onValueSelected(String selectedValue) {
    setState(() {
      _selectedValue = selectedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SizedBox(
          child: Align(
              child: ModularCustomizableDropdown.displayOnTap(
                  overlayEntryKey: widget.dropdownKey,
                  onValueSelect: _onValueSelected,
                  style: widget.dropdownStyle,
                  allDropdownValues: _valuesList,
                  target: Column(
                    children: [
                      Text(_selectedValue),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        key: widget.buttonKey,
                        // Do nothing
                        onPressed: () {},
                        child: const Text("Expand Dropdown"),
                      ),
                    ],
                  )))),
    );
  }
}

void main() {
  group("Test max rows visible on expanded", () {
    group("DropdownValues whose index > maxRows - 1 should not be rendered.",
        () {
      testWidgets(
        "maxRows == 3",
        (tester) async {
          const buttonKey = Key("Button key");

          await tester.pumpWidget(const _TestWidget(
            buttonKey: buttonKey,
            dropdownStyle: DropdownStyle(
              dropdownMaxHeight: DropdownMaxHeight(
                byRows: 3,
              ),
            ),
          ));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(buttonKey));
          await tester.pumpAndSettle();

          expect(find.text(_firstValue.value), findsOneWidget);
          expect(find.text(_secondValue.value), findsOneWidget);
          expect(find.text(_thirdValue.value), findsOneWidget);

          // Should not be visible
          expect(find.text(_fourthValue.value), findsNothing);
          expect(find.text(_fifthValue.value), findsNothing);
        },
      );

      testWidgets(
        "maxRows == 4",
        (tester) async {
          const buttonKey = Key("Button key");

          await tester.pumpWidget(const _TestWidget(
            buttonKey: buttonKey,
            dropdownStyle: DropdownStyle(
              dropdownMaxHeight: DropdownMaxHeight(
                byRows: 4,
              ),
            ),
          ));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(buttonKey));
          await tester.pumpAndSettle();

          expect(find.text(_firstValue.value), findsOneWidget);
          expect(find.text(_secondValue.value), findsOneWidget);
          expect(find.text(_thirdValue.value), findsOneWidget);
          expect(find.text(_fourthValue.value), findsOneWidget);

          // Should not be visible
          expect(find.text(_fifthValue.value), findsNothing);
        },
      );

      testWidgets(
        "maxRows == 5, all should be visible",
        (tester) async {
          const buttonKey = Key("Button key");

          await tester.pumpWidget(const _TestWidget(
            buttonKey: buttonKey,
            dropdownStyle: DropdownStyle(
              dropdownMaxHeight: DropdownMaxHeight(
                byRows: 5,
              ),
            ),
          ));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(buttonKey));
          await tester.pumpAndSettle();

          expect(find.text(_firstValue.value), findsOneWidget);
          expect(find.text(_secondValue.value), findsOneWidget);
          expect(find.text(_thirdValue.value), findsOneWidget);
          expect(find.text(_fourthValue.value), findsOneWidget);
          expect(find.text(_fifthValue.value), findsOneWidget);
        },
      );

      //
    });
  });

  group("When one of the values is tapped", () {
    testWidgets("The entire thing should be dismissed", (tester) async {
      const buttonKey = Key("Button key");
      const dropdownKey = Key("Dropdown key");

      expect(find.byKey(dropdownKey), findsNothing);

      await tester.pumpWidget(const _TestWidget(
        dropdownKey: dropdownKey,
        buttonKey: buttonKey,
        dropdownStyle: DropdownStyle(
          dropdownMaxHeight: DropdownMaxHeight(
            byRows: 5,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(buttonKey));
      await tester.pumpAndSettle();

      expect(find.byKey(dropdownKey), findsOneWidget);

      final firstValueButton = find.text(_firstValue.value);

      expect(firstValueButton, findsOneWidget);

      await tester.tap(firstValueButton);
      await tester.pumpAndSettle();

      expect(find.byKey(dropdownKey), findsNothing);
    });

    testWidgets("The selected value text on the screen should change.",
        (tester) async {
      final valueToSelect = _secondValue.value;
      expect(find.text(valueToSelect), findsNothing);

      const buttonKey = Key("Button key");

      await tester.pumpWidget(const _TestWidget(
        buttonKey: buttonKey,
        dropdownStyle: DropdownStyle(
          dropdownMaxHeight: DropdownMaxHeight(
            byRows: 5,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(buttonKey));

      await tester.pumpAndSettle();
      final secondValueButton = find.text(valueToSelect);

      await tester.tap(secondValueButton);
      await tester.pumpAndSettle();

      expect(find.text(valueToSelect), findsOneWidget);
    });
  });
}
