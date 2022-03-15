import 'dart:convert';

import 'package:hive/hive.dart';

part 'shift.g.dart';

@HiveType(typeId: 1)
class Shift extends HiveObject {
  @HiveField(0)
  final DateTime? start;

  @HiveField(1)
  final DateTime? end;

  Shift({required this.start, required this.end});

  Shift copyWith({
    DateTime? start,
    DateTime? end,
  }) {
    return Shift(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start': start?.millisecondsSinceEpoch,
      'end': end?.millisecondsSinceEpoch,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory Shift.fromJson(String source) => Shift.fromMap(json.decode(source));
}
