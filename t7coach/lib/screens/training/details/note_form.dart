import 'package:flutter/material.dart';
import 'package:t7coach/models/training_types.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';
import 'package:t7coach/screens/training/details/note_detail.dart';
import 'package:t7coach/screens/training/details/single_form_inner.dart';
import 'package:t7coach/screens/training/details/sinlge_form.dart';
import 'package:t7coach/shared/input_constants.dart';

class NoteForm extends StatefulWidget with SingleForm {
  final Function addDetail;
  final Note note;

  NoteForm(this.addDetail, this.note) {
    detail = note;
  }

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> with SingleFormInner {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String _note;

  _save() {
    _formKey.currentState.save();
    setState(() {
      _autoValidate = true;
    });
    if (_formKey.currentState.validate()) {
      Note note;
      if (widget.detail != null) {
        note = widget.detail;
        note.note = _note;
      } else {
        note = Note(_note);
      }
      NoteDetail noteDetail = NoteDetail(note);
      widget.addDetail(noteDetail);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_note == null && widget.note != null) {
      _note = widget.note.note;
    }
    return Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.speaker_notes, size: 20),
              SizedBox(width: 5),
              Text('Bemerkung', style: heading2TextStyle, textAlign: TextAlign.left),
            ],
          ),
          SizedBox(height: 10),
          TextFormField(
              autofocus: true,
              initialValue: _note,
              onSaved: (String val) {
                setState(() {
                  _note = val;
                });
              },
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: textInputDecoration.copyWith(labelText: 'Bermerkung'),
              validator: (String val) => val.isEmpty ? 'Bitte gib eine Text ein.' : null),
          SizedBox(height: 10),
          createCancelAndOk(context, _save),
          SizedBox(height: 20)
        ]));
  }
}
