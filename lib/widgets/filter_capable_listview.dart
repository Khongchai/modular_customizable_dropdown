import "package:flutter/material.dart";
import 'package:modular_customizable_dropdown/utils/filter_out_values_that_do_not_match_query_string.dart';

class FilterCapableListView extends StatelessWidget {
  final List<String> allDropdownValues;
  final String queryString;
  final Widget Function(String dropdownValue) listBuilder;
  const FilterCapableListView(
      {required this.allDropdownValues,
      required this.queryString,
      required this.listBuilder,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: allDropdownValues.length,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (filterOutValueThatDoNotMatchQueryString(
              queryString: queryString,
              valueToFilter: allDropdownValues[index])) {
            return listBuilder(allDropdownValues[index]);
          }

          return const SizedBox();
        });
  }
}
