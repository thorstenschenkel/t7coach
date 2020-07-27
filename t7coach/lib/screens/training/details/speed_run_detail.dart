import 'package:flutter/material.dart';
import 'package:t7coach/models/training_types.dart';
import 'package:t7coach/screens/training/details/single_detail.dart';

class SpeedRunDetail extends SingleDetail {
  final SpeedRun run;

  SpeedRunDetail(this.run) : super(run);

  @override
  String getLable() {
    return 'Tempolauf';
  }

  @override
  Icon getIcon() {
    return Icon(Icons.directions_run);
  }
}
