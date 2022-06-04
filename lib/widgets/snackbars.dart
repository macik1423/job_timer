import 'package:flutter/material.dart';

class PositiveSnackBar extends SnackBar {
  const PositiveSnackBar({Key? key, required Widget content})
      : super(content: content, backgroundColor: Colors.green, key: key);
}
