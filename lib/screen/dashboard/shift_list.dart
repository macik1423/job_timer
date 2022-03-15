import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/repo_bloc.dart';
import '../../time_util.dart';

class ShiftList extends StatelessWidget {
  const ShiftList({Key? key}) : super(key: key);
  static const _startText = 'Start';
  static const _endText = 'Koniec';
  static const _dateText = 'Data';
  static const _diffText = 'Roznica';
  static const _normalShift = 8;
  static const _firstElements = 5;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RepoBloc, RepoState>(
      builder: (context, state) {
        if (state.status == RepoStateStatus.success) {
          final shifts = List.from(state.shifts.take(_firstElements));
          if (shifts.isNotEmpty) {
            shifts.sort(((a, b) => b.start!.compareTo(a.start!)));
          }
          return FittedBox(
            child: DataTable(
              columns: const [
                DataColumn(label: Text(_startText)),
                DataColumn(label: Text(_endText)),
                DataColumn(
                  label: Text(_dateText),
                ),
                DataColumn(label: Text(_diffText)),
              ],
              rows: shifts.map((shift) {
                final start = shift.start;
                final end = shift.end;
                final diff = end
                    ?.subtract(const Duration(hours: _normalShift))
                    .difference(start!);
                final diffFormat = diff.toString().split('.')[0];
                return DataRow(cells: [
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
                    Text(diffFormat),
                  ),
                ]);
              }).toList(),
            ),
          );
        } else {
          return const Center(
            child: Text('Brak danych'),
          );
        }
      },
    );
  }
}
