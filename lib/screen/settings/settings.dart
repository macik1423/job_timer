import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/screen/settings/settings_screen.dart';

import '../../bloc/repo/repo_bloc.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<RepoBloc>(),
      child: const SettingsScreen(),
    );
  }
}
