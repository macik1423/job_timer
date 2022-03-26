import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timer/screen/settings/add_form.dart';

import '../../bloc/add_form/add_form_bloc.dart';
import '../../bloc/repo/repo_bloc.dart';
import '../../model/shifts_list.dart';

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
    const _startText = 'Start';
    const _endText = 'Koniec';
    const _dateText = 'Data';
    const _diffText = 'Roznica';
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
            BlocBuilder<RepoBloc, RepoState>(
              bloc: context.read<RepoBloc>(),
              builder: (context, state) {
                if (state.status == RepoStateStatus.success) {
                  final shifts = state.shifts.where((shift) {
                    return shift.start?.month == numOfMonth;
                  }).toList();
                  if (shifts.isNotEmpty) {
                    shifts.sort(((a, b) => b.start!.compareTo(a.start!)));
                  }
                  return Column(
                    children: [
                      FittedBox(
                        child: ShiftsList(
                          shifts: shifts,
                          dateText: _dateText,
                          startText: _startText,
                          endText: _endText,
                          diffText: _diffText,
                        ),
                      ),
                    ],
                  );
                }
                return Text('dupa');
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
