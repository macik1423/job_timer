import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timer/model/shift.dart';
import 'package:timer/repository/shift_api.dart';
import 'package:timer/repository/shift_hive.dart';
import 'package:timer/repository/shift_repository.dart';
import 'package:timer/shift_box.dart';
import 'package:timer/util/exception.dart';
import 'package:timer/util/time_util.dart';

import 'helpers/mocking_classes.dart';

void main() {
  List<Shift> shiftList = [
    Shift(
      start: DateTime.now(),
      end: DateTime.now(),
      duration: const Duration(hours: 8),
    )
  ];
  group('repository', () {
    late ShiftHiveApi shiftHiveApi;
    late ShiftRepository shiftRepository;
    late ShiftApi mockShiftApi;
    late ShiftBox mockShiftBox;
    late Box<Shift> mockBox;
    setUpAll(() {
      mockShiftBox = MockShiftBox();
      mockBox = MockBox<Shift>();
      mockShiftApi = MockShiftApi();
      shiftRepository = ShiftRepository(shiftApi: mockShiftApi);
      when(mockShiftBox.openBox)
          .thenAnswer((_) async => await Future.value(mockBox));
      when(() => mockBox.values).thenReturn(shiftList);

      shiftHiveApi = ShiftHiveApi(mockShiftBox);
    });

    test('should retrieve all shifts when getAll is called', () async {
      when(mockShiftApi.getAll)
          .thenAnswer((_) async => await Future.value(shiftList));
      final all = await shiftRepository.getAll();
      expect(all, shiftList);

      verify(() => mockShiftApi.getAll()).called(1);
      verifyNoMoreInteractions(mockShiftApi);
    });

    test('should save shift when saveShift is called', () async {
      final newShift = Shift(
        start: DateTime.now(),
        end: DateTime.now(),
        duration: const Duration(hours: 8),
      );
      when(() => mockShiftApi.saveShift(newShift))
          .thenAnswer((_) => Future.value());

      final result = shiftRepository.saveShift(newShift);

      expect(result, isA<Future<void>>());

      verify(() => mockShiftApi.saveShift(newShift));
      verifyNoMoreInteractions(mockShiftApi);
    });

    test('should throw exception if shift already exists', () async {
      final newShift = Shift(
        start: DateTime.now(),
        end: DateTime.now(),
        duration: const Duration(hours: 8),
      );

      await expectLater(
        () async => await shiftHiveApi.saveShift(newShift),
        throwsA(
          isA<ShiftAlreadyExistsException>().having(
            (error) => error.message,
            'message',
            'Shift ${TimeUtil.formatDate(newShift.start)} already exists',
          ),
        ),
      );
    });
  });
}
