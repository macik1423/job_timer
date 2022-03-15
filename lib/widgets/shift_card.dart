import 'package:flutter/material.dart';

class ShiftCard extends StatelessWidget {
  final Color color;
  final String title;
  final Function onTap;
  final String tappedTime;
  final bool enabled;
  const ShiftCard({
    Key? key,
    required this.color,
    required this.title,
    required this.onTap,
    required this.tappedTime,
    required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(80, 10, 80, 10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: color,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(title),
              subtitle: Text(
                tappedTime,
                style: const TextStyle(color: Colors.black),
              ),
              onTap: () => onTap(),
              enabled: enabled,
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }
}
