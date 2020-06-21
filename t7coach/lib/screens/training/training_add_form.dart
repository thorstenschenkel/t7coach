import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:t7coach/models/training_types.dart';
import 'package:t7coach/shared/input_constants.dart';
import 'package:t7coach/shared/widgets/error_box_widget.dart';

class TrainingAddForm extends StatefulWidget {
  @override
  _TrainingAddFormState createState() => _TrainingAddFormState();
}

class _TrainingAddFormState extends State<TrainingAddForm> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();
  TextEditingController _dateController = new TextEditingController(text: ' ');
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _visibilityError = false;
  String error = '';
  String _dateString;

  Widget buildErrorBox() {
    return Visibility(visible: _visibilityError, child: ErrorBoxWidget(error));
  }

  _save() {
    // TODO
  }

  List<DropdownMenuItem> _createTraingTypeItems() {
    List<DropdownMenuItem> items = [];
    TrainingTypeMap.forEach((type, name) {
      DropdownMenuItem item = DropdownMenuItem(value: type, child: Text(name));
      items.add(item);
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    _dateController.text = _dateString;

    return Scaffold(
      appBar: AppBar(title: Text('Neue Trainingseinheit'), elevation: 0, actions: [
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            _save();
          },
        ),
      ]),
      body: LoadingOverlay(
          isLoading: _isLoading,
          opacity: 0.75,
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.secondary),
          ),
          child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            buildErrorBox(),
                          ],
                        ),
                      ),
                      Container(
                        width: 175,
                        child: TextFormField(
                          controller: _dateController,
                          decoration:
                              textInputDecoration.copyWith(labelText: 'Datum', suffixIcon: Icon(Icons.calendar_today)),
                          readOnly: true,
                          onTap: () async {
                            // TODO
                            // - DatePickerEntryMode.input
                            // - Title: Select Date
                            DateTime pickedDate = await showDatePicker(
                                context: context,
                                locale: Locale("de", "DE"),
                                fieldLabelText: 'Datum',
                                confirmText: 'OK',
                                cancelText: 'Abbrechen',
                                initialDatePickerMode: DatePickerMode.day,
                                initialEntryMode: DatePickerEntryMode.calendar,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100));
                            setState(() {
                              _dateString = DateFormat('dd.MM.yyyy').format(pickedDate);
                              print(_dateString);
                            });
                          },
                          validator: (val) {
                            return val == null ? 'Bitte wähle ein Datum aus.' : null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Visibility(
                          visible: true,
                          child: Column(
                            children: <Widget>[
                              Text('TODO Level'),
                              SizedBox(height: 10),
                            ],
                          )),
                      DropdownButtonFormField(
                          decoration: textInputDecoration.copyWith(labelText: 'Trainingsart'),
                          items: _createTraingTypeItems(),
                          onChanged: (val) {
                            setState(() {
                              // _groupName = val;
                            });
                          },
                          validator: (val) {
                            return val == null ? 'Bitte wähle eine Trainingsart aus.' : null;
                          }),
                    ])),
              ))),
    );
  }
}
