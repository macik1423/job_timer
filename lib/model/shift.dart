import 'dart:convert';

import 'package:hive/hive.dart';

part 'shift.g.dart';

@HiveType(typeId: 1)
class Shift extends HiveObject {
  @HiveField(0)
  final DateTime? start;

  @HiveField(1)
  final DateTime? end;

  @HiveField(2, defaultValue: Duration(hours: 8))
  final Duration? duration;

  Shift({required this.start, required this.end, required this.duration});

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

  Map<String, dynamic> toMap() {
    return {
      'start': start?.millisecondsSinceEpoch,
      'end': end?.millisecondsSinceEpoch,
      'duration': duration?.inMilliseconds,
    };
  }

  factory Shift.fromMap(Map<String, dynamic> map) {
    return Shift(
      start: map['start'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['start'])
          : null,
      end: map['end'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['end'])
          : null,
      duration: map['duration'] != null
          ? Duration(milliseconds: map['duration'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Shift.fromJson(String source) => Shift.fromMap(json.decode(source));

  // Equatable does not work with HiveObjects
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
}
