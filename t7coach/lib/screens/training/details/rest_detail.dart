import 'package:flutter/material.dart';
import 'package:t7coach/models/training_types.dart';
import 'package:t7coach/screens/training/details/single_detail.dart';

class RestDetail extends SingleDetail {
  final Rest rest;
  final Function delete;

  RestDetail(this.rest, this.delete) : super(rest, delete);

  @override
  String getLable() {
    return 'Pause';
  }

  @override
  Icon getIcon() {
    return Icon(Icons.free_breakfast);
  }
}
