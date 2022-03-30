import 'package:hive/hive.dart';
import 'package:rxdart/subjects.dart';
import 'package:timer/model/shift.dart';

import '../exception.dart';
import '../time_util.dart';
import 'shift_api.dart';

class ShiftHiveApi extends ShiftApi {
  late final _shiftController = BehaviorSubject<List<Shift>>.seeded(const []);
  late final _box;
  ShiftHiveApi() {
    _init();
  }

  void _init() async {
    _box = await Hive.openBox<Shift>('shifts');
    // _box.deleteFromDisk();
    final shifts = _box.values.toList();
    _shiftController.sink.add(shifts);
  }

  Future _setValue(shift) async {
    _box.add(shift);
  }

  @override
  Future<void> saveShift(Shift shift) {
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
      return _setValue(shift);
    }
  }

  @override
  Future<void> deleteShift(Shift shift) async {
    final shifts = [..._shiftController.value];
    shifts.removeWhere((s) => s.start == shift.start && s.end == shift.end);
    _shiftController.add(shifts);
    final Map<dynamic, Shift> deliveriesMap = _box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.start == shift.start && value.end == shift.end) {
        desiredKey = key;
      }
    });
    _box.delete(desiredKey);
  }

  @override
  Stream<List<Shift>> getShifts() => _shiftController.asBroadcastStream();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShiftHiveApi && other._box == _box;
  }

  @override
  int get hashCode => _box.hashCode;
}
