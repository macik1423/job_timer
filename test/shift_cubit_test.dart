import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timer/cubit/shift/shift_cubit.dart';
import 'package:timer/cubit/shift/shift_state.dart';
import 'package:timer/main.dart';
import 'package:timer/screen/root_screen.dart';

import 'helpers/hydrated_bloc.dart';

class MockShiftCubit extends MockCubit<ShiftState> implements ShiftCubit {}

class MockHiveInterface extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box {}

void main() {
  late MockHiveInterface mockHiveInterface;
  late MockHiveBox mockHiveBox;

  setUp(() async {
    mockHiveInterface = MockHiveInterface();
    mockHiveBox = MockHiveBox();
    when(() async => await mockHiveInterface.openBox(any()))
        .thenAnswer((_) async => mockHiveBox);
  });

  group('ShiftCubit', () {
    testWidgets('renders root screen', (tester) async {
      await mockHydratedStorage(() async {
        await tester.pumpWidget(const MyApp());
      });
      expect(find.byType(RootScreen), findsOneWidget);
    });
  });
}
