import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timer/cubit/shift/shift_cubit.dart';
import 'package:timer/cubit/shift/shift_state.dart';
import 'package:timer/model/shift.dart';
import 'package:timer/repository/shift_api.dart';
import 'package:timer/repository/shift_repository.dart';
import 'package:timer/shift_box.dart';

class MockShiftCubit extends MockCubit<ShiftState> implements ShiftCubit {}

class MockShiftBox extends Mock implements ShiftBox {}

class MockBox<T> extends Mock implements Box<T> {}

class MockShiftApi extends Mock implements ShiftApi {}

void main() {
  List<Shift> shiftList = [Shift(start: DateTime.now(), end: DateTime.now())];
  group('repository', () {
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
      final newShift = Shift(start: DateTime.now(), end: DateTime.now());
      when(() => mockShiftApi.saveShift(newShift))
          .thenAnswer((_) => Future.value());

      final result = shiftRepository.saveShift(newShift);

      expect(result, isA<Future<void>>());

      verify(() => mockShiftApi.saveShift(newShift));
      verifyNoMoreInteractions(mockShiftApi);
    });
  });
}
