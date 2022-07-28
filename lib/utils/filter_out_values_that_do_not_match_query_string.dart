import '../classes_and_enums/dropdown_value_and_description.dart';

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

bool filterOutValueThatDoNotMatchQueryString(
    {required String queryString, required String valueToFilter}) {
  if (queryString == "" || queryString == " ") {
    return true;
  }

  RegExp reg = RegExp(
    "(${RegExp.escape(queryString)})\\S*",
    caseSensitive: false,
    multiLine: false,
  );

  return reg.hasMatch(valueToFilter);
}
