class PatientRecord {
  final String id;
  // patient's id, not record's id (i made a mistake here, should be record's od on backend)
  final String dataType;
  final String dateTime;
  final String reading;
  final String? condition;

  PatientRecord(
      this.id, this.dataType, this.dateTime, this.reading, this.condition);

  // PatientRecord(
  //   {this.id = "",
  //   this.dataType = "",
  //   this.dateTime = "",
  //   this.reading = "",
  //   this.condition = ""});

  // factory PatientRecord.fromJson(Map<String, dynamic> json) {
  //   return PatientRecord(
  //     id: json['_id'] as String,
  //     reading: json['reading']['value'] as String,
  //     dateTime: json['date_time'] as String,
  //     dataType: json['data_type'] as String,
  //   );
  // }

  // @override
  // String toString() {
  //   return 'Trans{id: $id, type: $dataType, reading: $reading}';
  // }
}
