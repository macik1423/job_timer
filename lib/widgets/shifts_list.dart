import 'package:flutter/material.dart';
import 'package:timer/model/shift.dart';

import '../time_util.dart';

class ShiftsList extends StatelessWidget {
  final String startText = 'Start';
  final String endText = 'End';
  final String dateText = 'Date';
  final String diffText = 'Difference';
  final List<Shift> shifts;
  final int normalShift = 8;
  final Function(Shift shift) press;
  const ShiftsList({
    Key? key,
    required this.shifts,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text(startText)),
        DataColumn(label: Text(endText)),
        DataColumn(label: Text(dateText)),
        DataColumn(label: Text(diffText)),
      ],
      rows: shifts.map((shift) {
        final start = shift.start;
        final end = shift.end;
        final diff = end
            ?.subtract(Duration(hours: normalShift))
            .difference(start!)
            .inSeconds;
        return DataRow(
          onLongPress: () => press(shift),
          cells: [
            DataCell(
              Text(TimeUtil.formatDateTime(start)),
            ),
            DataCell(
              Text(TimeUtil.formatDateTime(end)),
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
          ],
        );
      }).toList(),
    );
  }
}
