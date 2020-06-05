import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialogUtil {
  static Future<Color> showColorPickerDialog(BuildContext context, Color currentColor) async {
    Color pickerColor = currentColor;

    void changeColor(Color color) {
      pickerColor = color;
      Navigator.of(context).pop(pickerColor);
    }

    return showDialog<Color>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Wähle eine Farbe'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                BlockPicker(
                  pickerColor: currentColor,
                  onColorChanged: changeColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
