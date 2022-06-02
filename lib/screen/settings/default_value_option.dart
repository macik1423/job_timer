import 'package:flutter/material.dart';

import '../../cubit/duration/duration_cubit.dart';
import '../../widgets/duration_modifier.dart';

class DefaultValueOption extends StatelessWidget {
  const DefaultValueOption({
    Key? key,
    required this.durationCubit,
  }) : super(key: key);

  final DurationCubit durationCubit;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 400,
        height: 200,
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
