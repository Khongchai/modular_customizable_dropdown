import "package:flutter/material.dart";

class SectionDivider extends StatelessWidget {
  const SectionDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: const [
      SizedBox(height: 30),
      Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey,
      ),
      SizedBox(height: 50),
    ]);
  }
}
