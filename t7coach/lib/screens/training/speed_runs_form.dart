import 'package:flutter/material.dart';

class SpeedRunsFrom extends StatefulWidget {
  @override
  _SpeedRunsFromState createState() => _SpeedRunsFromState();
}

class _SpeedRunsFromState extends State<SpeedRunsFrom> {
  List<Widget> detailsWidgets = [Text('SpeedRuns')];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: detailsWidgets,
    );
  }
}
