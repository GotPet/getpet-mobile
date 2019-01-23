import 'package:flutter/material.dart';

class AppProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var baseTheme = Theme.of(context);
    return Theme(
      data: baseTheme.copyWith(accentColor: baseTheme.primaryColor),
      child: new CircularProgressIndicator(),
    );
  }
}
