import 'package:flutter/material.dart';

enum CloseForm { YES, NO }

class DiscardChangesDialogUtil {
  static Future<CloseForm> showDiscardChangesDialog(BuildContext context) async {
    return showDialog<CloseForm>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Daten wurden bearbeitet.'),
                Text('Sollen die Änderungen verworfen werden?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ja'),
              onPressed: () {
                Navigator.of(context).pop(CloseForm.YES);
              },
            ),
            FlatButton(
              child: Text('Nein'),
              onPressed: () {
                Navigator.of(context).pop(CloseForm.NO);
              },
            ),
          ],
        );
      },
    );
  }
}
