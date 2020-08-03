import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t7coach/models/training_types.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';
import 'package:t7coach/screens/training/details/single_form_inner.dart';
import 'package:t7coach/screens/training/details/sinlge_form.dart';
import 'package:t7coach/screens/training/details/speed_run_detail.dart';
import 'package:t7coach/shared/input_constants.dart';

const PREF_SPEEDRUNFROM_DURATIONTYPE = 'speedRunFrom_durationType';

class SpeedRunForm extends StatefulWidget with SingleForm {
  final Function addDetail;
  final SpeedRun speedRun;

  SpeedRunForm(this.addDetail, this.speedRun) {
    detail = speedRun;
  }

  @override
  _SpeedRunFormState createState() => _SpeedRunFormState();
}

class _SpeedRunFormState extends State<SpeedRunForm> with SingleFormInner {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  DurationType _durationType;
  String _duration;

  _save() async {
    _formKey.currentState.save();
    setState(() {
      _autoValidate = true;
    });
    if (_formKey.currentState.validate()) {
      SpeedRun run;
      if (widget.detail != null) {
        run = widget.detail;
        run.durationType = _durationType;
        run.duration = _duration;
      } else {
        run = SpeedRun(_durationType, _duration);
      }
      SpeedRunDetail runDetail = SpeedRunDetail(run);
      widget.addDetail(runDetail);
      Navigator.pop(context);
      if (widget.detail == null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(PREF_SPEEDRUNFROM_DURATIONTYPE, DurationTypeMap[_durationType]);
      }
    }
  }

  Future<bool> asyncInit() async {
    if (_duration == null && widget.speedRun != null) {
      _duration = widget.speedRun.duration;
    }
    if (_durationType == null && widget.speedRun != null) {
      _durationType = widget.speedRun.durationType;
    }
    if (_durationType == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String pref = prefs.getString(PREF_SPEEDRUNFROM_DURATIONTYPE);
      if (pref != null) {
        _durationType = getDurationTypeByString(pref);
      }
      _durationType = _durationType ?? DurationType.METRES;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: asyncInit(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                            autofocus: true,
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
                            validator: (String val) =>
                                val.isEmpty ? 'Bitte gib Distanz\nbzw. Dauer des Laufs ein.' : null),
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
                  createCancelAndOk(context, _save),
                  SizedBox(height: 20)
                ]));
          } else {
            return LinearProgressIndicator();
          }
        });
  }
}
