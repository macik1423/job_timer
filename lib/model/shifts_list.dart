import 'package:flutter/material.dart';
import 'package:timer/model/shift.dart';

import '../time_util.dart';

class ShiftsList extends StatelessWidget {
  final String startText;
  final String endText;
  final String dateText;
  final String diffText;
  final List<Shift> shifts;
  final int normalShift = 8;
  final Function(Shift shift) press;
  ShiftsList({
    Key? key,
    required this.startText,
    required this.endText,
    required this.dateText,
    required this.diffText,
    required this.shifts,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text(startText)),
        DataColumn(label: Text(endText)),
        DataColumn(
          label: Text(dateText),
        ),
        DataColumn(label: Text(diffText)),
      ],
      rows: shifts.map((shift) {
        final start = shift.start;
        final end = shift.end;
        final diff = end
            ?.subtract(Duration(hours: normalShift))
            .difference(start!)
            .inMinutes;
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
                  diff.toString(),
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
