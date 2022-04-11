import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../model/shift.dart';

class ShiftState extends Equatable {
  final Shift shift;
  final bool enabledStart;
  final bool enabledEnd;

  const ShiftState(
    this.shift,
    this.enabledStart,
    this.enabledEnd,
  );

  @override
  List<Object> get props => [shift, enabledStart, enabledEnd];

  Map<String, dynamic> toMap() {
    return {
      'shift': shift.toMap(),
      'enabledStart': enabledStart,
      'enabledEnd': enabledEnd,
    };
  }

  factory ShiftState.fromMap(Map<String, dynamic> map) {
    return ShiftState(
      Shift.fromMap(map['shift']),
      map['enabledStart'] ?? false,
      map['enabledEnd'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShiftState.fromJson(String source) =>
      ShiftState.fromMap(json.decode(source));
}

// zamianiec to na dodanie pola w ShiftState -> ShiftStateStatus
class InitialShiftState extends ShiftState {
  const InitialShiftState({
    required Shift shift,
    required bool enabledStart,
    required bool enabledEnd,
  }) : super(shift, enabledStart, enabledEnd);
}

class StartTapped extends ShiftState {
  const StartTapped({
    required Shift shift,
    required bool enabledStart,
    required bool enabledEnd,
  }) : super(shift, enabledStart, enabledEnd);
}

class EndTapped extends ShiftState {
  const EndTapped({
    required Shift shift,
    required bool enabledStart,
    required bool enabledEnd,
  }) : super(shift, enabledStart, enabledEnd);
}
