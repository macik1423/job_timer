import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timer/model/shift.dart';
import 'package:timer/util/shift_accumulator.dart';
import 'package:timer/util/time_of_day_converter_extension.dart';

void main() {
  group('shift_accumulator', () {
    test('sum shift duration 1 default (8 hours)', () {
      final List<Shift> shifts = [
        Shift(
          start: DateTime(2020, 1, 1, 8, 0),
          end: DateTime(2020, 1, 1, 16, 0),
        ),
        Shift(
          start: DateTime(2020, 1, 2, 8, 0),
          end: DateTime(2020, 1, 2, 16, 0),
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
          start: DateTime(2020, 1, 2, 8, 0),
          end: DateTime(2020, 1, 2, 16, 0),
          duration: const Duration(hours: 7),
        ),
        Shift(
          start: DateTime(2020, 1, 3, 8, 0),
          end: DateTime(2020, 1, 3, 16, 0),
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
          start: DateTime(2020, 1, 2, 8, 0),
          end: DateTime(2020, 1, 2, 16, 0),
        ),
      ];
      expect(ShiftAccumulator().sum(shifts), -2 * 60);
    });

    test('sum shift duration 4', () {
      final List<Shift> shifts = [
        Shift(
          start: DateTime(2020, 1, 1, 8, 0),
          end: DateTime(2020, 1, 1, 16, 0),
          duration: const Duration(hours: 10),
        ),
        Shift(
          start: DateTime(2020, 1, 2, 8, 0),
          end: DateTime(2020, 1, 2, 16, 0),
        ),
        Shift(
          start: DateTime(2020, 1, 3, 8, 0),
          end: DateTime(2020, 1, 3, 16, 0),
          duration: const Duration(hours: 10),
        ),
        Shift(
          start: DateTime(2020, 1, 4, 8, 0),
          end: DateTime(2020, 1, 4, 17, 0),
        ),
      ];
      expect(ShiftAccumulator().sum(shifts), -3 * 60);
    });
  });

  group('time_of_day_converter_extension', () {
    test('one digit h, one digit m', () {
      const timeOfDay = TimeOfDay(hour: 1, minute: 1);
      expect(timeOfDay.to24hours(), '01:01');
    });

    test('two digits h, one digit m', () {
      const timeOfDay = TimeOfDay(hour: 11, minute: 1);
      expect(timeOfDay.to24hours(), '11:01');
    });

    test('two digits h, two digits m', () {
      const timeOfDay = TimeOfDay(hour: 11, minute: 10);
      expect(timeOfDay.to24hours(), '11:10');
    });

    test('one digit h, two digits m', () {
      const timeOfDay = TimeOfDay(hour: 1, minute: 10);
      expect(timeOfDay.to24hours(), '01:10');
    });

    test('00 : 00', () {
      const timeOfDay = TimeOfDay(hour: 0, minute: 0);
      expect(timeOfDay.to24hours(), '00:00');
    });

    test('24 : 00', () {
      const timeOfDay = TimeOfDay(hour: 24, minute: 0);
      expect(timeOfDay.to24hours(), '24:00');
    });
  });
}
