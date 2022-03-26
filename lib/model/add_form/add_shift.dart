import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:timer/model/add_form/shift_input.dart';

enum AddShiftError { invalid }

class AddShiftTime extends FormzInput<ShiftTimeInput, AddShiftError> {
  const AddShiftTime.dirty({
    ShiftTimeInput value = const ShiftTimeInput(
      start: TimeOfDay(hour: 0, minute: 0),
      end: TimeOfDay(hour: 0, minute: 0),
    ),
  }) : super.dirty(value);
  const AddShiftTime.pure({
    ShiftTimeInput value = const ShiftTimeInput(
      start: TimeOfDay(hour: 0, minute: 0),
      end: TimeOfDay(hour: 0, minute: 0),
    ),
  }) : super.pure(value);

  @override
  AddShiftError? validator(ShiftTimeInput value) {
    return toDouble(value.start) < toDouble(value.end)
        ? null
        : AddShiftError.invalid;
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
}

class AddShiftDate extends FormzInput<ShiftDateInput, AddShiftError> {
  const AddShiftDate.dirty({
    ShiftDateInput value = const ShiftDateInput(year: '', month: '', day: ''),
  }) : super.dirty(value);
  const AddShiftDate.pure({
    ShiftDateInput value = const ShiftDateInput(year: '', month: '', day: ''),
  }) : super.pure(value);

  @override
  AddShiftError? validator(ShiftDateInput value) {
    return value.year.isNotEmpty &&
            value.month.isNotEmpty &&
            value.day.isNotEmpty
        ? null
        : AddShiftError.invalid;
  }
}
