import 'dart:developer';

import 'package:flutter/material.dart';
//import 'package:mapd722_patient_clinical_data_app/models/patient.dart';
import 'package:mapd722_patient_clinical_data_app/services/api_service.dart';
import 'package:validatorless/validatorless.dart';
import 'package:mapd722_patient_clinical_data_app/services/globals.dart';
import './patient.dart';
import 'dart:convert';

import '../../models/patient.dart';

enum Gender { male, female }

enum Status { positive, dead, recovered }

int id = 0; // start from patient number 1

class AddPatientWidget extends StatefulWidget {
  AddPatientWidget();

  @override
  _AddPatientWidgetState createState() => _AddPatientWidgetState();
}

class _AddPatientWidgetState extends State<AddPatientWidget> {
  _AddPatientWidgetState();

  final ApiService api = ApiService();
  final _addFormKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  String gender = 'male'; // value o radio button
  Gender _gender = Gender.male; //for raido button only
  final _addressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  submit() async {
    if (_addFormKey.currentState!.validate()) {
      _addFormKey.currentState!.save();
      id += 1;
      var res = await api.createPatient(Patient(
          id.toString(),
          _firstNameController.text,
          _lastNameController.text,
          gender.toString(),
          _ageController.text,
          _addressController.text,
          _mobileController.text,
          _emailController.text,
          "normal"));

      if (res) {
        Navigator.pop(context);
        // _PatientHomePageState.reloadList(); //need to find syntax
      }
      return id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Patient'),
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
                                  submit();
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
