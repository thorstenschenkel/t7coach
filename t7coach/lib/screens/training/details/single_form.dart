import 'package:flutter/material.dart';
import 'package:t7coach/models/training_types.dart';

class SingleForm {
  Widget createCancleAndOk(BuildContext context, Function save) {
    return Row(
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
            await save();
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  List<DropdownMenuItem> createRestTypes() {
    List<DropdownMenuItem> items = [];
    RestTypeMap.forEach((type, name) {
      DropdownMenuItem item = DropdownMenuItem(value: type, child: Text(name));
      items.add(item);
    });
    return items;
  }

  List<DropdownMenuItem> createRunTypes() {
    List<DropdownMenuItem> items = [];
    RunTypeMap.forEach((type, name) {
      DropdownMenuItem item = DropdownMenuItem(value: type, child: Text(name));
      items.add(item);
    });
    return items;
  }

  List<DropdownMenuItem> createDurationTypes() {
    List<DropdownMenuItem> items = [];
    DurationTypeMap.forEach((type, name) {
      DropdownMenuItem item = DropdownMenuItem(value: type, child: Text(name));
      items.add(item);
    });
    return items;
  }
}
