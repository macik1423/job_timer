import '../model/shift.dart';

abstract class ShiftApi {
  const ShiftApi();

  Stream<List<Shift>> getShifts();
  Future<void> saveShift(Shift shift);
  Future<void> deleteShift(Shift shift);
}
