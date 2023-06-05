import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapd722_patient_clinical_data_app/models/patient.dart';
import 'package:mapd722_patient_clinical_data_app/services/api_service.dart';

import '../../models/patient_record.dart';

enum Condition { critical, normal }

enum DataType {
  blood_pressure,
  respiratory_rate,
  blood_oxygen_level,
  heartbeat_rate
}

class AddPatientRecordWidget extends StatefulWidget {
  final Patient patient;
  AddPatientRecordWidget(this.patient);

  @override
  _AddPatientRecordWidgetState createState() => _AddPatientRecordWidgetState();
}

class _AddPatientRecordWidgetState extends State<AddPatientRecordWidget> {
  _AddPatientRecordWidgetState();

  final ApiService api = ApiService();
  final _addFormKey = GlobalKey<FormState>();
  final _readingController = TextEditingController();
  String dataType = 'blood_pressure';
  DataType _dataType = DataType.blood_pressure;
  String condition = 'normal';
  Condition _condition = Condition.normal;
  Map readingUnits = {
    'blood_pressure': 'mmHg',
    'respiratory_rate': '/min',
    'blood_oxygen_level': '%',
    'heartbeat_rate': '/min',
  };

  Map readingHint = {
    'blood_pressure': 'X/Y',
    'respiratory_rate': 'X',
    'blood_oxygen_level': 'X',
    'heartbeat_rate': 'X',
  };

  DateTime dateTime = DateTime.now();
  void submitRecord() async {
    if (_addFormKey.currentState!.validate()) {
      _addFormKey.currentState!.save();
      var res = await api.createPatientRecord(
          widget.patient.id,
          PatientRecord(widget.patient.id.toString(), dataType,
              dateTime.toUtc().toString(), _readingController.text, condition));
      updatePatientCondition();
      // print("res in submit record: ${res}");
      if (res == true) {
        Navigator.pop(context);
      }
    }
  }

// only update patient's condition as of now
  void updatePatientCondition() async {
    var updatedCondition = await api.updatePatient(
        widget.patient.id,
        Patient(
            widget.patient.id,
            widget.patient.firstName,
            widget.patient.lastName,
            widget.patient.gender,
            widget.patient.age,
            widget.patient.address,
            widget.patient.mobile,
            widget.patient.email,
            condition));

    // print(updatedCondition);
  }

  // This function displays a CupertinoModalPopup with a reasonable fixed height
  // which hosts CupertinoDatePicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system
              // navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Patient Record'),
      ),
      body: Form(
        key: _addFormKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Card(
                child: Container(
                    padding: const EdgeInsets.all(10.0),
                    width: 440,
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 15, 0,
                                    0), //apply padding to all four sides
                                child: Text('Type Of Data',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                flex: 3,
                                child: Column(
                                  children: <Widget>[
                                    Row(children: [
                                      Radio(
                                        value: DataType.blood_pressure,
                                        groupValue: _dataType,
                                        onChanged: (value) {
                                          setState(() {
                                            _dataType = value!;
                                            dataType = 'blood_pressure';
                                          });
                                        },
                                      ),
                                      const Text('Blood Pressure'),
                                    ]),
                                    Row(children: [
                                      Radio(
                                        value: DataType.respiratory_rate,
                                        groupValue: _dataType,
                                        onChanged: (value) {
                                          setState(() {
                                            _dataType = value!;
                                            dataType = 'respiratory_rate';
                                          });
                                        },
                                      ),
                                      const Text('Respiratory Rate'),
                                    ]),
                                    Row(children: [
                                      Radio(
                                        value: DataType.blood_oxygen_level,
                                        groupValue: _dataType,
                                        onChanged: (value) {
                                          setState(() {
                                            _dataType = value!;
                                            dataType = 'blood_oxygen_level';
                                          });
                                        },
                                      ),
                                      const Text('Blood Oxygen Level'),
                                    ]),
                                    Row(children: [
                                      Radio(
                                        value: DataType.heartbeat_rate,
                                        groupValue: _dataType,
                                        onChanged: (value) {
                                          setState(() {
                                            _dataType = value!;
                                            dataType = 'heartbeat_rate';
                                          });
                                        },
                                      ),
                                      const Text('Heartbeat Rate'),
                                    ]),
                                  ],
                                ))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Expanded(
                                flex: 1,
                                child: Text('Reading',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold))),
                            const SizedBox(width: 10),
                            Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 0,
                                      0), //apply padding to all four sides
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: TextFormField(
                                        controller: _readingController,
                                        decoration: const InputDecoration(
                                            hintText: 'x'),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter reading';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {},
                                      )),
                                      Text("${readingUnits[dataType]}")
                                    ],
                                  ),
                                ))
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            const Expanded(
                                flex: 1,
                                child: Text('Date',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold))),
                            const SizedBox(width: 10),
                            Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 0,
                                      0), //apply padding to all four sides
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CupertinoButton.filled(
                                        alignment: Alignment.centerLeft,
                                        // Display a CupertinoDatePicker in dateTime picker mode.
                                        onPressed: () => _showDialog(
                                          CupertinoDatePicker(
                                            initialDateTime: dateTime,
                                            use24hFormat: true,
                                            // This is called when the user changes the dateTime.
                                            onDateTimeChanged:
                                                (DateTime newDateTime) {
                                              setState(
                                                  () => dateTime = newDateTime);
                                            },
                                          ),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 0, 0),
                                        child: Row(
                                          children: [
                                            const Align(
                                                alignment: Alignment.centerLeft,
                                                child:
                                                    Icon(Icons.calendar_month)),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10.0),
                                                child: Text(
                                                  '${dateTime.month}/${dateTime.day}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}',
                                                  style: const TextStyle(
                                                      fontSize: 20.0),
                                                ))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Expanded(
                                flex: 1,
                                child: Text('How\'s Patient Condition?',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold))),
                            const SizedBox(width: 10),
                            Expanded(
                                flex: 3,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Row(children: [
                                      Radio(
                                        value: Condition.normal,
                                        groupValue: _condition,
                                        onChanged: (value) {
                                          setState(() {
                                            _condition = value!;
                                            condition = 'normal';
                                          });
                                        },
                                      ),
                                      const Text('Normal'),
                                    ])),
                                    Expanded(
                                        child: Row(children: [
                                      Radio(
                                        value: Condition.critical,
                                        groupValue: _condition,
                                        onChanged: (value) {
                                          setState(() {
                                            _condition = value!;
                                            condition = 'critical';
                                          });
                                        },
                                      ),
                                      const Text('Critical'),
                                    ]))
                                  ],
                                ))
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  submitRecord();
                                },
                                child: const Text('Save',
                                    style: TextStyle(color: Colors.white)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ))),
          ),
        ),
      ),
    );
  }
}
