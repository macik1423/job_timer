part of 'add_form_bloc.dart';

class AddFormState extends Equatable {
  final AddShiftTime shift;
  final AddShiftDate date;
  final FormzStatus status;

  const AddFormState({
    this.shift = const AddShiftTime.pure(),
    this.date = const AddShiftDate.pure(),
    this.status = FormzStatus.pure,
  });

  AddFormState copyWith({
    AddShiftTime? shift,
    AddShiftDate? date,
    FormzStatus? status,
  }) {
    return AddFormState(
      shift: shift ?? this.shift,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [shift, date, status];
}
