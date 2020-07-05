import 'package:flutter/material.dart';
import 'package:t7coach/models/training_types.dart';
import 'package:t7coach/screens/training/details/single_detail.dart';

class RunDetail extends SingleDetail {
  final Run run;

  RunDetail(this.run) : super(run) {}

  @override
  String getLable() {
    return 'Dauerlauf';
  }

  @override
  Icon getIcon() {
    return Icon(Icons.directions_run);
  }
}
