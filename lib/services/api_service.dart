import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:mapd722_patient_clinical_data_app/models/patient.dart';
import 'package:mapd722_patient_clinical_data_app/models/patient_record.dart';
import 'package:mapd722_patient_clinical_data_app/services/globals.dart';

class ApiService {
  final String url =
      'http://10.0.2.2:3000'; // the localhost (or 127.0.0.1) on the (android) device is only accessible to the device itself.
      //https://medium.com/@podcoder/connecting-flutter-application-to-localhost-a1022df63130
      //https://stackoverflow.com/questions/5528850/how-do-you-connect-localhost-in-the-android-emulator
      //"http://localhost:3000";
  // https://patient-data-api.herokuapp.com/api
  final String patientPath = 'patient';
  final String recordPath = 'record';
  final String patientsPath = 'patients';
  final String recordsPath = 'patientRecords';

  List<PatientRecord> records = [];
  void showSnackBar(String message, bool success) {
    final SnackBar snackBar = SnackBar(
      content: SizedBox(
        height: 40,
        child: Column(
          children: [
            Text(success ? 'Success' : 'Error',
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold)),
            Text(message, style: const TextStyle(fontSize: 12.0)),
          ],
        ),
      ),
      backgroundColor: success ? Colors.green : Colors.red,
    );
    snackbarKey.currentState?.showSnackBar(snackBar);
  }

  Future<List<Patient>> getPatient(bool onlyCritical) async {
    try {
      List<Patient> patients = [];
      String u = onlyCritical
          ? "$url/criticalPatients?onlyCritical=true" //"$url/$patientsPath?onlyCritical=true"
          : "$url/$patientsPath";
      //?${DateTime.now()}";
      // print(Uri.parse(u));
      Response res = await get(Uri.parse(u));
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);

        for (var p in body) {
          Patient patient = Patient(
              p['_id'],
              p['firstName'],
              p['lastName'],
              p['gender'],
              p['age'],
              p['address'],
              p['mobile'],
              p['email'],
              p['condition']); //''
          patients.add(patient);
        }

        // Map<String, dynamic> data = body["data"];
        // List<dynamic> patientData = data["data"];
        // List<Patient> patient =
        //     patientData.map((dynamic item) => Patient.fromJson(item)).toList();
        // print(body.toString());
        return patients;
      } else {
        throw "Failed to load patient list";
      }
    } catch (e) {
      showSnackBar('Failed: Get Patient List', false);
      throw "Failed to load patient list";
    }
  }

  Future<bool> createPatient(Patient patient) async {
    try {
      Map data = {
        'patientID': patient.id, //key:value (key from backend schema)
        'firstName': patient.firstName,
        'lastName': patient.lastName,
        'gender': patient.gender,
        'age': patient.age,
        'address': patient.address,
        'mobile': patient.mobile,
        'email': patient.email,
        'condition': patient.condition,
      };
      final Response response = await post(
        Uri.parse('$url/$patientPath'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      // print(response.toString());
      if (response.statusCode == 201) {
        showSnackBar('Patient Addded succesfully!', true);
        return true;
      } else if (response.statusCode == 409) {
        Map<String, dynamic> body = jsonDecode(response.body);
        String message = body["message"] ?? "'Failed: Add Patient";
        showSnackBar(message, false);
        return false;
      } else {
        showSnackBar('Failed: Add Patient', false);
        return false;
      }
    } catch (e) {
      showSnackBar('Failed: Add Patient', false);
      return false;
    }
  }

  Future<Object> updatePatient(String patientId, Patient patient) async {
    // print("inside update patient info");
    try {
      Map data = {
        'patientID': patient.id, //may not need
        'firstName': patient.firstName,
        'lastName': patient.lastName,
        'gender': patient.gender,
        'age': patient.age,
        'address': patient.address,
        'mobile': patient.mobile,
        'email': patient.email,
        'condition': patient.condition
      };

      final Response response = await put(
        Uri.parse('$url/$patientPath/$patientId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      print(jsonEncode(data).toString());
      if (response.statusCode == 200) {
        showSnackBar('Patient Updated Succesfully!', true);
        return {"success": true};
      } else {
        showSnackBar('Failed: Update Patient', false);
        return {"success": false};
      }
    } catch (e) {
      showSnackBar('Failed: Update Patient', false);
      return {"success": false};
    }
  }

  Future<void> deletePatient(String patientId) async {
    try {
      Response res = await delete(Uri.parse('$url/$patientPath/$patientId'));

      if (res.statusCode == 200) {
        showSnackBar('Patient Deleted Successfully', true);
      } else {
        throw "Failed to delete a patient.";
      }
    } catch (e) {
      showSnackBar('Failed: Delete Patient', false);
      throw "Failed to delete a patient.";
    }
  }

  Future<List<PatientRecord>> getPatientRecords(
    String patientId,
  ) async {
    try {
      Response res = await get(Uri.parse('$url/$recordsPath/$patientId'));
//'$url/$patientPath/$patientId/$recordsPath?${DateTime.now()}'
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);

        for (var q in body) {
          //must be in right order of PatientRecord, should use auto input: type PatientRecord and let it show in what order you should input
          PatientRecord record = PatientRecord(
              q['patientID'],
              q['typeOfData'], //should add id
              q['dateOfRecord'],
              q['reading'],
              q['patientCondition']);
          records.add(record);
        }
        // List<dynamic> patientRecordData = body["data"]; // in db, should be like: res.body= {patientID:patientID,data:[] }
        // List<PatientRecord> patientRecord = patientRecordData
        //     .map((dynamic item) => PatientRecord.fromJson(item))
        //     .toList();
        return records;
      } else {
        throw "Failed to load patient record list";
      }
    } catch (e) {
      print(e.toString());
      showSnackBar('Failed: Get Patient Record List', false);
      throw "Failed to load patient record list";
    }
  }

  Future<Object> createPatientRecord(
      String patientId, PatientRecord patientRecord) async {
    try {
      Map data = {
        'patientID': patientRecord.id,
        'typeOfData': patientRecord.dataType,
        'reading': patientRecord.reading,
        'dateOfRecord': patientRecord.dateTime,
        'patientCondition': patientRecord.condition,
      };
      final Response response = await post(
        // Uri.parse('$url/$patientsPath/$patientId/$recordPath'),
        Uri.parse('$url/patientRecord/$patientId/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      // print("jsonEncode(data):  " + jsonEncode(data));
      if (response.statusCode == 201) {
        showSnackBar('Patient Record Added Succesfully!', true);
        return {"success": true};
      } else if (response.statusCode == 409) {
        Map<String, dynamic> body = jsonDecode(response.body);
        String message = body["message"] ?? "'Failed: Add Patient Record";
        showSnackBar(message, false);
        return {"success": false};
      } else {
        showSnackBar('Failed: Add Patient Record', false);
        return {"success": false};
      }
    } catch (e) {
      showSnackBar('Failed: Add Patient Record', false);
      return {"success": false};
    }
  }

  Future<Object> updatePatientRecord(
      String patientId, String recordId, PatientRecord patientRecord) async {
    try {
      Map data = {
        'patientID': patientRecord.id,
        'reading': patientRecord.reading,
        'dateOfRecord': patientRecord.dateTime, //date_time
        'typeOfData': patientRecord.dataType, //data_type
        'patientCondition': patientRecord.condition, //patient_condition
      };

      final Response response = await put(
        // Uri.parse('$url/$patientPath/$patientId/$recordPath/$recordId'),
        Uri.parse('$url/patientRecord/$recordId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      print(Uri.parse('$url/patientRecord/$recordId'));
      print("jsonEncode(data):  " + jsonEncode(data));
      if (response.statusCode == 200) {
        showSnackBar('Patient Record Updated Succesfully!', true);
        return {"success": true};
      } else {
        showSnackBar('Failed: Update Patient Record', false);
        return {"success": false};
      }
    } catch (e) {
      showSnackBar('Failed: Update Patient Record', false);
      return {"success": false};
    }
  }

  Future<void> deletePatientRecord(String patientId, String recordId) async {
    try {
      Response res = await delete(
          Uri.parse('$url/$patientPath/$patientId/$recordPath/$recordId'));

      if (res.statusCode == 200) {
        showSnackBar('Patient Record Deleted Successfully!', true);
      } else {
        throw "Failed to delete a patient.";
      }
    } catch (e) {
      showSnackBar('Failed: Delete Patient Record', false);
      throw "Failed to delete a patient.";
    }
  }
}
