import 'package:flutter/material.dart';
import 'package:t7coach/models/user_data.dart';

class UserChip extends StatefulWidget {
  final UserData userData;
  Color circleColor;
  String labelText;
  String tooltipText;

  UserChip({this.userData}) {
    circleColor = this.userData.accountColor == null ? Colors.amber : Color(this.userData.accountColor);
    labelText = this.userData.getFirstOrLastname();
    tooltipText = this.userData.getFullName();
  }

  @override
  _UserChipState createState() => _UserChipState();
}

class _UserChipState extends State<UserChip> {
  @override
  Widget build(BuildContext context) {
    return ActionChip(
        onPressed: () {},
        tooltip: widget.tooltipText,
        elevation: 2,
        avatar: CircleAvatar(
          backgroundColor: widget.circleColor,
          child: Text(widget.userData.initials),
        ),
        label: Text(widget.labelText, style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.black12);
  }
}
