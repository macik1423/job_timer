import 'package:flutter_test/flutter_test.dart';
import 'package:timer/cubit/duration/duration_cubit.dart';

import '../helpers/hydrated_bloc.dart';

void main() {
  group('DurationCubit', () {
    test('initial state is correct', () async {
      await mockHydratedStorage(() {
        expect(
          DurationCubit().state,
          8.0,
        );
      });
    });

    test('should changed value', () async {
      await mockHydratedStorage(() {
        final cubit = DurationCubit();
        cubit.changeValue(5.0);
        expect(
          cubit.state,
          5.0,
        );
      });
    });

    test('should changed default value', () async {
      await mockHydratedStorage(() {
        final cubit = DurationCubit();
        cubit.changeDefaultValue(5.0);
        expect(
          cubit.defaultValue,
          5.0,
        );
      });
    });

    test('should reset to default', () async {
      await mockHydratedStorage(() {
        final cubit = DurationCubit();
        cubit.resetToDefault();
        expect(
          cubit.state,
          cubit.defaultValue,
        );
      });
    });
  });
}
