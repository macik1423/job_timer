import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/repo/repo_bloc.dart';
import '../../cubit/shift/shift_cubit.dart';
import '../../cubit/shift/shift_state.dart';
import '../../model/shift.dart';
import '../../util/constants.dart' as constants;
import '../../util/time_util.dart';
import '../../widgets/clock.dart';
import '../../widgets/shift_card.dart';
import 'first_shifts.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

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
                  Clock(repoState: repoState),
                  ShiftCard(
                    key: const Key(constants.inText),
                    color: state.enabledStart
                        ? Colors.green[300]!
                        : Colors.grey[400]!,
                    onTap: () {
                      final timeNow = DateTime.now();
                      context.read<ShiftCubit>().updateStart(timeNow);
                    },
                    tappedTime: TimeUtil.formatDateTime(state.shift.start),
                    enabled: state.enabledStart,
                    title: constants.inText,
                  ),
                  ShiftCard(
                    key: const Key(constants.outText),
                    color: state.enabledEnd
                        ? Colors.green[300]!
                        : Colors.grey[400]!,
                    title: constants.outText,
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
                  const FirstShiftsList(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
