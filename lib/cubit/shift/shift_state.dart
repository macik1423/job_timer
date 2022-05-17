import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../model/shift.dart';

enum ShiftStateStatus { initial, startTapped, endTapped }

class ShiftState extends Equatable {
  final Shift shift;
  final bool enabledStart;
  final bool enabledEnd;
  final ShiftStateStatus status;

  const ShiftState({
    required this.shift,
    required this.enabledStart,
    required this.enabledEnd,
    required this.status,
  });

  @override
  List<Object> get props => [shift, enabledStart, enabledEnd, status];

  Map<String, dynamic> toMap() {
    return {
      'shift': shift.toMap(),
      'enabledStart': enabledStart,
      'enabledEnd': enabledEnd,
      'status': status.index,
    };
  }

  factory ShiftState.fromMap(Map<String, dynamic> map) {
    return ShiftState(
      shift: Shift.fromMap(map['shift']),
      enabledStart: map['enabledStart'] ?? false,
      enabledEnd: map['enabledEnd'] ?? false,
      status: map['status'] ?? ShiftStateStatus.values.elementAt(map['status']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ShiftState.fromJson(String source) =>
      ShiftState.fromMap(json.decode(source));
}
