import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/repo/repo_bloc.dart';
import '../../model/shift.dart';
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
          BlocBuilder<RepoBloc, RepoState>(
            bloc: context.read<RepoBloc>(),
            builder: (context, state) {
              if (state.status == RepoStateStatus.success) {
                final numOfMonth =
                    DateFormat("MMMM").parse(selectedMonth).month;
                final shiftsInMonth = state.shifts.where((shift) {
                  return shift.start?.month == numOfMonth;
                }).toList();
                shiftsInMonth
                    .sort(((a, b) => a.start!.day.compareTo(b.start!.day)));
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chart(shifts: shiftsInMonth),
                );
              } else {
                return const Text("dupa");
              }
            },
          ),
          BlocBuilder<RepoBloc, RepoState>(
            builder: (context, state) {
              if (state.status == RepoStateStatus.success) {
                final numOfMonth =
                    DateFormat("MMMM").parse(selectedMonth).month;
                final shiftsInMonth = state.shifts.where((shift) {
                  return shift.start?.month == numOfMonth;
                }).toList();
                final sum = _sumShifts(shiftsInMonth);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Summary(sum),
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

  double _sumShifts(List<Shift> shifts) {
    return shifts.fold<double>(
        0,
        (p, s) =>
            p +
            s.end!
                    .subtract(const Duration(hours: 8))
                    .difference(s.start!)
                    .inSeconds /
                60);
  }
}

abstract class Summary extends StatelessWidget {
  factory Summary(double value) {
    if (value < 0) {
      return NegativeSummary(sum: value);
    } else {
      return PositiveSummary(sum: value);
    }
  }
}

class PositiveSummary extends StatelessWidget implements Summary {
  const PositiveSummary({
    Key? key,
    required this.sum,
  }) : super(key: key);

  final double sum;

  @override
  Widget build(BuildContext context) {
    const double _size = 30;
    return Card(
      color: Colors.green[50],
      elevation: 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.add,
            color: Colors.green[900],
            size: _size,
          ),
          Text(
            sum.abs().toStringAsFixed(2) + "'",
            style: TextStyle(
              fontSize: _size,
              color: Colors.green[900],
            ),
          ),
        ],
      ),
    );
  }
}

class NegativeSummary extends StatelessWidget implements Summary {
  const NegativeSummary({
    Key? key,
    required this.sum,
  }) : super(key: key);

  final double sum;

  @override
  Widget build(BuildContext context) {
    const double _size = 30;
    return Card(
      color: Colors.pink[50],
      elevation: 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.remove,
            color: Colors.red[900],
            size: _size,
          ),
          Text(
            sum.abs().toStringAsFixed(2) + "'",
            style: TextStyle(
              color: Colors.red[900],
              fontSize: _size,
            ),
          ),
        ],
      ),
    );
  }
}
