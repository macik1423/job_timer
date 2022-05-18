import 'package:flutter_test/flutter_test.dart';
import 'package:timer/cubit/shift/shift_cubit.dart';
import 'package:timer/cubit/shift/shift_state.dart';
import 'package:timer/model/shift.dart';

import '../helpers/hydrated_bloc.dart';

void main() {
  group('ShiftCubit', () {
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
          final shiftCubit = ShiftCubit();
          expect(
            shiftCubit.fromJson(shiftCubit.toJson(shiftCubit.state)),
            shiftCubit.state,
          );
        });
      });
    });
  });
}
