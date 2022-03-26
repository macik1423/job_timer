import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/add_form/add_form_bloc.dart';
import '../../bloc/repo/repo_bloc.dart';
import '../../model/add_form/shift_input.dart';
import '../../model/shift.dart';

class AddForm extends StatefulWidget {
  final int month;
  const AddForm({Key? key, required this.month}) : super(key: key);

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddFormBloc, AddFormState>(
      builder: (context, state) {
        return Dialog(
          child: SizedBox(
            height: 400,
            width: 300,
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: TextEditingController(
                      text: state.shift.value.start.toString(),
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: FocusNode(),
                    decoration: InputDecoration(
                      labelText: 'Start',
                      helperText: 'Start of the shift',
                      errorText: state.shift.valid
                          ? null
                          : 'Start date must be earlier than end date',
                    ),
                    readOnly: true,
                    onTap: () async {
                      final newValue =
                          await _selectTime(state.shift.value.start);
                      context.read<AddFormBloc>().add(
                            ShiftInputChanged(
                              ShiftInput(
                                start: TimeOfDay(
                                  hour: newValue!.hour,
                                  minute: newValue.minute,
                                ),
                                end: TimeOfDay(
                                  hour: state.shift.value.end.hour,
                                  minute: state.shift.value.end.minute,
                                ),
                                day: state.shift.value.day,
                                month: state.shift.value.month,
                                year: state.shift.value.year,
                              ),
                            ),
                          );
                    },
                  ),
                  TextFormField(
                    controller: TextEditingController(
                      text: state.shift.value.end.toString(),
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: FocusNode(),
                    decoration: InputDecoration(
                      labelText: 'End',
                      helperText: 'End of the shift',
                      errorText: state.shift.valid
                          ? null
                          : 'End date must be later than start date',
                    ),
                    readOnly: true,
                    onTap: () async {
                      final newValue = await _selectTime(state.shift.value.end);
                      context.read<AddFormBloc>().add(
                            ShiftInputChanged(
                              ShiftInput(
                                start: TimeOfDay(
                                  hour: state.shift.value.start.hour,
                                  minute: state.shift.value.start.minute,
                                ),
                                end: TimeOfDay(
                                  hour: newValue!.hour,
                                  minute: newValue.minute,
                                ),
                                day: state.shift.value.day,
                                month: state.shift.value.month,
                                year: state.shift.value.year,
                              ),
                            ),
                          );
                    },
                  ),
                  TextFormField(
                    controller: TextEditingController(
                        text: state.shift.value.day.toString()),
                    textInputAction: TextInputAction.next,
                    focusNode: FocusNode(),
                    decoration: const InputDecoration(
                      labelText: 'Day',
                      helperText: 'Day of the shift',
                    ),
                    readOnly: true,
                    onTap: () async {
                      final newValue = await _selectDate();
                      context.read<AddFormBloc>().add(
                            ShiftInputChanged(
                              ShiftInput(
                                start: TimeOfDay(
                                  hour: state.shift.value.start.hour,
                                  minute: state.shift.value.start.minute,
                                ),
                                end: TimeOfDay(
                                  hour: state.shift.value.end.hour,
                                  minute: state.shift.value.end.minute,
                                ),
                                day: newValue!.day,
                                month: newValue.month,
                                year: newValue.year,
                              ),
                            ),
                          );
                    },
                  ),
                  ElevatedButton(
                      onPressed: state.shift.valid
                          ? () {
                              final date = state.shift.value;
                              final start = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                date.start.hour,
                                date.start.minute,
                              );
                              final end = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                date.end.hour,
                                date.end.minute,
                              );
                              final shift = Shift(start: start, end: end);
                              RepoBloc repoBloc = context.read<RepoBloc>();
                              repoBloc.add(
                                RepoShiftSaved(shift),
                              );
                            }
                          : null,
                      child: const Text('Add'))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<TimeOfDay?> _selectTime(TimeOfDay initial) async {
    final TimeOfDay? newTime = await showTimePicker(
      initialTime: initial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: childWidget!,
        );
      },
      context: context,
    );
    return newTime;
  }

  Future<DateTime?> _selectDate() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, widget.month, 1),
      lastDate: DateTime(
        now.year,
        widget.month,
        DateTime(now.year, widget.month + 1, 0).day,
      ),
    );
    return picked;
  }
}
