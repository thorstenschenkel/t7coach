import 'package:flutter/material.dart';
import 'package:t7coach/models/training_types.dart';
import 'package:t7coach/screens/training/details/single_detail.dart';

class NoteDetail extends SingleDetail {
  final Note note;

  NoteDetail(this.note) : super(note) {}

  @override
  String getLable() {
    return 'Bemerkung';
  }

  @override
  Icon getIcon() {
    return Icon(Icons.speaker_notes);
  }
}
