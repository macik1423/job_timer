import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:timer/model/add_form/shift_input.dart';

enum AddShiftError { invalid }

class AddShift extends FormzInput<ShiftInput, AddShiftError> {
  static final DateTime now = DateTime.now();
  const AddShift.dirty({
    ShiftInput value = const ShiftInput(
      start: TimeOfDay(hour: 0, minute: 0),
      end: TimeOfDay(hour: 0, minute: 0),
      day: 1,
      month: 1,
      year: 1970,
    ),
  }) : super.dirty(value);
  const AddShift.pure({
    ShiftInput value = const ShiftInput(
      start: TimeOfDay(hour: 0, minute: 0),
      end: TimeOfDay(hour: 0, minute: 0),
      day: 1,
      month: 1,
      year: 1970,
    ),
  }) : super.pure(value);

  @override
  AddShiftError? validator(ShiftInput value) {
    return toDouble(value.start) < toDouble(value.end)
        ? null
        : AddShiftError.invalid;
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
}
