import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/model/shifts_list.dart';

import '../../bloc/repo/repo_bloc.dart';
import '../../model/shift.dart';

class ShiftList extends StatelessWidget {
  const ShiftList({Key? key}) : super(key: key);
  static const _startText = 'Start';
  static const _endText = 'Koniec';
  static const _dateText = 'Data';
  static const _diffText = 'Roznica';

  /// this screen shows only first five shifts
  static const _firstElements = 5;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RepoBloc, RepoState>(
      listener: (context, state) {
        if (state.status == RepoStateStatus.failure) {
          final message = state.message;
          final snackBar = SnackBar(
            content: Text(message),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          context.read<RepoBloc>().add(RepoReset());
        }
      },
      builder: (context, state) {
        final List<Shift> shifts = List.from(state.shifts);
        if (shifts.isNotEmpty) {
          shifts.sort(((a, b) => b.start!.compareTo(a.start!)));
        }
        final firstShifts = shifts.take(_firstElements).toList();
        return FittedBox(
          child: ShiftsList(
            dateText: _dateText,
            startText: _startText,
            endText: _endText,
            diffText: _diffText,
            shifts: firstShifts,
            press: (Shift shift) {},
          ),
        );
      },
    );
  }
}
