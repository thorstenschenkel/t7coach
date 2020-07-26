import 'package:flutter/material.dart';
import 'package:t7coach/models/training_types.dart';
import 'package:t7coach/shared/input_constants.dart';

abstract class SingleDetail {
//  @override
//  Key get key => ObjectKey(detail.uuid);

  final Detail detail;
  final Function delete;

  SingleDetail(this.detail, this.delete);

  String getLable() {
    throw UnimplementedError();
  }

  String getText() {
    return detail.getText();
  }

  Icon getIcon() {
    return detail.getIcon();
  }

  Widget createSubTitle(BuildContext context) {
    return null;
  }

  InputDecoration _getTextInputDecoration(BuildContext context, String label) {
    InputDecoration deco = readOnlyTextInputDecoration.copyWith(labelText: label);
    deco = deco.copyWith(
        contentPadding: EdgeInsets.zero,
        fillColor: Theme.of(context).colorScheme.background,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)));
    return deco;
  }

  Widget createTitle(BuildContext context) {
    return TextFormField(
        initialValue: getText(), readOnly: true, decoration: _getTextInputDecoration(context, getLable()));
  }

  ListTile createTile(BuildContext context) {
    return ListTile(
        key: ValueKey(detail.uuid),
        dense: true,
        leading: getIcon(),
        title: createTitle(context),
        subtitle: createSubTitle(context));
  }
}
