import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timer/cubit/shift/shift_state.dart';

import '../../model/shift.dart';

class ShiftCubit extends HydratedCubit<ShiftState> {
  ShiftCubit()
      : super(
          ShiftState(
            shift: Shift(
              start: null,
              end: null,
            ),
            enabledStart: true,
            enabledEnd: false,
            status: ShiftStateStatus.initial,
          ),
        );

  void updateStart(DateTime start) {
    emit(
      ShiftState(
        shift: Shift(
          start: start,
          end: null,
        ),
        enabledStart: false,
        enabledEnd: true,
        status: ShiftStateStatus.startTapped,
      ),
    );
  }

  void updateEnd(DateTime start, DateTime end) {
    emit(
      ShiftState(
        shift: Shift(
          start: start,
          end: end,
        ),
        enabledStart: false,
        enabledEnd: false,
        status: ShiftStateStatus.endTapped,
      ),
    );
  }

  void resetNewDay() {
    emit(
      ShiftState(
        shift: Shift(
          start: null,
          end: null,
        ),
        enabledStart: true,
        enabledEnd: false,
        status: ShiftStateStatus.initial,
      ),
    );
  }

  @override
  ShiftState fromJson(Map<String, dynamic> json) {
    return ShiftState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(ShiftState state) {
    return state.toJson();
  }
}
