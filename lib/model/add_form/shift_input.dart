import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ShiftInput extends Equatable {
  final TimeOfDay start;
  final TimeOfDay end;
  final int day;
  final int month;
  final int year;

  const ShiftInput({
    required this.start,
    required this.end,
    required this.month,
    required this.day,
    required this.year,
  });

  @override
  List<Object?> get props => [start, end, month, day, year];
}
