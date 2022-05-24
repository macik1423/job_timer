import 'package:flutter/material.dart';

class ShiftCard extends StatelessWidget {
  final Color color;
  final String title;
  final Function onTap;
  final String tappedTime;
  final bool enabled;
  final String subtitle;
  const ShiftCard({
    Key? key,
    required this.color,
    required this.title,
    required this.onTap,
    required this.tappedTime,
    required this.enabled,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(80, 10, 80, 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          elevation: 5,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        onPressed: enabled ? () => onTap() : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title, style: const TextStyle(fontSize: 40)),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                    child: Text(
                      tappedTime,
                      style: const TextStyle(color: Colors.black, fontSize: 25),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      subtitle,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
