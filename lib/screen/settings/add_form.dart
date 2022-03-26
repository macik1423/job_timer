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
            child: Padding(
              padding: const EdgeInsets.all(12.0),
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
                              ShiftTimeInputChanged(
                                ShiftTimeInput(
                                  start: TimeOfDay(
                                    hour: newValue!.hour,
                                    minute: newValue.minute,
                                  ),
                                  end: TimeOfDay(
                                    hour: state.shift.value.end.hour,
                                    minute: state.shift.value.end.minute,
                                  ),
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
                        final newValue =
                            await _selectTime(state.shift.value.end);
                        context.read<AddFormBloc>().add(
                              ShiftTimeInputChanged(
                                ShiftTimeInput(
                                  start: TimeOfDay(
                                    hour: state.shift.value.start.hour,
                                    minute: state.shift.value.start.minute,
                                  ),
                                  end: TimeOfDay(
                                    hour: newValue!.hour,
                                    minute: newValue.minute,
                                  ),
                                ),
                              ),
                            );
                      },
                    ),
                    TextFormField(
                      controller: TextEditingController(
                          text: state.date.value.toString()),
                      textInputAction: TextInputAction.next,
                      focusNode: FocusNode(),
                      decoration: InputDecoration(
                        labelText: 'Day',
                        helperText: 'Day of the shift',
                        errorText: state.date.valid
                            ? null
                            : 'Day must be a number between 1 and 31',
                      ),
                      readOnly: true,
                      onTap: () async {
                        final newValue = await _selectDate();
                        final day = newValue!.day.toString();
                        final month = newValue.month.toString();
                        final year = newValue.year.toString();
                        context.read<AddFormBloc>().add(
                              ShiftDateInputChanged(
                                ShiftDateInput(
                                  day: day,
                                  month: month,
                                  year: year,
                                ),
                              ),
                            );
                      },
                    ),
                    ElevatedButton(
                      onPressed: state.shift.valid && state.date.valid
                          ? () {
                              final date = state.date.value;
                              final time = state.shift.value;
                              final year = int.parse(date.year);
                              final month = int.parse(date.month);
                              final day = int.parse(date.day);
                              final start = DateTime(
                                year,
                                month,
                                day,
                                time.start.hour,
                                time.start.minute,
                              );
                              final end = DateTime(
                                year,
                                month,
                                day,
                                time.end.hour,
                                time.end.minute,
                              );
                              final shift = Shift(start: start, end: end);
                              RepoBloc repoBloc = context.read<RepoBloc>();
                              repoBloc.add(
                                RepoShiftSaved(shift),
                              );
                              Navigator.pop(context);
                            }
                          : null,
                      child: const Text('Add'),
                    )
                  ],
                ),
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
