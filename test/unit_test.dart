import 'package:flutter_test/flutter_test.dart';
import 'package:timer/model/shift.dart';
import 'package:timer/util/shift_accumulator.dart';

void main() {
  group('shift_accumulator', () {
    test('sum shift duration 1 default (8 hours)', () {
      final List<Shift> shifts = [
        Shift(
          start: DateTime(2020, 1, 1, 8, 0),
          end: DateTime(2020, 1, 1, 16, 0),
        ),
        Shift(
          start: DateTime(2020, 1, 1, 8, 0),
          end: DateTime(2020, 1, 1, 16, 0),
        ),
      ];
      expect(ShiftAccumulator().sum(shifts), 0);
    });

    test('sum shift duration 2', () {
      final List<Shift> shifts = [
        Shift(
          start: DateTime(2020, 1, 1, 8, 0),
          end: DateTime(2020, 1, 1, 16, 0),
          duration: const Duration(hours: 10),
        ),
        Shift(
          start: DateTime(2020, 1, 1, 8, 0),
          end: DateTime(2020, 1, 1, 16, 0),
          duration: const Duration(hours: 7),
        ),
        Shift(
          start: DateTime(2020, 1, 1, 8, 0),
          end: DateTime(2020, 1, 1, 16, 0),
        ),
      ];
      expect(ShiftAccumulator().sum(shifts), -1 * 60);
    });

    test('sum shift duration 3', () {
      final List<Shift> shifts = [
        Shift(
          start: DateTime(2020, 1, 1, 8, 0),
          end: DateTime(2020, 1, 1, 16, 0),
          duration: const Duration(hours: 10),
        ),
        Shift(
          start: DateTime(2020, 1, 1, 8, 0),
          end: DateTime(2020, 1, 1, 16, 0),
        ),
      ];
      expect(ShiftAccumulator().sum(shifts), -2 * 60);
    });
  });
}
