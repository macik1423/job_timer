import '../model/shift.dart';

class ShiftAccumulator {
  double sum(List<Shift> shifts) {
    return shifts.fold<double>(
        0,
        (p, s) =>
            p +
            s.end!.subtract(s.duration!).difference(s.start!).inSeconds / 60);
  }
}
