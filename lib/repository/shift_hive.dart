import 'package:rxdart/subjects.dart';
import 'package:timer/model/shift.dart';

import '../shift_box.dart';
import '../util/exception.dart';
import '../util/time_util.dart';
import 'shift_api.dart';

class ShiftHiveApi extends ShiftApi {
  late final _shiftController = BehaviorSubject<List<Shift>>.seeded(const []);
  final ShiftBox shiftBox;

  ShiftHiveApi(this.shiftBox) {
    _init();
  }

  Future<void> _init() async {
    final shifts = await getAll();
    _shiftController.sink.add(shifts);
  }

  @override
  Future<List<Shift>> getAll() async {
    final box = await shiftBox.openBox();
    return box.values.toList();
  }

  @override
  Future<void> saveShift(Shift shift) async {
    final box = await shiftBox.openBox();
    final shifts = [..._shiftController.value];
    final shiftIndexStart = shifts.indexWhere((s) {
      final date = TimeUtil.formatDate(s.start);
      return date == TimeUtil.formatDate(shift.start);
    });
    final shiftIndexEnd = shifts.indexWhere((s) {
      final date = TimeUtil.formatDate(s.end);
      return date == TimeUtil.formatDate(shift.end);
    });

    if (shiftIndexStart >= 0 && shiftIndexEnd >= 0) {
      final shift = shifts[shiftIndexStart];
      throw ShiftAlreadyExistsException(
          'Shift ${TimeUtil.formatDate(shift.start)} already exists');
    } else {
      shifts.add(shift);
      _shiftController.add(shifts);
      box.add(shift);
    }
  }

  @override
  Future<void> deleteShift(Shift shift) async {
    final box = await shiftBox.openBox();
    final shifts = [..._shiftController.value];
    shifts.removeWhere((s) => s.start == shift.start && s.end == shift.end);
    _shiftController.add(shifts);
    final Map<dynamic, Shift> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.start == shift.start && value.end == shift.end) {
        desiredKey = key;
      }
    });
    box.delete(desiredKey);
  }

  @override
  Stream<List<Shift>> getShifts() => _shiftController.asBroadcastStream();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShiftHiveApi && other.shiftBox == shiftBox;
  }

  @override
  int get hashCode => shiftBox.hashCode;
}
