import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t7coach/models/training_types.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';
import 'package:t7coach/screens/training/details/single_form_inner.dart';
import 'package:t7coach/screens/training/details/sinlge_form.dart';
import 'package:t7coach/shared/input_constants.dart';

import 'file:///C:/develop/flutterApps/t7coach/t7coach/lib/screens/training/details/rest_detail.dart';

const PREF_RESTFROM_DURATIONTYPE = 'restFrom_durationType';
const PREF_RESTFROM_RESTTYPE = 'restFrom_restType';

class RestForm extends StatefulWidget with SingleForm {
  final Function addDetail;
  final Rest rest;

  RestForm(this.addDetail, this.rest) {
    detail = rest;
  }

  @override
  _RestFormState createState() => _RestFormState();
}

class _RestFormState extends State<RestForm> with SingleFormInner {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  RestType _restType;
  DurationType _durationType;
  String _duration;

  _save() {
    _formKey.currentState.save();
    setState(() {
      _autoValidate = true;
    });
    if (_formKey.currentState.validate()) {
      Rest rest = Rest(_restType, _durationType, _duration);
      RestDetail restDetail = RestDetail(rest);
      widget.addDetail(restDetail);
      Navigator.pop(context);
    }
  }

  bool _showDistanze(DurationType durationType) {
    return _durationType == DurationType.METRES || _durationType == DurationType.KILOMETRES;
  }

  Future<bool> asyncInit() async {
    if (_duration == null && widget.rest != null) {
      _duration = widget.rest.duration;
    }
    if (_durationType == null && widget.rest != null) {
      _durationType = widget.rest.durationType;
    }
    if (_durationType == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String pref = prefs.getString(PREF_RESTFROM_DURATIONTYPE);
      if (pref != null) {
        _durationType = getDurationTypeByString(pref);
      }
      _durationType = _durationType ?? DurationType.METRES;
    }
    if (_restType == null && widget.rest != null) {
      _restType = widget.rest.restType;
    }
    if (_restType == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String pref = prefs.getString(PREF_RESTFROM_RESTTYPE);
      if (pref != null) {
        _restType = getRestTypeByString(pref);
      }
      _restType = _restType ?? RestType.JOG;
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
                      Icon(Icons.free_breakfast, size: 20),
                      SizedBox(width: 5),
                      Text('Pause', style: heading2TextStyle, textAlign: TextAlign.left),
                    ],
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                      value: _restType,
                      decoration: textInputDecoration.copyWith(labelText: 'Art der Pause'),
                      items: createRestTypes(),
                      onChanged: (val) {
                        setState(() {
                          _restType = val;
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
                              validator: (String val) => val.isEmpty ? 'Bitte gib Länge\nder Pause ein.' : null),
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
                              validator: (String val) => val.isEmpty ? 'Bitte gib Länge\nder Pause ein.' : null),
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
