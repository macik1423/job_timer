import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/screen/dashboard/first_shifts.dart';

import '../../bloc/repo_bloc.dart';
import '../../cubit/shift/shift_cubit.dart';
import '../../cubit/shift/shift_state.dart';
import '../../model/shift.dart';
import '../../time_util.dart';
import '../../widgets/clock.dart';
import '../../widgets/shift_card.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RepoBloc, RepoState>(
        listener: (repoContext, repoState) {
          if (repoState.status == RepoStateStatus.failure) {
            final snackBar = SnackBar(
              content: Text(repoState.message),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (repoContext, repoState) {
          return BlocBuilder<ShiftCubit, ShiftState>(
            builder: (context, state) {
              return Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  const Clock(),
                  ShiftCard(
                    key: const Key('Start'),
                    color: const Color.fromRGBO(225, 180, 147, 100),
                    title: 'Start',
                    onTap: () {
                      final timeNow = DateTime.now();
                      context.read<ShiftCubit>().updateStart(timeNow);
                    },
                    tappedTime: TimeUtil.formatDateTime(state.shift.start),
                    enabled: state.enabledStart,
                  ),
                  ShiftCard(
                    key: const Key('End'),
                    color: const Color.fromRGBO(225, 180, 147, 100),
                    title: 'Koniec',
                    onTap: () {
                      final timeNow = DateTime.now();
                      context.read<RepoBloc>().add(
                            RepoShiftSaved(
                              Shift(
                                start: state.shift.start,
                                end: timeNow,
                              ),
                            ),
                          );
                      context.read<ShiftCubit>().updateEnd(timeNow);
                    },
                    tappedTime: TimeUtil.formatDateTime(state.shift.end),
                    enabled: state.enabledEnd,
                  ),
                  const ShiftList(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
