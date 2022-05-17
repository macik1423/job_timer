import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/widgets/shifts_list.dart';

import '../../bloc/repo/repo_bloc.dart';
import '../../model/shift.dart';

class FirstShiftsList extends StatelessWidget {
  const FirstShiftsList({Key? key}) : super(key: key);

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
        return Expanded(
          child: ListView(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: FittedBox(
                  child: ShiftsList(
                    shifts: firstShifts,
                    press: (Shift shift) {},
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
