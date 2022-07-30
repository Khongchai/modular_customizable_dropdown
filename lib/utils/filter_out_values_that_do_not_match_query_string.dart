import '../classes_and_enums/dropdown_value.dart';

List<DropdownValue> filterOutValuesThatDoNotMatchQueryString(
    {required String queryString,
    required List<DropdownValue> valuesToFilter}) {
  if (queryString == "" || queryString == " ") {
    return valuesToFilter;
  }

  RegExp reg = RegExp(
    "(${RegExp.escape(queryString)})\\S*",
    caseSensitive: false,
    multiLine: false,
  );
  return valuesToFilter.where((e) => reg.hasMatch(e.value)).toList();
}
