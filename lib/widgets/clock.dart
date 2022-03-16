import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/shift/shift_cubit.dart';
import '../time_util.dart';

class Clock extends StatefulWidget {
  const Clock({
    Key? key,
  }) : super(key: key);

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  late Timer _timer;
  String _date = "";

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    final start = context.read<ShiftCubit>().state.shift.start;
    _timer = Timer.periodic(const Duration(minutes: 10), (Timer timer) {
      setState(() {
        _date = TimeUtil.formatDate(DateTime.now());
        final tappedTime = TimeUtil.formatDate(start);
        if (tappedTime != _date) {
          BlocProvider.of<ShiftCubit>(context).resetNewDay();
        }
      });
    });
    super.initState();
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
