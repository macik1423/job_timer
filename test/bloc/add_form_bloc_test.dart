import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timer/bloc/add_form/add_form_bloc.dart';
import 'package:timer/model/add_form/add_shift.dart';
import 'package:timer/model/add_form/shift_input.dart';

import '../helpers/hydrated_bloc.dart';

void main() {
  group('Add form bloc', () {
    late ShiftTimeInput shiftTimeInput;
    late ShiftDateInput shiftDateInput;
    late ShiftTimeInput invalidShiftTimeInput;
    setUp(() {
      const start = TimeOfDay(hour: 8, minute: 0);
      const end = TimeOfDay(hour: 12, minute: 0);
      shiftTimeInput = const ShiftTimeInput(start: start, end: end);
      shiftDateInput =
          const ShiftDateInput(day: '10', month: '10', year: '2022');

      final endBeforeStart = TimeOfDay(hour: start.hour - 3, minute: 0);
      invalidShiftTimeInput = ShiftTimeInput(start: start, end: endBeforeStart);
    });

    test('initial state is correct', () async {
      await mockHydratedStorage(() {
        expect(
          AddFormBloc().state,
          const AddFormState(
            time: AddShiftTime.pure(),
            date: AddShiftDate.pure(),
          ),
        );
      });
    });

    blocTest<AddFormBloc, AddFormState>(
      'valid set time and date',
      build: () => AddFormBloc(),
      act: (bloc) => bloc
        ..add(ShiftTimeInputChanged(shiftTimeInput))
        ..add(ShiftDateInputChanged(shiftDateInput)),
      expect: () => <AddFormState>[
        AddFormState(
          time: AddShiftTime.dirty(value: shiftTimeInput),
        ),
        AddFormState(
          time: AddShiftTime.dirty(value: shiftTimeInput),
          date: AddShiftDate.dirty(value: shiftDateInput),
        ),
      ],
    );

    blocTest<AddFormBloc, AddFormState>(
      'invalid time',
      build: () => AddFormBloc(),
      act: (bloc) => bloc.add(ShiftTimeInputChanged(invalidShiftTimeInput)),
      expect: () => <AddFormState>[
        AddFormState(
          time: AddShiftTime.pure(value: invalidShiftTimeInput),
        ),
      ],
    );

    blocTest<AddFormBloc, AddFormState>(
      'valid time',
      build: () => AddFormBloc(),
      act: (bloc) => bloc.add(ShiftTimeInputChanged(shiftTimeInput)),
      expect: () => <AddFormState>[
        AddFormState(
          time: AddShiftTime.dirty(value: shiftTimeInput),
        ),
      ],
    );
  });
}
