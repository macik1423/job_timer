part of 'add_form_bloc.dart';

class AddFormState extends Equatable {
  final AddShiftTime time;
  final AddShiftDate date;

  const AddFormState({
    this.time = const AddShiftTime.pure(),
    this.date = const AddShiftDate.pure(),
  });

  AddFormState copyWith({
    AddShiftTime? time,
    AddShiftDate? date,
  }) {
    return AddFormState(
      time: time ?? this.time,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'AddFormState{time: $time, date: $date}';
  }

  @override
  List<Object?> get props => [time, date];
}
