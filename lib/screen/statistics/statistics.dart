import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/bloc/repo/repo_bloc.dart';
import 'package:timer/screen/statistics/statistics_screen.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: context.read<RepoBloc>(),
        ),
      ],
      child: const StatisticsScreen(),
    );
  }
}
