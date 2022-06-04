import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cubit/duration/duration_cubit.dart';

class DurationModifier extends StatefulWidget {
  const DurationModifier(
      {Key? key, required this.absorbing, required this.defaultValue})
      : super(key: key);
  final bool absorbing;
  final double defaultValue;

  @override
  State<DurationModifier> createState() => _DurationModifierState();
}

class _DurationModifierState extends State<DurationModifier> {
  late double _currentSliderValue = widget.defaultValue;
  @override
  Widget build(BuildContext context) {
    final defaultText =
        _currentSliderValue == context.read<DurationCubit>().defaultValue
            ? '(default) '
            : '';
    final absorbing = widget.absorbing;
    return SizedBox(
      width: 420,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Duration', style: TextStyle(fontSize: 20.0)),
                Row(
                  children: [
                    Text(defaultText,
                        style:
                            const TextStyle(fontSize: 15.0, color: Colors.grey),
                        textAlign: TextAlign.justify),
                    Text('${_currentSliderValue.round()} h',
                        style: const TextStyle(fontSize: 20.0))
                  ],
                )
              ],
            ),
          ),
          AbsorbPointer(
            absorbing: absorbing,
            child: Slider(
              activeColor: absorbing ? Colors.grey[400] : Colors.blue[500],
              inactiveColor: absorbing ? Colors.grey[400] : Colors.blue[100],
              value: _currentSliderValue,
              max: 12,
              min: 6,
              divisions: 6,
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(
                  () {
                    _currentSliderValue = value;
                  },
                );
              },
              onChangeEnd: (double value) {
                context.read<DurationCubit>().changeValue(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
