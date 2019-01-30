import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String text;

  const Label({Key key, @required this.text})
      : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class LabelItem {
  final String text;

  LabelItem(this.text);
}