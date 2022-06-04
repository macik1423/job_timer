import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/widgets/snackbars.dart';

import '../../cubit/duration/duration_cubit.dart';
import '../../widgets/duration_modifier.dart';

class DefaultValueOption extends StatelessWidget {
  const DefaultValueOption({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final durationCubit = context.read<DurationCubit>();
    return Dialog(
      child: SizedBox(
        width: 450,
        height: 250,
        child: Form(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Text(
                    'Change duration shift default value',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  color: Colors.lightBlue[50],
                  thickness: 2,
                  height: 30,
                ),
                DurationModifier(
                  absorbing: false,
                  defaultValue: durationCubit.defaultValue,
                ),
                ElevatedButton(
                    onPressed: () {
                      final value = durationCubit.state;
                      durationCubit.changeDefaultValue(value);
                      Navigator.pop(context);
                      final snackBar = PositiveSnackBar(
                        content: Text('Saved new default duration: $value'),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: const Text("Save")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
