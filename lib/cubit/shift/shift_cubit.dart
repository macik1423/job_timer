import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timer/cubit/shift/shift_state.dart';

import '../../model/shift.dart';

class ShiftCubit extends HydratedCubit<ShiftState> {
  ShiftCubit()
      : super(
          InitaialShiftState(
            shift: Shift(
              start: null,
              end: null,
            ),
            enabledStart: true,
            enabledEnd: false,
          ),
        );

  void updateStart(DateTime start) {
    emit(
      StartTapped(
        shift: Shift(
          start: start,
          end: null,
        ),
        enabledStart: false,
        enabledEnd: true,
      ),
    );
  }

  void updateEnd(DateTime end) {
    emit(
      EndTapped(
        shift: Shift(
          start: state.shift.start,
          end: end,
        ),
        enabledStart: false,
        enabledEnd: false,
      ),
    );
  }

  void resetNewDay() {
    emit(
      InitaialShiftState(
        shift: Shift(
          start: null,
          end: null,
        ),
        enabledStart: true,
        enabledEnd: false,
      ),
    );
  }

  @override
  ShiftState? fromJson(Map<String, dynamic> json) {
    return ShiftState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(ShiftState state) {
    return state.toMap();
  }
}
