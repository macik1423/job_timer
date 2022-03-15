import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timer/repository/shift_repository.dart';
import '../exception.dart';
import '../model/shift.dart';

part 'repo_state.dart';
part 'repo_event.dart';

class RepoBloc extends Bloc<RepoEvent, RepoState> {
  RepoBloc(ShiftRepository shiftRepository)
      : _shiftRepository = shiftRepository,
        super(const RepoState()) {
    on<RepoSubscriptionRequested>(getShifts);
    on<RepoShiftSaved>(saveShift);
  }

  final ShiftRepository _shiftRepository;

  Future<void> getShifts(
      RepoSubscriptionRequested event, Emitter<RepoState> emit) async {
    emit(state.copyWith(status: RepoStateStatus.loading));

    await emit.forEach<List<Shift>>(
      _shiftRepository.getShifts(),
      onData: (shifts) => state.copyWith(
        status: RepoStateStatus.success,
        shifts: shifts,
      ),
      onError: (_, __) => state.copyWith(
        status: RepoStateStatus.failure,
      ),
    );
  }

  Future<void> saveShift(RepoShiftSaved event, Emitter<RepoState> emit) async {
    try {
      await _shiftRepository.saveShift(event.shift);
    } on ShiftAlreadyExistsException catch (error) {
      emit(
        state.copyWith(
          status: RepoStateStatus.failure,
          message: error.message,
        ),
      );
    }
  }
}
