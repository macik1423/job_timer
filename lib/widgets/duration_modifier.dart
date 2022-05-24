import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DurationModifier extends StatefulWidget {
  const DurationModifier({Key? key, required this.absorbing}) : super(key: key);
  final bool absorbing;

  @override
  State<DurationModifier> createState() => _DurationModifierState();
}

class _DurationModifierState extends State<DurationModifier> {
  double _currentSliderValue = 8;
  @override
  Widget build(BuildContext context) {
    final durationText = 'Duration: ${_currentSliderValue.round()} h';
    final absorbing = widget.absorbing;
    return Column(
      children: <Widget>[
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
                  context.read<SliderChanged>().change(value);
                },
              );
            },
          ),
        ),
        Text(
          _currentSliderValue == 8 ? durationText + ' (default)' : durationText,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}

class SliderChanged extends ChangeNotifier {
  double value = 8.0;

  void change(double newValue) {
    value = newValue;
    notifyListeners();
  }

  void resetToDefault() {
    value = 8.0;
    notifyListeners();
  }
}
