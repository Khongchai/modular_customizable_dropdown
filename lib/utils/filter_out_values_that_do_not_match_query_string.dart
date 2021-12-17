List<String> filterOutValuesThatDoNotMatchQueryString(
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
