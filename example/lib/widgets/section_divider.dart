import "package:flutter/material.dart";

class SectionDivider extends StatelessWidget {
  const SectionDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("called");
    return Column(children: const [
      SizedBox(height: 50),
      Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey,
      ),
      SizedBox(height: 50),
    ]);
  }
}
