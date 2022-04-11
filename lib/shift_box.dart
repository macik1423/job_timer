import 'package:hive/hive.dart';

import 'model/shift.dart';

class ShiftBox {
  static const String boxName = 'shift';
  Future<Box<Shift>> openBox() async {
    return await Hive.openBox<Shift>(boxName);
  }
}
