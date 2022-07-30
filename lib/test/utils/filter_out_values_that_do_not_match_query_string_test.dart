import "package:flutter_test/flutter_test.dart";
import 'package:modular_customizable_dropdown/modular_customizable_dropdown.dart';
import 'package:modular_customizable_dropdown/utils/filter_out_values_that_do_not_match_query_string.dart';

void main() {
  final List<DropdownValue> allValues = DropdownValue.fromListOfStrings(
      ["Hello", "Buongiorno", "Bonjour", "Guten Tag", "Hola"]);

  const f = filterOutValuesThatDoNotMatchQueryString;

  group("Multiple values test", () {
    test("Beginning of word", () {
      expect(f(queryString: "Hel", valuesToFilter: allValues), [allValues[0]]);
      expect(f(queryString: "Buo", valuesToFilter: allValues), [allValues[1]]);
      expect(f(queryString: "Bon", valuesToFilter: allValues), [allValues[2]]);
      expect(f(queryString: "Gute", valuesToFilter: allValues), [allValues[3]]);
      expect(f(queryString: "Ho", valuesToFilter: allValues), [allValues[4]]);
    });

    test("Middle of word", () {
      expect(f(queryString: "lo", valuesToFilter: allValues), [allValues[0]]);
      expect(f(queryString: "on", valuesToFilter: allValues),
          [allValues[1], allValues[2]]);
      expect(f(queryString: "our", valuesToFilter: allValues), [allValues[2]]);
      expect(f(queryString: "Tag", valuesToFilter: allValues), [allValues[3]]);
      expect(f(queryString: "la", valuesToFilter: allValues), [allValues[4]]);
    });

    test("Lower and upper cases", () {
      expect(f(queryString: "B", valuesToFilter: allValues),
          [allValues[1], allValues[2]]);
      expect(f(queryString: "b", valuesToFilter: allValues),
          [allValues[1], allValues[2]]);
      expect(f(queryString: "H", valuesToFilter: allValues),
          [allValues[0], allValues[4]]);
      expect(f(queryString: "h", valuesToFilter: allValues),
          [allValues[0], allValues[4]]);
    });

    test("Empty string", () {
      expect(f(queryString: "", valuesToFilter: allValues), allValues);
    });
  });
}
