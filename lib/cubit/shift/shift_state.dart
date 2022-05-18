import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../model/shift.dart';

part 'shift_state.g.dart';

enum ShiftStateStatus { initial, startTapped, endTapped }

@JsonSerializable()
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

  Map<String, dynamic> toJson() => _$ShiftStateToJson(this);

  factory ShiftState.fromJson(Map<String, dynamic> json) =>
      _$ShiftStateFromJson(json);
}
