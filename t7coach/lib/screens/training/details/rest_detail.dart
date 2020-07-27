import 'package:flutter/material.dart';
import 'package:t7coach/models/training_types.dart';
import 'package:t7coach/screens/training/details/single_detail.dart';

class RestDetail extends SingleDetail {
  final Rest rest;

  RestDetail(this.rest) : super(rest);

  @override
  String getLable() {
    return 'Pause';
  }

  @override
  Icon getIcon() {
    return Icon(Icons.free_breakfast);
  }
}
