import 'package:flutter/material.dart';
import 'package:t7coach/models/training_types.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';
import 'package:t7coach/screens/training/details/single_form.dart';
import 'package:t7coach/screens/training/details/speed_run_detail.dart';
import 'package:t7coach/shared/input_constants.dart';

class SpeedRunForm extends StatefulWidget {
  final Function addDetail;

  SpeedRunForm(this.addDetail);

  @override
  _SpeedRunFormState createState() => _SpeedRunFormState();
}

class _SpeedRunFormState extends State<SpeedRunForm> with SingleForm {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  DurationType _durationType;
  String _duration;

  _save() {
    _formKey.currentState.save();
    setState(() {
      _autoValidate = true;
    });
    if (_formKey.currentState.validate()) {
      SpeedRun run = SpeedRun(_durationType, _duration);
      SpeedRunDetail runDetail = SpeedRunDetail(run);
      widget.addDetail(runDetail);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _durationType = _durationType ?? DurationType.METRES;
    return Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.directions_run, size: 20),
              SizedBox(width: 5),
              Text('Tempolauf', style: heading2TextStyle, textAlign: TextAlign.left),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                    initialValue: _duration,
                    onSaved: (String val) {
                      setState(() {
                        _duration = val;
                      });
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).nextFocus();
                    },
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: textInputDecoration.copyWith(labelText: 'Distanz / Dauer'),
                    validator: (String val) => val.isEmpty ? 'Bitte gib Distanz\nbzw. Dauer des Laufs ein.' : null),
              ),
              SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField(
                    value: _durationType,
                    decoration: textInputDecoration.copyWith(labelText: 'Einheit'),
                    items: createDurationTypes(),
                    onChanged: (val) {
                      setState(() {
                        _durationType = val;
                      });
                    }),
              ),
            ],
          ),
          SizedBox(height: 10),
          createCancleAndOk(context, _save),
          SizedBox(height: 20)
        ]));
  }
}
