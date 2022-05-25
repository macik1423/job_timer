import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/repo/repo_bloc.dart';
import '../../cubit/shift/shift_cubit.dart';
import '../../cubit/shift/shift_state.dart';
import '../../model/shift.dart';
import '../../util/constants.dart' as constants;
import '../../util/time_util.dart';
import '../../widgets/clock.dart';
import '../../widgets/duration_modifier.dart';
import '../../widgets/shift_card.dart';
import 'first_shifts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                  Clock(
                    key: const Key(constants.mainClockText),
                    repoState: repoState,
                  ),
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
                    subtitle: TimeUtil.formatDate(state.shift.start),
                  ),
                  ShiftCard(
                    key: const Key(constants.outText),
                    color: state.enabledEnd
                        ? Colors.green[300]!
                        : Colors.grey[400]!,
                    title: constants.outText,
                    onTap: () {
                      final timeNow = DateTime.now();
                      final timeIn = state.shift.start;
                      final duration = context.read<SliderChanged>().value;
                      context.read<RepoBloc>().add(
                            RepoShiftSaved(
                              Shift(
                                start: timeIn,
                                end: timeNow,
                                duration: Duration(
                                  hours: duration.round(),
                                ),
                              ),
                            ),
                          );
                      context.read<SliderChanged>().resetToDefault();
                      context.read<ShiftCubit>().updateEnd(timeIn!, timeNow);
                    },
                    tappedTime: TimeUtil.formatDateTime(state.shift.end),
                    enabled: state.enabledEnd,
                    subtitle: TimeUtil.formatDate(state.shift.end),
                  ),
                  DurationModifier(
                    absorbing: !(state.enabledEnd || state.enabledStart),
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
