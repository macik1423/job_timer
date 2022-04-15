import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/repo/repo_bloc.dart';
import 'chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String selectedMonth = DateFormat("MMMM").format(DateTime.now());
  @override
  Widget build(BuildContext context) {
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
              value: selectedMonth,
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
                  selectedMonth = newValue!;
                });
              },
            ),
          ),
          // BlocBuilder<RepoBloc, RepoState>(
          //   bloc: context.read<RepoBloc>(),
          //   builder: (context, state) {
          //     if (state.status == RepoStateStatus.success) {
          //       final numOfMonth =
          //           DateFormat("MMMM").parse(selectedValue).month;
          //       final shifts = state.shifts.where((shift) {
          //         return shift.start?.month == numOfMonth;
          //       }).toList();
          //       if (shifts.isNotEmpty) {
          //         shifts.sort(((a, b) => b.start!.compareTo(a.start!)));
          //       }
          //       final summary = _getSummary(shifts);
          //       return Column(
          //         children: [
          //           Text("Summary: $summary minutes"),
          //           FittedBox(
          //             child: ShiftsList(
          //               shifts: shifts,
          //               press: (Shift shift) {},
          //             ),
          //           ),
          //         ],
          //       );
          //     }
          //     return Text('dupa');
          //   },
          // ),
          BlocBuilder<RepoBloc, RepoState>(
            bloc: context.read<RepoBloc>(),
            builder: (context, state) {
              if (state.status == RepoStateStatus.success) {
                final numOfMonth =
                    DateFormat("MMMM").parse(selectedMonth).month;
                final shiftsInMonth = state.shifts.where((shift) {
                  return shift.start?.month == numOfMonth;
                }).toList();
                shiftsInMonth.sort(((a, b) => b.start!.compareTo(a.start!)));
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chart(shifts: shiftsInMonth),
                );
              } else {
                return const Text("dupa");
              }
            },
          ),
        ],
      ),
    );
  }

  // double _getSummary(List<Shift> shifts) {
  //   return shifts.fold<double>(
  //       0,
  //       (p, s) =>
  //           p +
  //           s.end!
  //                   .subtract(const Duration(hours: 8))
  //                   .difference(s.start!)
  //                   .inSeconds /
  //               60);
  // }
}
