import 'package:flutter/material.dart';
import 'package:t7coach/models/training_types.dart';
import 'package:t7coach/screens/training/details/single_detail.dart';

class NoteDetail extends SingleDetail {
  final Note note;
  final Function delete;

  NoteDetail(this.note, this.delete) : super(note, delete);

  @override
  String getLable() {
    return null;
  }

  @override
  Icon getIcon() {
    return Icon(Icons.speaker_notes);
  }

  @override
  Widget createTitle(BuildContext context) {
    return Text('Bemerkung');
  }

  @override
  Widget createSubTitle(BuildContext context) {
    return Text(getText());
  }
}
