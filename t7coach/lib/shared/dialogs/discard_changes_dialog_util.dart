import 'package:flutter/material.dart';

enum CloseForm { YES, NO }

class DiscardChangesDialogUtil {
  static Future<CloseForm> showDiscardChangesDialog(BuildContext context) async {
    return showDialog<CloseForm>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nicht gespeichert Änderungen'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
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
