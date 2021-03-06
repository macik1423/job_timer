import 'package:flutter/material.dart';
import 'package:timer/model/shift.dart';

import '../util/constants.dart' as constants;
import '../util/time_util.dart';

class ShiftsList extends StatelessWidget {
  final List<Shift> shifts;
  final Function(Shift shift) press;
  const ShiftsList({
    Key? key,
    required this.shifts,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text(constants.inn)),
        DataColumn(label: Text(constants.out)),
        DataColumn(label: Text(constants.date)),
        DataColumn(label: Text(constants.difference)),
        DataColumn(label: Text(constants.duration)),
      ],
      rows: shifts.map((shift) {
        final start = shift.start;
        final end = shift.end;
        final duration = shift.duration;
        final diff = end
            ?.subtract(Duration(hours: duration!.inHours))
            .difference(start!)
            .inSeconds;
        return DataRow(
          onLongPress: () => press(shift),
          cells: [
            DataCell(
              Text(TimeUtil.formatTime(start)),
            ),
            DataCell(
              Text(TimeUtil.formatTime(end)),
            ),
            DataCell(
              Text(TimeUtil.formatDate(start)),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                color: diff! < 0 ? Colors.pink[50] : Colors.green[50],
                child: Text(
                  "${(diff / 60).toStringAsFixed(2)}'",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            DataCell(
              Center(child: Text('${shift.duration!.inHours} h')),
            ),
          ],
        );
      }).toList(),
    );
  }
}
