import 'package:flutter/material.dart';
import "package:flutter_test/flutter_test.dart";
import 'package:modular_customizable_dropdown/modular_customizable_dropdown.dart';

const _firstValue =
    DropdownValue(value: "1st value", description: "1st description");
const _secondValue =
    DropdownValue(value: "2nd value", description: "2nd description");

// Description left intentionally empty.
const _thirdValue = DropdownValue(value: "3rd value");
const _fourthValue =
    DropdownValue(value: "4th value", description: "4th description");
const _fifthValue =
    DropdownValue(value: "5th value", description: "5th description");

class _TestWidget extends StatefulWidget {
  final Key? buttonKey;
  final Key? dropdownKey;
  final Key? listviewKey;
  final List<Key>? rowKeys;
  final DropdownStyle dropdownStyle;

  const _TestWidget(
      {required this.dropdownStyle,
      this.listviewKey,
      this.rowKeys,
      this.dropdownKey,
      this.buttonKey,
      Key? key})
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

  void _onValueSelected(DropdownValue selectedValue) {
    setState(() {
      _selectedValue = selectedValue.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SizedBox(
          child: Align(
              child: ModularCustomizableDropdown.displayOnTap(
                  listviewKey: widget.listviewKey,
                  rowKeys: widget.rowKeys,
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
    group(
        "given some arbitrary height, the rendered dropdown's visible "
        "height should be exactly the same. If the height does not exceed the height of "
        "al rows combined.", () {
      testWidgets("height 100", (tester) async {
        const listviewKey = Key("listview key");
        const buttonKey = Key("button key");
        const expectedHeight = 100.0;

        await tester.pumpWidget(const _TestWidget(
          listviewKey: listviewKey,
          buttonKey: buttonKey,
          dropdownStyle: DropdownStyle(
            dropdownMaxHeight: DropdownMaxHeight(
              byPixels: expectedHeight,
            ),
          ),
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(buttonKey));
        await tester.pumpAndSettle();

        final listview = find.byKey(listviewKey);
        final listviewSize = tester.getSize(listview);

        expect(listviewSize.height, expectedHeight);
      });

      testWidgets("height 200", (tester) async {
        const listviewKey = Key("listview key");
        const buttonKey = Key("button key");
        const expectedHeight = 200.0;

        await tester.pumpWidget(const _TestWidget(
          listviewKey: listviewKey,
          buttonKey: buttonKey,
          dropdownStyle: DropdownStyle(
            dropdownMaxHeight: DropdownMaxHeight(
              byPixels: expectedHeight,
            ),
          ),
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(buttonKey));
        await tester.pumpAndSettle();

        final listview = find.byKey(listviewKey);
        final listviewSize = tester.getSize(listview);

        expect(listviewSize.height, expectedHeight);
      });
    });

    group("DropdownValues whose index >= byRows should not be rendered.", () {
      testWidgets(
        "byRows == 3",
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
        "byRows == 4",
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
        "byRows == 5, all should be visible",
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

    /// We can't just use expect(find.text(...)) here because different fractions
    /// can give out different ray-casting result(when it's partially hidden).
    ///
    /// Finding out which fraction counts as being visible to the ray-caster
    /// would take too much effort. We'll instead check if the height of the
    /// visible dropdown is equals to the height of all rows plus the last fractional
    /// height.
    ///
    group("Fractional byRows test", () {
      void fractionalRowTestFor({
        required WidgetTester tester,
        required double byRows,
      }) async {
        const listviewKey = Key("listviewKey");
        const buttonKey = Key("buttonKey");
        final rowKeys =
            List.generate(5, (index) => Key("row at " + index.toString()));

        final lastRowFraction = byRows % 1 == 0 ? 1 : byRows % 1;
        final rowCount = byRows.ceil();

        await tester.pumpWidget(_TestWidget(
          listviewKey: listviewKey,
          buttonKey: buttonKey,
          rowKeys: rowKeys,
          dropdownStyle: DropdownStyle(
            dropdownMaxHeight: DropdownMaxHeight(
              // Ex. 3 - 0.5 = 2.5; 3 rows with last row having half its height.
              byRows: byRows,
            ),
          ),
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(buttonKey));
        await tester.pumpAndSettle();

        final listview = find.byKey(listviewKey);

        double rowsHeight = 0;
        for (int i = 0; i < rowCount; i++) {
          final bool lastRow = i == rowCount - 1;
          final heightFraction = (lastRow ? lastRowFraction : 1);
          final thisRowHeight =
              tester.getSize(find.byKey(rowKeys[i])).height * heightFraction;
          rowsHeight += thisRowHeight;
        }

        final listviewHeight = tester.getSize(listview).height;

        expect(rowsHeight, listviewHeight);
      }

      testWidgets(
          "byRows == 2.5; total dropdown height should be row1Height + row2Height + (row3Height * 0.5)",
          (tester) async {
        fractionalRowTestFor(tester: tester, byRows: 2.5);
      });
      testWidgets(
          "byRows == 3.2; total dropdown height should be row1Height + (row2Height * 0.2)",
          (tester) async {
        fractionalRowTestFor(tester: tester, byRows: 1.2);
      });
      testWidgets(
          "byRows == 3.2; total dropdown height should be row1Height + row2Height + row3Height + (row4Height * 0.8)",
          (tester) async {
        fractionalRowTestFor(tester: tester, byRows: 3.8);
      });
      testWidgets("byRows == 1; total dropdown height should be row1Height",
          (tester) async {
        fractionalRowTestFor(tester: tester, byRows: 1);
      });
      testWidgets(
          "byRows == 3.1234; total dropdown height should be row1Height + row2Height + row3Height + (row4Height * 0.1234)",
          (tester) async {
        fractionalRowTestFor(tester: tester, byRows: 3.1234);
      });
      testWidgets(
          "byRows == 4.567; total dropdown height should be row1Height + row2Height + row3Height + row4Height + (row5Height * 0.567)",
          (tester) async {
        fractionalRowTestFor(tester: tester, byRows: 4.567);
      });
      testWidgets(
          "byRows == 5; total dropdown height should be row1Height + row2Height + row3Height + row4Height + row5Height",
          (tester) async {
        fractionalRowTestFor(tester: tester, byRows: 5);
      });
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
        dropdownStyle: DropdownStyle(),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(buttonKey));

      await tester.pumpAndSettle();
      final secondValueButton = find.text(valueToSelect);

      await tester.tap(secondValueButton);
      await tester.pumpAndSettle();

      expect(find.text(valueToSelect), findsOneWidget);
    });

    group("Layout", () {
      group("Dropdown width", () {
        testWidgets("Width scale 1", (tester) async {
          const dropdownKey = Key("Dropdown Key");
          const buttonKey = Key("Button Key");

          await tester.pumpWidget(const _TestWidget(
              dropdownKey: dropdownKey,
              buttonKey: buttonKey,
              dropdownStyle: DropdownStyle(
                  dropdownWidth: DropdownWidth(
                scale: 1,
              ))));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(buttonKey));
          await tester.pumpAndSettle();

          final dropdownWidth = tester.getSize(find.byKey(dropdownKey));
          final targetWidth = tester.getSize(find.byKey(buttonKey));
          expect(dropdownWidth.width, targetWidth.width);
        });

        testWidgets("Width scale 0.5", (tester) async {
          const dropdownKey = Key("Dropdown Key");
          const buttonKey = Key("Button Key");

          await tester.pumpWidget(const _TestWidget(
              dropdownKey: dropdownKey,
              buttonKey: buttonKey,
              dropdownStyle: DropdownStyle(
                  dropdownWidth: DropdownWidth(
                scale: 0.5,
              ))));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(buttonKey));
          await tester.pumpAndSettle();

          final dropdownWidth = tester.getSize(find.byKey(dropdownKey));
          final targetWidth = tester.getSize(find.byKey(buttonKey));
          expect(dropdownWidth.width, targetWidth.width * 0.5);
        });

        testWidgets("Width scale 1.3", (tester) async {
          const dropdownKey = Key("Dropdown Key");
          const buttonKey = Key("Button Key");

          await tester.pumpWidget(const _TestWidget(
              dropdownKey: dropdownKey,
              buttonKey: buttonKey,
              dropdownStyle: DropdownStyle(
                  dropdownWidth: DropdownWidth(
                scale: 1.3,
              ))));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(buttonKey));
          await tester.pumpAndSettle();

          final dropdownWidth = tester.getSize(find.byKey(dropdownKey));
          final targetWidth = tester.getSize(find.byKey(buttonKey));

          expect(dropdownWidth.width, targetWidth.width * 1.3);
        });
      });
    });
  });
}
