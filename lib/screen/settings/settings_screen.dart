import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timer/screen/settings/add_form.dart';

import '../../bloc/add_form/add_form_bloc.dart';
import '../../bloc/repo/repo_bloc.dart';
import '../../model/shift.dart';
import '../../time_util.dart';
import '../../widgets/shifts_list.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedValue = DateFormat("MMMM").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final numOfMonth = DateFormat("MMMM").parse(selectedValue).month;
    AddFormBloc addFormBloc = BlocProvider.of<AddFormBloc>(context);
    RepoBloc repoBloc = BlocProvider.of<RepoBloc>(context);
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: DropdownButton(
                value: selectedValue,
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                items: months.map<DropdownMenuItem<String>>((String value) {
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
                final shifts = state.shifts.where((shift) {
                  return shift.start?.month == numOfMonth;
                }).toList();
                if (shifts.isNotEmpty) {
                  shifts.sort(((a, b) => b.start!.compareTo(a.start!)));
                }
                return Expanded(
                  child: ListView(
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
                                        child: const Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("OK"),
                                        onPressed: () {
                                          repoBloc.add(RepoShiftDeleted(shift));
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                    title: Text(
                                        "Delete shift from ${TimeUtil.formatDate(shift.start)}?"),
                                    content: const Text(
                                        'Are you sure you want to delete this shift?'),
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
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
                  )
                ],
                child: AddForm(
                  month: numOfMonth,
                ),
              );
            },
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
