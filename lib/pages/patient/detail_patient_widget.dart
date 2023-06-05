import 'package:flutter/material.dart';
import 'package:mapd722_patient_clinical_data_app/models/patient.dart';
import 'package:mapd722_patient_clinical_data_app/pages/patient_record/patient_record.dart';
import 'package:mapd722_patient_clinical_data_app/services/api_service.dart';

class DetailWidget extends StatefulWidget {
  final Patient patient;
  DetailWidget(this.patient);

  @override
  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  _DetailWidgetState();

  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Card(
              child: Container(
                  padding: const EdgeInsets.all(20.0),
                  width: 440,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text('First Name',
                                  style:
                                      Theme.of(context).textTheme.titleLarge)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(widget.patient.firstName,
                                  style: Theme.of(context).textTheme.subtitle1))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text('Last Name',
                                  style:
                                      Theme.of(context).textTheme.titleLarge)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(widget.patient.lastName,
                                  style: Theme.of(context).textTheme.subtitle1))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text('Age',
                                  style:
                                      Theme.of(context).textTheme.titleLarge)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(widget.patient.age.toString(),
                                  style: Theme.of(context).textTheme.subtitle1))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text('Gender',
                                  style:
                                      Theme.of(context).textTheme.titleLarge)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(widget.patient.gender,
                                  style: Theme.of(context).textTheme.subtitle1))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text('Address',
                                  style:
                                      Theme.of(context).textTheme.titleLarge)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(widget.patient.address,
                                  style: Theme.of(context).textTheme.subtitle1))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text('Email',
                                  style:
                                      Theme.of(context).textTheme.titleLarge)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(widget.patient.email,
                                  style: Theme.of(context).textTheme.subtitle1))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text('Mobile',
                                  style:
                                      Theme.of(context).textTheme.titleLarge)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(widget.patient.mobile,
                                  style: Theme.of(context).textTheme.subtitle1))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Column(
                          children: <Widget>[
                            ElevatedButton.icon(
                              icon: const Icon(Icons.preview, size: 28),
                              label: const Text('View Patient Records'),
                              onPressed: () {
                                _navigateToPatientRecordScreen(
                                    context, widget.patient);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))),
        ),
      ),
    );
  }

  _navigateToPatientRecordScreen(BuildContext context, Patient patient) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PatientRecordHomePage(patient)),
    );
  }
}
