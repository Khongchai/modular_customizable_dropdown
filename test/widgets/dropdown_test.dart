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
  final Key? toggleDropdownButtonKey;
  final Key? dropdownKey;
  final Key? targetKey;
  final Key? listviewKey;
  final List<Key>? rowKeys;
  final Alignment? testContainerAlignment;
  final DropdownStyle? dropdownStyle;
  final List<DropdownValue>? dropdownValues;

  const _TestWidget(
      {this.dropdownStyle,
      this.testContainerAlignment,
      this.dropdownValues,
      this.listviewKey,
      this.rowKeys,
      this.targetKey,
      this.dropdownKey,
      this.toggleDropdownButtonKey,
      Key? key})
      : super(key: key);

  @override
  State<_TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<_TestWidget> {
  late final List<DropdownValue> _valuesList;

  String _selectedValue = "";

  @override
  void initState() {
    super.initState();

    _valuesList = widget.dropdownValues ??
        DropdownValue.fromListOfStrings([
          "1st value",
          "2nd value",
          "3rd value",
          "4th value",
          "5th value",
        ]);
  }

  void _onValueSelected(DropdownValue selectedValue) {
    setState(() {
      _selectedValue = selectedValue.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
            child: Align(
                alignment: widget.testContainerAlignment ?? Alignment.center,
                child: ModularCustomizableDropdown.displayOnTap(
                    listviewKey: widget.listviewKey,
                    rowKeys: widget.rowKeys,
                    overlayEntryKey: widget.dropdownKey,
                    onValueSelect: _onValueSelected,
                    style: widget.dropdownStyle ?? const DropdownStyle(),
                    allDropdownValues: _valuesList,
                    target: Column(
                      mainAxisSize: MainAxisSize.min,
                      key: widget.targetKey,
                      children: [
                        Text(_selectedValue),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          key: widget.toggleDropdownButtonKey,
                          // Do nothing
                          onPressed: () {},
                          child: const Text("Expand Dropdown"),
                        ),
                      ],
                    )))),
      ),
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
          toggleDropdownButtonKey: buttonKey,
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
          toggleDropdownButtonKey: buttonKey,
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
            toggleDropdownButtonKey: buttonKey,
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
        "byRows == 3 with different scale",
        (tester) async {
          const buttonKey = Key("Button key");

          await tester.pumpWidget(const _TestWidget(
            toggleDropdownButtonKey: buttonKey,
            dropdownStyle: DropdownStyle(
              alignment: Alignment.bottomRight,
              dropdownWidth: DropdownWidth(scale: 1.5),
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
        "byRows == 3 with a fixed width",
        (tester) async {
          const buttonKey = Key("Button key");

          await tester.pumpWidget(const _TestWidget(
            toggleDropdownButtonKey: buttonKey,
            dropdownStyle: DropdownStyle(
              alignment: Alignment.bottomRight,
              dropdownWidth: DropdownWidth(byPixels: 400),
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
            toggleDropdownButtonKey: buttonKey,
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
        "byRows == 4 with a different scale.",
        (tester) async {
          const buttonKey = Key("Button key");

          await tester.pumpWidget(const _TestWidget(
            toggleDropdownButtonKey: buttonKey,
            dropdownStyle: DropdownStyle(
              alignment: Alignment.topLeft,
              dropdownWidth: DropdownWidth(
                scale: 0.6,
              ),
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
        "byRows == 4 with a fixed width.",
        (tester) async {
          const buttonKey = Key("Button key");

          await tester.pumpWidget(const _TestWidget(
            toggleDropdownButtonKey: buttonKey,
            dropdownStyle: DropdownStyle(
              alignment: Alignment.topLeft,
              dropdownWidth: DropdownWidth(byPixels: 100),
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
            toggleDropdownButtonKey: buttonKey,
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

      testWidgets(
        "byRows == 5, with a different scale",
        (tester) async {
          const buttonKey = Key("Button key");

          await tester.pumpWidget(const _TestWidget(
            toggleDropdownButtonKey: buttonKey,
            dropdownStyle: DropdownStyle(
              dropdownWidth: DropdownWidth(scale: .5),
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

      testWidgets(
        "byRows == 5, with a fixed width",
        (tester) async {
          const buttonKey = Key("Button key");

          await tester.pumpWidget(const _TestWidget(
            toggleDropdownButtonKey: buttonKey,
            dropdownStyle: DropdownStyle(
              dropdownWidth: DropdownWidth(byPixels: 200),
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

    // We can't just use expect(find.text(...)) here because different fractions
    // can give out different ray-casting result(when it's partially hidden).
    //
    // Finding out which fraction counts as being visible to the ray-caster
    // would take too much effort. We'll instead check if the height of the
    // visible dropdown is equals to the height of all rows plus the last fractional
    // height.
    //
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
          toggleDropdownButtonKey: buttonKey,
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

    // Note: Screen width doesn't really matter
    group("Dropdown's position", () {
      group(
          "Dropdown should wrap around when it finds that its top will overflow the screen",
          () {
        // Make sure that the target is rendered at the top of the screen.
        // Set the dropdown's alignment to Alignment.top...
        // When expanded, expect the top section of the dropdown to be equals
        // to the bottom of the target.
        testWidgets("Top alignment, wraps to bottom", (tester) async {
          const listviewKey = Key("listviewKey");
          const buttonKey = Key("buttonKey");
          const targetKey = Key("targetKey");

          await tester.pumpWidget(const _TestWidget(
            listviewKey: listviewKey,
            toggleDropdownButtonKey: buttonKey,
            targetKey: targetKey,
            testContainerAlignment: Alignment.topCenter,
            dropdownStyle: DropdownStyle(
                invertYAxisAlignmentWhenOverflow: true,
                alignment: Alignment.topCenter),
          ));
          await tester.pumpAndSettle();

          final target = find.byKey(targetKey);
          await tester.tap(target);
          await tester.pumpAndSettle();

          final targetSize = tester.getSize(target);
          final dropdown = find.byKey(listviewKey);
          final dropdownAbsoluteTop = tester.getCenter(dropdown).dy -
              tester.getSize(dropdown).height / 2;
          final targetAbsoluteBottom =
              tester.getCenter(target).dy + targetSize.height / 2;

          expect(dropdownAbsoluteTop, targetAbsoluteBottom);
        });
      });

      group(
          "Dropdown should wrap around when it finds that its bottom will overflow the screen",
          () {
        // Make sure that the target is rendered at the bottom of the screen.
        // Set the dropdown's alignment to Alignment.bottom...
        // When expanded, expect the bottom of the dropdown to be equals to the
        // top of the target.
        testWidgets("Bottom alignment, wraps to top", (tester) async {
          const listviewKey = Key("listviewKey");
          const buttonKey = Key("buttonKey");
          const targetKey = Key("targetKey");

          await tester.pumpWidget(const _TestWidget(
            listviewKey: listviewKey,
            toggleDropdownButtonKey: buttonKey,
            targetKey: targetKey,
            testContainerAlignment: Alignment.bottomCenter,
            dropdownStyle: DropdownStyle(
                invertYAxisAlignmentWhenOverflow: true,
                alignment: Alignment.bottomCenter),
          ));
          await tester.pumpAndSettle();

          final target = find.byKey(targetKey);
          await tester.tap(target);
          await tester.pumpAndSettle();

          final dropdown = find.byKey(listviewKey);
          final dropdownSize = tester.getSize(dropdown);
          final targetAbsoluteTop =
              tester.getCenter(target).dy - tester.getSize(target).height / 2;
          final dropdownAbsoluteBottom =
              tester.getCenter(dropdown).dy + dropdownSize.height / 2;

          expect(dropdownAbsoluteBottom, targetAbsoluteTop);
        });
      });

      // If after wrapping around, the dropdown finds that it will still overflow the screen,
      // it should try to limit its visible height and have the user scroll the rest.
      group(
          "The visible part (the listview part) of the dropdown should never overflow the screen.",
          () {
        // Steps
        // Find the position of the target's absolute top
        // Give the dropdown the alignment of Alignment.top...
        // Make sure the dropdown's invertYAxisAlignmentWhenOverflow is false
        // Give the dropdown a really long list of values to ensure overflow.
        // Assert that the listview's height == target's top offset
        group("Top alignments", () {
          void testTopOverflow(
            WidgetTester tester, {
            required int valueCount,
            required Alignment alignment,
          }) async {
            const listviewKey = Key("listviewKey");
            const buttonKey = Key("buttonKey");
            const targetKey = Key("targetKey");

            await tester.pumpWidget(_TestWidget(
              listviewKey: listviewKey,
              targetKey: targetKey,
              toggleDropdownButtonKey: buttonKey,
              dropdownValues: DropdownValue.fromListOfStrings(
                  List.generate(valueCount, (index) => "Dummy value")),
              dropdownStyle: DropdownStyle(
                  dropdownMaxHeight: DropdownMaxHeight(
                    byRows: valueCount.toDouble(),
                  ),
                  invertYAxisAlignmentWhenOverflow: false,
                  alignment: alignment),
            ));
            await tester.pumpAndSettle();

            final target = find.byKey(targetKey);
            await tester.tap(target);
            await tester.pumpAndSettle();

            final targetSize = tester.getSize(target);
            final dropdownVisibleSize = tester.getSize(find.byKey(listviewKey));
            final targetAbsoluteTop =
                tester.getCenter(target).dy - targetSize.height / 2;

            expect(dropdownVisibleSize.height, targetAbsoluteTop);
          }

          testWidgets("Alignment.topLeft", (tester) async {
            testTopOverflow(tester,
                valueCount: 100, alignment: Alignment.topLeft);
          });
          testWidgets("Alignment.topCenter", (tester) async {
            testTopOverflow(tester,
                valueCount: 100, alignment: Alignment.topCenter);
          });
          testWidgets("Alignment.topRight", (tester) async {
            testTopOverflow(tester,
                valueCount: 100, alignment: Alignment.topRight);
          });
        });
        group("Center alignments", () {
          void testTopAndBottomOverflow(
            WidgetTester tester, {
            required int valueCount,
            required Alignment alignment,
          }) async {
            const listviewKey = Key("listviewKey");
            const buttonKey = Key("buttonKey");
            const targetKey = Key("targetKey");

            await tester.pumpWidget(_TestWidget(
              listviewKey: listviewKey,
              targetKey: targetKey,
              toggleDropdownButtonKey: buttonKey,
              dropdownValues: DropdownValue.fromListOfStrings(
                  List.generate(valueCount, (index) => "Dummy value")),
              dropdownStyle: DropdownStyle(
                  dropdownMaxHeight: DropdownMaxHeight(
                    byRows: valueCount.toDouble(),
                  ),
                  invertYAxisAlignmentWhenOverflow: false,
                  alignment: alignment),
            ));
            await tester.pumpAndSettle();

            final target = find.byKey(targetKey);
            await tester.tap(target);
            await tester.pumpAndSettle();

            final screenSize = tester.getSize(find.byType(Scaffold));
            final dropdownVisibleSize = tester.getSize(find.byKey(listviewKey));

            expect(dropdownVisibleSize.height, screenSize.height);
          }

          testWidgets("Left center align", (tester) async {
            testTopAndBottomOverflow(tester,
                valueCount: 100, alignment: Alignment.centerLeft);
          });
          testWidgets("Center align", (tester) async {
            testTopAndBottomOverflow(tester,
                valueCount: 100, alignment: Alignment.center);
          });
          testWidgets("Right center align", (tester) async {
            testTopAndBottomOverflow(tester,
                valueCount: 100, alignment: Alignment.centerRight);
          });
        });
        // Steps
        // Find the position of the target's absolute bottom
        // Give the dropdown the alignment of Alignment.bottom...
        // Make sure the dropdown's invertYAxisAlignmentWhenOverflow is false
        // Give the dropdown a really long list of values to ensure overflow.
        // Assert that the listview's height is exactly the screenHeight - target's bottom
        group("Bottom alignments", () {
          void testBottomOverflow(
            WidgetTester tester, {
            required int valueCount,
            required Alignment alignment,
          }) async {
            const listviewKey = Key("listviewKey");
            const buttonKey = Key("buttonKey");
            const targetKey = Key("targetKey");

            await tester.pumpWidget(_TestWidget(
              listviewKey: listviewKey,
              toggleDropdownButtonKey: buttonKey,
              targetKey: targetKey,
              dropdownValues: DropdownValue.fromListOfStrings(
                  List.generate(valueCount, (index) => "Dummy value")),
              dropdownStyle: DropdownStyle(
                  dropdownMaxHeight: DropdownMaxHeight(
                    byRows: valueCount.toDouble(),
                  ),
                  invertYAxisAlignmentWhenOverflow: false,
                  alignment: alignment),
            ));
            await tester.pumpAndSettle();

            final target = find.byKey(targetKey);
            await tester.tap(target);
            await tester.pumpAndSettle();

            final screenSize = tester.getRect(find.byType(Scaffold));
            final targetSize = tester.getSize(target);
            final dropdownVisibleHeight =
                tester.getSize(find.byKey(listviewKey));
            final targetAbsoluteBottom =
                tester.getCenter(target).dy + targetSize.height / 2;

            expect(screenSize.height - targetAbsoluteBottom,
                dropdownVisibleHeight.height);
          }

          testWidgets("Bottom center", (tester) async {
            testBottomOverflow(tester,
                valueCount: 100, alignment: Alignment.bottomCenter);
          });
          testWidgets("Bottom left", (tester) async {
            testBottomOverflow(tester,
                valueCount: 100, alignment: Alignment.bottomLeft);
          });
          testWidgets("Bottom right", (tester) async {
            testBottomOverflow(tester,
                valueCount: 100, alignment: Alignment.bottomRight);
          });
        });
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
        toggleDropdownButtonKey: buttonKey,
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
        toggleDropdownButtonKey: buttonKey,
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
          const targetKey = Key("Target key");

          await tester.pumpWidget(const _TestWidget(
              dropdownKey: dropdownKey,
              targetKey: targetKey,
              dropdownStyle: DropdownStyle(
                  dropdownWidth: DropdownWidth(
                scale: 1,
              ))));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(targetKey));
          await tester.pumpAndSettle();

          final dropdownWidth = tester.getSize(find.byKey(dropdownKey));
          final targetWidth = tester.getSize(find.byKey(targetKey));
          expect(dropdownWidth.width, targetWidth.width);
        });

        testWidgets("Width scale 0.5", (tester) async {
          const dropdownKey = Key("Dropdown Key");
          const targetKey = Key("Target key");

          await tester.pumpWidget(const _TestWidget(
              dropdownKey: dropdownKey,
              toggleDropdownButtonKey: targetKey,
              dropdownStyle: DropdownStyle(
                  dropdownWidth: DropdownWidth(
                scale: 0.5,
              ))));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(targetKey));
          await tester.pumpAndSettle();

          final dropdownWidth = tester.getSize(find.byKey(dropdownKey));
          final targetWidth = tester.getSize(find.byKey(targetKey));
          expect(dropdownWidth.width, targetWidth.width * 0.5);
        });

        testWidgets("Width scale 1.3", (tester) async {
          const dropdownKey = Key("Dropdown Key");
          const buttonKey = Key("Target Key");

          await tester.pumpWidget(const _TestWidget(
              dropdownKey: dropdownKey,
              toggleDropdownButtonKey: buttonKey,
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

    // No need for any assertions, if no errors are thrown, all is well.
    group("Smoke and edge case tests", () {
      testWidgets("#1 Removing items from a list the dropdown is referencing",
          (tester) async {
        const buttonKey = Key("Button key");
        const dropdownKey = Key("Dropdown key");
        final dropdownValues = [_firstValue, _secondValue, _thirdValue];

        Future<void> toggleDropdownAndTap(String value) async {
          await tester.tap(find.byKey(buttonKey));
          await tester.pumpAndSettle();

          expect(find.byKey(dropdownKey), findsOneWidget);
          final firstValueButton = find.text(value);
          expect(firstValueButton, findsOneWidget);
          await tester.tap(firstValueButton);
          await tester.pumpAndSettle();
          expect(find.byKey(dropdownKey), findsNothing);
        }

        await tester.pumpWidget(_TestWidget(
          dropdownKey: dropdownKey,
          toggleDropdownButtonKey: buttonKey,
          dropdownValues: dropdownValues,
        ));
        await tester.pumpAndSettle();

        await toggleDropdownAndTap(_firstValue.value);

        dropdownValues.removeLast();

        await toggleDropdownAndTap(_secondValue.value);
      });
    });
  });
}
