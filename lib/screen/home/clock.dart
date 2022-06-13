import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/repo/repo_bloc.dart';
import '../../cubit/shift/shift_cubit.dart';
import '../../util/time_util.dart';

class Clock extends StatefulWidget {
  const Clock({
    Key? key,
    required this.repoState,
  }) : super(key: key);

  final RepoState repoState;

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  late Timer _timer;
  late String _date = "";

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        final start = context.read<ShiftCubit>().state.shift.start;
        final end = context.read<ShiftCubit>().state.shift.end;
        final isExist = widget.repoState.shifts.any((shift) =>
            TimeUtil.formatDateTime(shift.start) ==
            TimeUtil.formatDateTime(start));

        _date = TimeUtil.formatDate(DateTime.now());
        final startTappedTime = TimeUtil.formatDate(start);
        final endTappedTime = TimeUtil.formatDate(end);
        if (startTappedTime != _date ||
            !isExist && endTappedTime == _date && startTappedTime == _date) {
          BlocProvider.of<ShiftCubit>(context).resetNewDay();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              return Center(
                child: Text(
                  TimeUtil.formatTime(DateTime.now()),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 40),
                ),
              );
            },
          ),
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              return Center(
                child: Text(
                  TimeUtil.formatDate(DateTime.now()),
                  style: const TextStyle(fontSize: 22),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
