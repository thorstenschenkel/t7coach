import 'package:flutter/material.dart';
import 'package:t7coach/models/training_types.dart';
import 'package:t7coach/shared/input_constants.dart';

abstract class SingleDetail extends StatelessWidget {
  final Detail detail;

  SingleDetail(this.detail) {}

  String getLable() {
    throw UnimplementedError();
  }

  String getText() {
    return detail.getText();
  }

  Icon getIcon() {
    return detail.getIcon();
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration _getTextInputDecoration(String label) {
      InputDecoration deco = readOnlyTextInputDecoration.copyWith(labelText: label);
      deco = deco.copyWith(
          contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          fillColor: Theme.of(context).colorScheme.background,
          prefixIcon: getIcon(),
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)));
      return deco;
    }

    return Row(
      children: <Widget>[
        Expanded(
            child:
                TextFormField(initialValue: getText(), readOnly: true, decoration: _getTextInputDecoration(getLable())))
      ],
    );
  }
}
