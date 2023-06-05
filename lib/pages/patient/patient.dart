import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapd722_patient_clinical_data_app/models/patient.dart';
import 'package:mapd722_patient_clinical_data_app/pages/patient/add_patient_widget.dart';
import 'package:mapd722_patient_clinical_data_app/pages/patient/detail_patient_widget.dart';
import 'package:mapd722_patient_clinical_data_app/pages/patient/edit_patient_widget.dart';
import 'package:mapd722_patient_clinical_data_app/services/api_service.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({Key? key}) : super(key: key);

  @override
  _PatientHomePageState createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage>
    with TickerProviderStateMixin {
  final ApiService api = ApiService();
  List<Patient> patientList = [];

  late TabController _controller;

  String _searchContent = "";

  // int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // print("initState called");
    loadList(false);

    _controller = TabController(length: 2, vsync: this);

    _controller.addListener(() {
      // print('Controller Listener');
      // setState(() {
      //   _selectedIndex = _controller.index;
      // });

      _controller.index == 0 ? loadList(false) : loadList(true);
      // print("Selected Index: ${_controller.index}");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (patientList == null) {
      // no use?
      patientList = <Patient>[];
    }
    return DefaultTabController(
      // tab view patients vs critical patients
      length: 2,
      child: Scaffold(
        // body: Container(
        //   padding: EdgeInsets.all(16),
        //   child: Column(
        //     children: [
        //       SizedBox(height: 15.0),
        //       TextField(
        //         style: TextStyle(color: Colors.black),
        //         decoration: InputDecoration(
        //           filled: true,
        //           // fillColor: Color.fromRGBO(241, 240, 240, 1),
        //           fillColor: Color.fromARGB(255, 217, 219, 220),
        //           border: OutlineInputBorder(
        //             borderRadius: BorderRadius.circular(8.0),
        //             borderSide: BorderSide.none,
        //           ),
        //           hintText: "John Doe",
        //           prefixIcon: Icon(Icons.search),
        //           prefixIconColor: Color.fromARGB(255, 81, 80, 80),
        //           suffixIcon: IconButton(
        //             icon: Icon(Icons.send),
        //             onPressed: () {
        //               // getPatientByFirstName();
        //             },
        //           ),
        //         ),
        //         onChanged: (value) {
        //           // setState(() {
        //           //   _searchContent = value;
        //           // });

        //           _searchContent = value;
        //           searchPatient(_searchContent);
        //         },
        //       ),
        //       Container(
        //           child: Align(
        //               alignment: Alignment.centerLeft,

        //               child: TabBar(
        //                   controller: _controller,
        //                   labelColor: Colors.black, //<-- selected text color
        //                   unselectedLabelColor:
        //                       Color.fromARGB(255, 202, 199, 199),
        //                   tabs: const [
        //                     Tab(
        //                       text: 'All',
        //                     ),
        //                     Tab(
        //                       text: 'Critical',
        //                     )
        //                   ]))),
        //       Container(
        //         padding: const EdgeInsets.only(left: 20),
        //         height: 400,
        //         width: double.maxFinite,
        //         child: TabBarView(
        //           controller: _controller,
        //           children: [
        //             Center(child: FutureBuilder(
        //               // have to modify this, otherwise it can't show critical
        //               // future: loadList(false),
        //               builder: (context, snapshot) {
        //                 return PatientListView(context, patientList);
        //                 //patientList--> snapshot.data
        //               },
        //             )),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        appBar: AppBar(
          leading: Icon(Icons.search),
          title: TextField(
            // controller: controller,
            decoration: InputDecoration(
                hintText: "please search by first name",
                focusColor: Color.fromARGB(255, 217, 219, 220)),
            onChanged: (value) {
              // _searchContent = value;
              setState(() {
                 _searchContent = value;
              });
              searchPatient(_searchContent);
            },
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            controller: _controller,
            tabs: const [
              Tab(
                text: 'All',
              ),
              Tab(
                text: 'Critical',
              ),
            ],
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.search),
          //     onPressed: () {
          //       showSearch(
          //           context: context, delegate: PatientSearchDelegate());
          //     },
          //   )
          // ]
        ),

        body: TabBarView(
          controller: _controller,
          children: [
            Center(child: FutureBuilder(
              // have to modify this, otherwise it can't show critical
              // future: loadList(false),

              builder: (context, snapshot) {
                return PatientListView(context, patientList);
                //patientList--> snapshot.data
              },
            )),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigateToAddScreen(context);
          },
          tooltip: 'Add',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

// get individual patient details from PatientList
  PatientListView(BuildContext context, List<Patient> patient) {
    return ListView.builder(
        itemCount: patient == null
            ? 0
            : patient.length, //length of certain patient's data
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: InkWell(
            onTap: () {
              _navigateToDetailScreen(context, patient[index]);
            },
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text("${patient[index].firstName}" +
                  "  " +
                  "${patient[index].lastName}"),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 20.0,
                  ),
                  onPressed: () {
                    _navigateToEditScreen(context, patient[index]);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 20.0,
                  ),
                  onPressed: () {
                    _deletePatient(context, patient[index]);
                  },
                ),
              ]),
            ),
          ));
        });
  }

  _deletePatient(BuildContext context, Patient patient) async {
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
                api.deletePatient(patient.id);
                Navigator.of(context).pop();
                Future.delayed(const Duration(milliseconds: 100), () {
                  // Do something
                  reloadList();
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

  Future loadList(onlyCritical) {
    patientList = [];
    Future<List<Patient>> futurePatient = api.getPatient(onlyCritical);
    futurePatient.then((patientList) {
      setState(() {
        this.patientList = patientList;
      });
    });
    // print(futurePatient);
    return futurePatient;

    // print(onlyCritical);
    // return api.getPatient(onlyCritical);
  }

  _navigateToDetailScreen(BuildContext context, Patient patient) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailWidget(patient)),
    ).then((value) {
      // print("Back from Detail on list screen");
      Future.delayed(const Duration(milliseconds: 100), () {
        // Do something
        reloadList();
      });
    });
  }

  _navigateToAddScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPatientWidget()),
    ).then((value) {
      // print("Back from Add on list screen");
      Future.delayed(const Duration(milliseconds: 100), () {
        // Do something
        reloadList();
      });
    });
  }

  _navigateToEditScreen(BuildContext context, Patient patient) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPatientWidget(patient)),
    ).then((value) {
      // print("Back from Edit on list screen");
      Future.delayed(const Duration(milliseconds: 100), () {
        // Do something
        reloadList();
      });
    });
  }

  reloadList() {
    // print('reloadList called');
    _controller.index == 0 ? loadList(false) : _controller.animateTo(0);
  }

  void searchPatient(String searchContent) {
    if (_searchContent == "") {
      loadList(false);
      // setState((() => this.patientList = patientList));
    } else {
      List<Patient> resultList = [];
      for (var patient in patientList) {
        if (patient.firstName
            .toLowerCase()
            .contains(_searchContent.toLowerCase())) {
          resultList.add(patient);
        }
      }
      setState((() => this.patientList = resultList));
    }
  }
}

// class PatientSearchDelegate extends SearchDelegate {
//   @override
//   List<Widget>? buildActions(BuildContext context) => [
//         IconButton(
//           icon: const Icon(Icons.clear),
//           onPressed: (() => {
//                 if (query.isEmpty) {close(context, null)} else {query = ''}
//               }),
//         )
//       ]; //  { throw UnimplementedError();}

//   @override
//   Widget? buildLeading(BuildContext context) => IconButton(
//       onPressed: () => {close(context, null)},
//       icon: const Icon(Icons.arrow_back));
//   //  { throw UnimplementedError();}

//   @override
//   Widget buildResults(BuildContext context) => Center(
//         child: Text(query, style: const TextStyle(fontSize: 12)),
//       );
//   // IconButton(onPressed: () {}, icon: const Icon(Icons.clear));
//   //  { throw UnimplementedError();}

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     throw UnimplementedError();
//   }
// }
