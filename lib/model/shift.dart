import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shift.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class Shift extends HiveObject {
  @HiveField(0)
  final DateTime? start;

  @HiveField(1)
  final DateTime? end;

  @HiveField(2, defaultValue: Duration(hours: 8))
  final Duration? duration;

  Shift({required this.start, required this.end, Duration? duration})
      : duration = duration ?? const Duration(hours: 8);

  Shift copyWith({
    DateTime? start,
    DateTime? end,
    Duration? duration,
  }) {
    return Shift(
      start: start ?? this.start,
      end: end ?? this.end,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toJson() => _$ShiftToJson(this);

  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);

  // Equatable does not work with HiveObjects, necessary to override hashCode ==
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Shift &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end &&
          duration == other.duration;

  @override
  int get hashCode => start.hashCode ^ end.hashCode ^ duration.hashCode;

  @override
  String toString() {
    return 'Shift{start: $start, end: $end, duration: $duration}';
  }
}
