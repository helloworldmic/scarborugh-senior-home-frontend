import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mapd722_patient_clinical_data_app/models/patient.dart';
import 'package:mapd722_patient_clinical_data_app/services/api_service.dart';
import 'package:validatorless/validatorless.dart';

enum Gender { male, female }

enum Status { positive, dead, recovered }

class EditPatientWidget extends StatefulWidget {
  EditPatientWidget(this.patient);

  Patient patient;
  @override
  _EditPatientWidgetState createState() => _EditPatientWidgetState();
}

class _EditPatientWidgetState extends State<EditPatientWidget> {
  _EditPatientWidgetState();

  final ApiService api = ApiService();
  String id = '';
  final _addFormKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  String gender = 'male';
  Gender _gender = Gender.male;
  final _addressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    id = widget.patient.id;
    log("id: $id");
    log("widget.patient.id: $widget.patient.id");
    _firstNameController.text = widget.patient.firstName;
    _lastNameController.text = widget.patient.lastName;
    _ageController.text = widget.patient.age.toString();
    gender = widget.patient.gender;
    if (widget.patient.gender == 'male') {
      _gender = Gender.male;
    } else {
      _gender = Gender.female;
    }
    _addressController.text = widget.patient.address;
    _mobileController.text = widget.patient.mobile;
    _emailController.text = widget.patient.email;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Patient'),
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
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _firstNameController,
                                decoration: const InputDecoration(
                                  labelText: 'First Name',
                                ),
                                validator: Validatorless.multiple([
                                  Validatorless.required(
                                      'First Name is required'),
                                  Validatorless.max(25,
                                      'First Name must be at most 25 characters'),
                                ]),
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _lastNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Last Name',
                                ),
                                validator: Validatorless.multiple([
                                  Validatorless.required(
                                      'Last Name is required'),
                                  Validatorless.max(25,
                                      'Last Name must be at most 25 characters'),
                                ]),
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _ageController,
                                decoration: const InputDecoration(
                                  labelText: 'Age',
                                ),
                                keyboardType: TextInputType.number,
                                validator: Validatorless.multiple([
                                  Validatorless.required('Age is required'),
                                  Validatorless.number('Age must be a number'),
                                ]),
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _addressController,
                                decoration: const InputDecoration(
                                  labelText: 'Address',
                                ),
                                validator: Validatorless.multiple([
                                  Validatorless.required('Address is required'),
                                  Validatorless.max(25,
                                      'Address must be at most 25 characters'),
                                ]),
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _mobileController,
                                decoration: const InputDecoration(
                                  labelText: 'Mobile',
                                ),
                                validator: Validatorless.multiple([
                                  Validatorless.required('Mobile is required'),
                                  Validatorless.number('Mobile is not valid'),
                                  Validatorless.min(10, 'Mobile is not valid'),
                                  Validatorless.max(10, 'Mobile is not valid'),
                                ]),
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                ),
                                validator: Validatorless.multiple([
                                  Validatorless.required('Email is required'),
                                  Validatorless.email('Email is not valid'),
                                ]),
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Text('Gender',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge)),
                            const SizedBox(width: 10),
                            Expanded(
                                flex: 4,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Row(children: [
                                      Radio(
                                        value: Gender.male,
                                        groupValue: _gender,
                                        onChanged: (value) {
                                          setState(() {
                                            _gender = value!;
                                            gender = 'male';
                                          });
                                        },
                                      ),
                                      const Text('Male'),
                                    ])),
                                    Expanded(
                                        child: Row(children: [
                                      Radio(
                                        value: Gender.female,
                                        groupValue: _gender,
                                        onChanged: (value) {
                                          setState(() {
                                            _gender = value!;
                                            gender = 'female';
                                          });
                                        },
                                      ),
                                      const Text('Female'),
                                    ])),
                                  ],
                                ))
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              ElevatedButton(
                                // splashColor: Colors.red,
                                onPressed: () {
                                  updatePatientInfo();
                                  Navigator.pop(context);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           const PatientHomePage()),
                                  // );
                                  //   }
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

  updatePatientInfo() async {
    if (_addFormKey.currentState!.validate()) {
      _addFormKey.currentState!.save();
      await api.updatePatient(
          id, //id = widget.patient.id; init
          Patient(
              id,
              _firstNameController.text,
              _lastNameController.text,
              gender,
              _ageController.text,
              _addressController.text,
              _mobileController.text,
              _emailController.text,
              widget.patient
                  .condition)); // can leave condition "", if we need 9 arg in Patient, but we don't hv to sent in api.updatePatient()
      // print(Patient(
      //     id,
      //     _firstNameController.text,
      //     _lastNameController.text,
      //     gender,
      //     _ageController.text,
      //     _addressController.text,
      //     _mobileController.text,
      //     _emailController.text,
      //     widget.patient.condition));
    }
  }
}
