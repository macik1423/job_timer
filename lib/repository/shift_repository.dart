import 'package:timer/model/shift.dart';
import 'package:timer/repository/shift_api.dart';

class ShiftRepository {
  final ShiftApi _shiftApi;

  ShiftRepository({required ShiftApi shiftApi}) : _shiftApi = shiftApi;

  Stream<List<Shift>> getShifts() {
    return _shiftApi.getShifts();
  }

  Future<void> saveShift(Shift shift) {
    return _shiftApi.saveShift(shift);
  }

  Future<void> deleteShift(Shift shift) async {
    _shiftApi.deleteShift(shift);
  }

  Future<List<Shift>> getAll() async {
    return await _shiftApi.getAll();
  }
}
