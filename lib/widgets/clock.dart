import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/repo/repo_bloc.dart';
import '../cubit/shift/shift_cubit.dart';
import '../time_util.dart';

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
        final isExist =
            widget.repoState.shifts.any((shift) => shift.start == start);

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
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              color: const Color.fromRGBO(225, 180, 147, 50),
              child: ListTile(
                title: const Icon(
                  Icons.access_time_outlined,
                  color: Colors.white,
                  size: 24.0,
                ),
                subtitle: StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Center(
                      child: Text(
                        TimeUtil.formatDateTime(DateTime.now()),
                      ),
                    );
                  },
                ),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              color: const Color.fromRGBO(225, 180, 147, 50),
              child: ListTile(
                title: const Icon(
                  Icons.date_range,
                  color: Colors.white,
                  size: 24.0,
                ),
                subtitle: StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Center(
                      child: Text(
                        TimeUtil.formatDate(DateTime.now()),
                      ),
                    );
                  },
                ),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
