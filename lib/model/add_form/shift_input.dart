import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ShiftTimeInput extends Equatable {
  final TimeOfDay start;
  final TimeOfDay end;

  const ShiftTimeInput({
    required this.start,
    required this.end,
  });

  @override
  List<Object?> get props => [start, end];
}

class ShiftDateInput extends Equatable {
  final String year;
  final String month;
  final String day;

  const ShiftDateInput(
      {required this.year, required this.month, required this.day});

  @override
  List<Object?> get props => [year, month, day];

  @override
  String toString() {
    return day;
  }
}
