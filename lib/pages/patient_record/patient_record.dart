import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapd722_patient_clinical_data_app/models/patient.dart';
import 'package:mapd722_patient_clinical_data_app/models/patient_record.dart';
import 'package:mapd722_patient_clinical_data_app/pages/patient_record/add_patient_record_widget.dart';
import 'package:mapd722_patient_clinical_data_app/pages/patient_record/edit_patient_record_widget.dart';
import 'package:mapd722_patient_clinical_data_app/services/api_service.dart';

class PatientRecordHomePage extends StatefulWidget {
  final Patient patient;
  const PatientRecordHomePage(this.patient, {super.key});
  @override
  _PatientRecordHomePageState createState() => _PatientRecordHomePageState();
}

class _PatientRecordHomePageState extends State<PatientRecordHomePage> {
  final ApiService api = ApiService();
  // List<PatientRecord> patientRecordList = [];  // should not use, bcoz api.getPatientRecords return a list already, already use snapshot.data instead
  Map dataTypeOption = {
    'blood_pressure': 'Blood Pressure',
    'respiratory_rate': 'Respiratory Rate',
    'blood_oxygen_level': 'Blood Oxygen Level',
    'heartbeat_rate': 'Heartbeat Rate',
  };
  Map<String, SizedBox> dataTypeImage = {
    'blood_pressure': const SizedBox(
        height: 50.0,
        width: 50.0,
        child: ColoredBox(
          color: Color.fromARGB(255, 183, 181, 181),
          child: Image(image: AssetImage('assets/images/blood_pressure.png')),
        )),
    'respiratory_rate': const SizedBox(
        height: 50.0,
        width: 50.0,
        child: ColoredBox(
          color: Color.fromARGB(255, 183, 181, 181),
          child: Image(image: AssetImage('assets/images/respiratory_rate.png')),
        )),
    'blood_oxygen_level': const SizedBox(
        height: 50.0,
        width: 50.0,
        child: ColoredBox(
          color: Color.fromARGB(255, 183, 181, 181),
          child:
              Image(image: AssetImage('assets/images/blood_oxygen_level.png')),
        )),
    'heartbeat_rate': const SizedBox(
        height: 50.0,
        width: 50.0,
        child: ColoredBox(
          color: Color.fromARGB(255, 183, 181, 181),
          child: Image(image: AssetImage('assets/images/heartbeat_rate.png')),
        ))
  };

  Map readingUnits = {
    'blood_pressure': 'mmHg',
    'respiratory_rate': '/min',
    'blood_oxygen_level': '%',
    'heartbeat_rate': '/min',
  };

  @override
  void initState() {
    super.initState();
    //print("widget.patient.id == patient.id " + widget.patient.id);
    // loadList(); // should not here, build has one, otherwise the list will double
  }

  @override
  Widget build(BuildContext context) {
    // print('----------build called---------');
    // loadList();
    // patientRecordList ??= <PatientRecord>[]; // commented out by me
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Patient Record List"),
      ),
      body: Center(
          child: FutureBuilder(
        future: loadList(),
        builder: (context, snapshot) {
          return // RecordsListView(context, snapshot.data);snapshot.data
              snapshot.data.length > 0
                  ? ListView.builder(
                      itemCount:
                          snapshot.data == null ? 0 : snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            child: InkWell(
                          onTap: () {},
                          child: ListTile(
                            leading:
                                dataTypeImage[snapshot.data[index].dataType],
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${dataTypeOption[snapshot.data[index].dataType]}",
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                Text(
                                    "${snapshot.data[index].reading} ${readingUnits[snapshot.data[index].dataType]} ",
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                    )),
                                const SizedBox(height: 5),
                                Text(
                                    // DateFormat.yMEd().add_jm().format(
                                    //     DateTime.parse(
                                    //             snapshot.data[index].dateTime)
                                    //         .toLocal())
                                    snapshot.data[index].dateTime,
                                    style: const TextStyle(
                                      fontSize: 10.0,
                                    ))
                              ],
                            ),
                            trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 20.0,
                                    ),
                                    onPressed: () {
                                      _navigateToEditScreen(
                                          context, snapshot.data[index]);
                                      // selectedRecord = snapshot.data[index].id;
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 20.0,
                                    ),
                                    onPressed: () {
                                      _deletePatientRecord(
                                          context,
                                          widget.patient.id,
                                          snapshot.data[index].id);
                                    },
                                  ),
                                ]),
                          ),
                        ));
                      })
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.warning,
                            size: 100.0,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text(
                            "No data found, tap plus button to add!",
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddScreen(context);
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  RecordsListView(BuildContext context, List<PatientRecord> records) {}

  // Future loadList() {
  //   Future<List<PatientRecord>> futurePatientRecords =
  //       api.getPatientRecords(widget.patient.id);
  //   futurePatientRecords.then((patientRecordList) {
  //     setState(() {
  //       this.patientRecordList = patientRecordList;
  //     });
  //   });
  //   return futurePatientRecords;
  // }

  Future loadList() {
    return api.getPatientRecords(widget.patient.id);
  }

  _navigateToAddScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddPatientRecordWidget(widget.patient)),
    ).then((value) {
      // print("Back from Add Record on list screen");
      Future.delayed(const Duration(milliseconds: 100), () {
        // Do something
        loadList();
      });
    });
  }

  _navigateToEditScreen(
      BuildContext context, PatientRecord patientRecord) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              EditPatientRecordWidget(widget.patient, patientRecord),
        )).then((value) {
      // print("Back from Edit Record on list screen");
      Future.delayed(const Duration(milliseconds: 100), () {
        // Do something
        loadList();
      });
    });
  }

  _deletePatientRecord(
      BuildContext context, String patientId, String recordId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure want delete this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                api.deletePatientRecord(patientId, recordId);
                Navigator.of(context).pop();
                Future.delayed(const Duration(milliseconds: 100), () {
                  // Do something
                  loadList();
                });
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
