import 'package:flutter/material.dart';
import 'package:timer/model/shift.dart';

import '../util/constants.dart' as constants;
import '../util/time_util.dart';

class ShiftsList extends StatelessWidget {
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
      columns: const [
        DataColumn(label: Text(constants.inText)),
        DataColumn(label: Text(constants.outText)),
        DataColumn(label: Text(constants.dateText)),
        DataColumn(label: Text(constants.differenceText)),
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
