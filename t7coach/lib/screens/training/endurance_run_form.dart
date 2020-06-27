import 'package:flutter/material.dart';

class EnduranceRunFrom extends StatefulWidget {
  @override
  _EnduranceRunFromState createState() => _EnduranceRunFromState();
}

class _EnduranceRunFromState extends State<EnduranceRunFrom> {
  List<Widget> detailsWidgets = [Text('EnduranceRun')];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: detailsWidgets,
    );
  }
}
