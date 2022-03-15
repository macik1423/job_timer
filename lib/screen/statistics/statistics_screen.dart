import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:timer/bloc/repo_bloc.dart';
import '../../bloc/repo_bloc.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pl_PL', '');
    String defaultDropdownValue = DateFormat("MMMM").format(DateTime.now());
    return Column(
      children: [
        DropdownButton(
          items: <String>[DateFormat("MMMM", "pl-PL").format(DateTime.now())]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              defaultDropdownValue = newValue!;
            });
          },
        ),
        BlocBuilder<RepoBloc, RepoState>(
          bloc: context.read<RepoBloc>(),
          builder: (context, state) {
            if (state.status == RepoStateStatus.success) {
              final shifts = state.shifts;
              return Container(
                child: Text(
                  shifts.toString(),
                ),
              );
            }
            return Container(
              child: Text('dupa'),
            );
          },
        ),
      ],
    );
  }
}
