import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timer/cubit/shift/shift_cubit.dart';
import 'package:timer/cubit/shift/shift_state.dart';
import 'package:timer/main.dart';
import 'package:timer/model/shift.dart';
import 'package:mocktail/mocktail.dart';

class MockShiftCubit extends MockCubit<ShiftState> implements ShiftCubit {}

class MockStorage extends Mock implements Storage {}

void main() {
  late MockShiftCubit mockShiftCubit;

  group('ShiftCubit', () {
    Storage storage;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      storage = MockStorage();
      when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
      HydratedBlocOverrides.runZoned(() => MyApp(), storage: storage);
      mockShiftCubit = MockShiftCubit();
    });

    blocTest(
      "init",
      build: () => ShiftCubit(),
      expect: () => InitaialShiftState(
        shift: Shift(start: null, end: null),
        enabledStart: true,
        enabledEnd: false,
      ),
    );
  });
}
