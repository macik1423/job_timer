import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/util/time_of_day_converter_extension.dart';

import '../../bloc/add_form/add_form_bloc.dart';
import '../../bloc/repo/repo_bloc.dart';
import '../../cubit/duration/duration_cubit.dart';
import '../../model/add_form/shift_input.dart';
import '../../model/shift.dart';
import '../../util/constants.dart' as constants;
import '../../widgets/duration_modifier.dart';

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
            height: 500,
            width: 450,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFormField(
                      key: const Key(constants.inn),
                      controller: TextEditingController(
                        text: state.time.value.start.to24hours(),
                      ),
                      focusNode: FocusNode(),
                      decoration: InputDecoration(
                        labelText: constants.inn,
                        helperText: 'Start of the shift',
                        errorText: state.time.valid
                            ? null
                            : 'Start date must be earlier than end date',
                      ),
                      readOnly: true,
                      onTap: () async {
                        final newValue =
                            await _selectTime(state.time.value.start);
                        context.read<AddFormBloc>().add(
                              ShiftTimeInputChanged(
                                ShiftTimeInput(
                                  start: TimeOfDay(
                                    hour: newValue!.hour,
                                    minute: newValue.minute,
                                  ),
                                  end: TimeOfDay(
                                    hour: state.time.value.end.hour,
                                    minute: state.time.value.end.minute,
                                  ),
                                ),
                              ),
                            );
                      },
                    ),
                    TextFormField(
                      key: const Key(constants.out),
                      controller: TextEditingController(
                        text: state.time.value.end.to24hours(),
                      ),
                      focusNode: FocusNode(),
                      decoration: InputDecoration(
                        labelText: constants.out,
                        helperText: 'End of the shift',
                        errorText: state.time.valid
                            ? null
                            : 'End date must be later than start date',
                      ),
                      readOnly: true,
                      onTap: () async {
                        final newValue =
                            await _selectTime(state.time.value.end);
                        context.read<AddFormBloc>().add(
                              ShiftTimeInputChanged(
                                ShiftTimeInput(
                                  start: TimeOfDay(
                                    hour: state.time.value.start.hour,
                                    minute: state.time.value.start.minute,
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
                      key: const Key(constants.day),
                      controller: TextEditingController(
                        text: state.date.value.formatted,
                      ),
                      focusNode: FocusNode(),
                      decoration: InputDecoration(
                        labelText: constants.day,
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
                    DurationModifier(
                      absorbing: false,
                      defaultValue: context.read<DurationCubit>().defaultValue,
                    ),
                    ElevatedButton(
                      onPressed: state.time.valid && state.date.valid
                          ? () {
                              final date = state.date.value;
                              final time = state.time.value;
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
                              final shift = Shift(
                                start: start,
                                end: end,
                                duration: Duration(
                                  hours: context
                                      .read<DurationCubit>()
                                      .state
                                      .toInt(),
                                ),
                              );
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
