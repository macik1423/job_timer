import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timer/model/add_form/add_shift.dart';

import '../../model/add_form/shift_input.dart';

part 'add_form_event.dart';
part 'add_form_state.dart';

class AddFormBloc extends Bloc<AddFormEvent, AddFormState> {
  AddFormBloc() : super(AddFormState()) {
    on<ShiftTimeInputChanged>(_onShiftTimeChanged);
    on<ShiftDateInputChanged>(_onShiftDateChanged);
  }

  @override
  void onTransition(Transition<AddFormEvent, AddFormState> transition) {
    super.onTransition(transition);
  }

  void _onShiftTimeChanged(
      ShiftTimeInputChanged event, Emitter<AddFormState> emit) {
    final shiftTimeInput = AddShiftTime.dirty(value: event.input);
    emit(
      state.copyWith(
        time: shiftTimeInput.valid
            ? shiftTimeInput
            : AddShiftTime.pure(value: event.input),
      ),
    );
  }

  void _onShiftDateChanged(
      ShiftDateInputChanged event, Emitter<AddFormState> emit) {
    final shiftDateInput = AddShiftDate.dirty(value: event.input);
    emit(
      state.copyWith(
        date: shiftDateInput.valid
            ? shiftDateInput
            : AddShiftDate.pure(value: event.input),
      ),
    );
  }
}
