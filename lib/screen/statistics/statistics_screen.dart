import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timer/model/shift.dart';
import 'package:timer/model/shifts_list.dart';

import '../../bloc/repo/repo_bloc.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String selectedValue = DateFormat("MMMM").format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    const _startText = 'Start';
    const _endText = 'Koniec';
    const _dateText = 'Data';
    const _diffText = 'Roznica';
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: DropdownButton(
              value: selectedValue,
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              items: months.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                });
              },
            ),
          ),
          BlocBuilder<RepoBloc, RepoState>(
            bloc: context.read<RepoBloc>(),
            builder: (context, state) {
              if (state.status == RepoStateStatus.success) {
                final numOfMonth =
                    DateFormat("MMMM").parse(selectedValue).month;
                final shifts = state.shifts.where((shift) {
                  return shift.start?.month == numOfMonth;
                }).toList();
                if (shifts.isNotEmpty) {
                  shifts.sort(((a, b) => b.start!.compareTo(a.start!)));
                }
                final summary = _getSummary(shifts);
                return Column(
                  children: [
                    Text("Summary: $summary minutes"),
                    FittedBox(
                      child: ShiftsList(
                        shifts: shifts,
                        dateText: _dateText,
                        startText: _startText,
                        endText: _endText,
                        diffText: _diffText,
                        press: (Shift shift) {},
                      ),
                    ),
                  ],
                );
              }
              return Text('dupa');
            },
          ),
        ],
      ),
    );
  }

  int _getSummary(List<Shift> shifts) {
    return shifts.fold<int>(
        0,
        (p, s) =>
            p +
            s.end!
                .subtract(const Duration(hours: 8))
                .difference(s.start!)
                .inMinutes);
  }
}
