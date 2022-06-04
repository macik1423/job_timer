import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timer/screen/settings/add_form.dart';

import '../../bloc/add_form/add_form_bloc.dart';
import '../../bloc/repo/repo_bloc.dart';
import '../../cubit/duration/duration_cubit.dart';
import '../../model/shift.dart';
import '../../util/constants.dart' as constants;
import '../../util/time_util.dart';
import '../../widgets/shifts_list.dart';
import 'default_value_option.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedValue = DateFormat("MMMM").format(DateTime.now());

  final ScrollController _hideButtonController = ScrollController();
  late bool _isVisible;

  @override
  initState() {
    super.initState();
    _isVisible = true;
    _hideButtonController.addListener(
      () {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisible == true) {
            setState(() {
              _isVisible = false;
            });
          }
        }
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            setState(() {
              _isVisible = true;
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final numOfMonth = DateFormat("MMMM").parse(selectedValue).month;
    AddFormBloc addFormBloc = BlocProvider.of<AddFormBloc>(context);
    RepoBloc repoBloc = BlocProvider.of<RepoBloc>(context);
    final durationCubit = BlocProvider.of<DurationCubit>(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: DropdownButton(
                key: const Key(constants.monthsText),
                value: selectedValue,
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                items: constants.monthsListText
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
              ),
            ),
            BlocConsumer<RepoBloc, RepoState>(
              listener: (context, state) {
                if (state.status == RepoStateStatus.failure) {
                  final message = state.message;
                  final snackBar = SnackBar(
                    content: Text(message),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  repoBloc.add(RepoReset());
                }
              },
              builder: (context, state) {
                if (state.status == RepoStateStatus.success) {
                  final yearNow = DateTime.now().year;
                  final shifts = state.shifts.where((shift) {
                    return shift.start?.month == numOfMonth &&
                        shift.start?.year == yearNow;
                  }).toList();
                  if (shifts.isNotEmpty) {
                    shifts.sort(((a, b) => b.start!.compareTo(a.start!)));
                  }
                  return Expanded(
                    child: ListView(
                      controller: _hideButtonController,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: FittedBox(
                            child: ShiftsList(
                              shifts: shifts,
                              press: (Shift shift) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actions: [
                                        TextButton(
                                          child:
                                              const Text(constants.cancelText),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text(constants.okText),
                                          onPressed: () {
                                            repoBloc
                                                .add(RepoShiftDeleted(shift));
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                      title: Text(
                                          "Delete shift from ${TimeUtil.formatDate(shift.start)}?"),
                                      content: const Text(
                                          "Are you sure you want to delete this shift?"),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Text("dupa");
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedOpacity(
            key: const Key(constants.wrenchOpacityText),
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return BlocProvider.value(
                      value: durationCubit,
                      child: DefaultValueOption(),
                    );
                  },
                );
              },
              backgroundColor: Colors.green[600],
              child: const Icon(Icons.build_sharp),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AnimatedOpacity(
            key: const Key(constants.addOpacityText),
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider<AddFormBloc>.value(
                          value: addFormBloc,
                        ),
                        BlocProvider<RepoBloc>.value(
                          value: repoBloc,
                        ),
                        BlocProvider<DurationCubit>.value(
                          value: durationCubit,
                        )
                      ],
                      child: AddForm(
                        month: numOfMonth,
                      ),
                    );
                  },
                );
              },
              backgroundColor: Colors.green[600],
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
