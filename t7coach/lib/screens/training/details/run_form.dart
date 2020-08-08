import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t7coach/models/training_types.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';
import 'package:t7coach/screens/training/details/run_detail.dart';
import 'package:t7coach/screens/training/details/single_form_inner.dart';
import 'package:t7coach/screens/training/details/sinlge_form.dart';
import 'package:t7coach/shared/input_constants.dart';

const PREF_RUNFROM_DURATIONTYPE = 'runFrom_durationType';
const PREF_RUNFROM_RUNTYPE = 'runFrom_runType';

class RunForm extends StatefulWidget with SingleForm {
  final Function addDetail;
  final Run run;

  RunForm(this.addDetail, this.run) {
    detail = run;
  }

  @override
  _RunFormState createState() => _RunFormState();
}

class _RunFormState extends State<RunForm> with SingleFormInner {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  RunType _runType;
  DurationType _durationType;
  String _duration;

  _save() async {
    _formKey.currentState.save();
    setState(() {
      _autoValidate = true;
    });
    if (_formKey.currentState.validate()) {
      Run run;
      if (widget.detail != null) {
        run = widget.detail;
        run.runType = _runType;
        run.durationType = _durationType;
        run.duration = _duration;
      } else {
        run = Run(_runType, _durationType, _duration);
      }
      RunDetail runDetail = RunDetail(run);
      widget.addDetail(runDetail);
      Navigator.pop(context);
      if (widget.detail == null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(PREF_RUNFROM_DURATIONTYPE, DurationTypeMap[_durationType]);
        await prefs.setString(PREF_RUNFROM_RUNTYPE, RunTypeMap[_runType]);
      }
    }
  }

  bool _showDistanze(DurationType durationType) {
    return _durationType == DurationType.METRES || _durationType == DurationType.KILOMETRES;
  }

  Future<bool> asyncInit() async {
    if (_duration == null && widget.run != null) {
      _duration = widget.run.duration;
    }
    if (_durationType == null && widget.run != null) {
      _durationType = widget.run.durationType;
    }
    if (_durationType == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String pref = prefs.getString(PREF_RUNFROM_DURATIONTYPE);
      if (pref != null) {
        _durationType = getDurationTypeByString(pref);
      }
      _durationType = _durationType ?? DurationType.METRES;
    }
    if (_runType == null && widget.run != null) {
      _runType = widget.run.runType;
    }
    if (_runType == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String pref = prefs.getString(PREF_RUNFROM_RUNTYPE);
      if (pref != null) {
        _runType = getRunTypeByString(pref);
      }
      _runType = _runType ?? RunType.EASY_RUN;
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
                      Text('Dauerlauf', style: heading2TextStyle, textAlign: TextAlign.left),
                    ],
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                      value: _runType,
                      decoration: textInputDecoration.copyWith(labelText: 'Art des Dauerlaufs'),
                      items: createRunTypes(),
                      onChanged: (val) {
                        setState(() {
                          _runType = val;
                        });
                      }),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Visibility(
                        visible: _showDistanze(_durationType),
                        child: Expanded(
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
                              decoration: textInputDecoration.copyWith(labelText: 'Distanz'),
                              validator: (String val) => val.isEmpty ? 'Bitte gib Länge\n des Laufs ein.' : null),
                        ),
                      ),
                      Visibility(
                        visible: !_showDistanze(_durationType),
                        child: Expanded(
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
                              keyboardType: TextInputType.datetime,
                              textInputAction: TextInputAction.next,
                              decoration: textInputDecoration.copyWith(labelText: 'Dauer'),
                              validator: (String val) => val.isEmpty ? 'Bitte gib Länge\n des Laufs ein.' : null),
                        ),
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
