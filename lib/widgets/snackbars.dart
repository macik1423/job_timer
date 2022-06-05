import 'package:flutter/material.dart';

class PositiveSnackBar extends SnackBar {
  const PositiveSnackBar({Key? key, required Widget content})
      : super(content: content, backgroundColor: Colors.green, key: key);
}

class NegativeSnackBar extends SnackBar {
  const NegativeSnackBar({Key? key, required Widget content})
      : super(content: content, backgroundColor: Colors.red, key: key);
}
