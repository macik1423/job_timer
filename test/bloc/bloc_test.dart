import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timer/cubit/shift/shift_cubit.dart';
import 'package:timer/cubit/shift/shift_state.dart';
import 'package:timer/model/shift.dart';

import '../helpers/hydrated_bloc.dart';

void main() {
  group('ShiftCubit', () {
    late ShiftCubit shiftCubit;
    late DateTime startDateTime;
    late DateTime endDateTime;
    setUp(() async {
      shiftCubit = await mockHydratedStorage(() => ShiftCubit());
      startDateTime = DateTime.now();
      endDateTime = DateTime.now().add(const Duration(hours: 1));
    });

    test('initial state is correct', () async {
      await mockHydratedStorage(() {
        expect(
          ShiftCubit().state,
          ShiftState(
            shift: Shift(
              start: null,
              end: null,
              duration: const Duration(hours: 8),
            ),
            enabledStart: true,
            enabledEnd: false,
            status: ShiftStateStatus.initial,
          ),
        );
      });
    });

    group('toJson/fromJson', () {
      test('work properly', () async {
        await mockHydratedStorage(() {
          expect(
            shiftCubit.fromJson(shiftCubit.toJson(shiftCubit.state)),
            shiftCubit.state,
          );
        });
      });
    });

    group('fetch shift', () {
      blocTest<ShiftCubit, ShiftState>(
        'reset new day',
        build: () => shiftCubit,
        act: (cubit) => cubit.resetNewDay(),
        expect: () => <ShiftState>[
          ShiftState(
            shift: Shift(
              start: null,
              end: null,
              duration: const Duration(hours: 8),
            ),
            enabledStart: true,
            enabledEnd: false,
            status: ShiftStateStatus.initial,
          ),
        ],
      );

      blocTest<ShiftCubit, ShiftState>(
        'tapped start',
        build: () => shiftCubit,
        act: (cubit) => cubit.updateStart(startDateTime),
        expect: () => <ShiftState>[
          ShiftState(
            shift: Shift(
              start: startDateTime,
              end: null,
              duration: const Duration(hours: 8),
            ),
            enabledStart: false,
            enabledEnd: true,
            status: ShiftStateStatus.startTapped,
          ),
        ],
      );

      blocTest<ShiftCubit, ShiftState>(
        'tapped end',
        build: () => shiftCubit,
        act: (cubit) => cubit.updateEnd(startDateTime, endDateTime),
        expect: () => <ShiftState>[
          ShiftState(
            shift: Shift(
              start: startDateTime,
              end: endDateTime,
              duration: const Duration(hours: 8),
            ),
            enabledStart: false,
            enabledEnd: false,
            status: ShiftStateStatus.endTapped,
          ),
        ],
      );
    });
  });
}
