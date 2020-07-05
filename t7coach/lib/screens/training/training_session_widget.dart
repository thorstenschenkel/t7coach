import 'package:flutter/material.dart';

abstract class TrainingSessionWidget {
  List<Widget> getFloatingActionButtonSubMenu() {
    return [];
  }

  void createAddBottomSheet(BuildContext context, Widget form) {
    showModalBottomSheet(
        isScrollControlled: false,
        enableDrag: true,
        isDismissible: true,
        context: context,
        builder: (context) {
          return Container(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), child: form);
        });
  }
}
