// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftState _$ShiftStateFromJson(Map<String, dynamic> json) => ShiftState(
      shift: Shift.fromJson(json['shift'] as Map<String, dynamic>),
      enabledStart: json['enabledStart'] as bool,
      enabledEnd: json['enabledEnd'] as bool,
      status: $enumDecode(_$ShiftStateStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$ShiftStateToJson(ShiftState instance) =>
    <String, dynamic>{
      'shift': instance.shift.toJson(),
      'enabledStart': instance.enabledStart,
      'enabledEnd': instance.enabledEnd,
      'status': _$ShiftStateStatusEnumMap[instance.status],
    };

const _$ShiftStateStatusEnumMap = {
  ShiftStateStatus.initial: 'initial',
  ShiftStateStatus.startTapped: 'startTapped',
  ShiftStateStatus.endTapped: 'endTapped',
};
