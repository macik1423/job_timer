import 'package:hive/hive.dart';

import 'model/shift.dart';

class ShiftBox {
  final box = Hive.openBox<Shift>('shift');
}
