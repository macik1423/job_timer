import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:timer/model/add_form/add_shift.dart';

import '../../model/add_form/shift_input.dart';

part 'add_form_event.dart';
part 'add_form_state.dart';

class AddFormBloc extends Bloc<AddFormEvent, AddFormState> {
  AddFormBloc() : super(const AddFormState()) {
    on<ShiftInputChanged>(_onShiftChanged);
  }

  @override
  void onTransition(Transition<AddFormEvent, AddFormState> transition) {
    super.onTransition(transition);
  }

  void _onShiftChanged(ShiftInputChanged event, Emitter<AddFormState> emit) {
    final shiftInput = AddShift.dirty(value: event.input);
    emit(
      state.copyWith(
        shift:
            shiftInput.valid ? shiftInput : AddShift.pure(value: event.input),
        status: Formz.validate([shiftInput, state.shift]),
      ),
    );
  }
}
