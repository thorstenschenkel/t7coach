import 'package:flutter/material.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';
import 'package:t7coach/shared/input_constants.dart';
import 'package:t7coach/shared/widgets/error_box_widget.dart';

class LevelFrom extends StatefulWidget {
  List<String> levels;
  final Function addLevel;

  LevelFrom(@required this.levels, @required this.addLevel) {}

  @override
  _LevelFromState createState() => _LevelFromState();
}

class _LevelFromState extends State<LevelFrom> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _visibilityError = false;
  String error = '';
  String _levelName;

  Widget _buildErrorBox() {
    return Visibility(
      visible: _visibilityError,
      child: ErrorBoxWidget(error),
    );
  }

  void _setError(String text) {
    setState(() {
      error = text;
      _visibilityError = true;
    });
  }

  bool _checkLevels(String level) {
    if (widget.levels.contains(level)) {
      _setError('Ein Level mit diesem Namen existiert bereits.');
      return false;
    } else {
      setState(() {
        _visibilityError = false;
      });
      return true;
    }
  }

  _save() {
    _formKey.currentState.save();
    setState(() {
      _autoValidate = true;
      error = '';
      _visibilityError = false;
    });
    if (_formKey.currentState.validate()) {
      if (!_checkLevels(_levelName)) {
        return;
      }
      widget.addLevel(_levelName);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildErrorBox(),
          Text('Neuer Leistungslevel', style: heading2TextStyle, textAlign: TextAlign.left),
          SizedBox(height: 10),
          TextFormField(
              onChanged: (String val) {
                if (_autoValidate) {
                  _checkLevels(val);
                } else {
                  _visibilityError = false;
                }
              },
              onSaved: (String val) {
                setState(() {
                  _levelName = val;
                });
              },
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: textInputDecoration.copyWith(labelText: 'Levelname'),
              validator: (String val) => val.isEmpty ? 'Bitte gib einen Namen für diesen Level ein.' : null),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              OutlineButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text('Abbrechen'),
              ),
              SizedBox(width: 10),
              RaisedButton(
                onPressed: () async {
                  await _save();
                },
                child: Text('OK'),
              ),
            ],
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}
