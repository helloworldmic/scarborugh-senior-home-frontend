class Patient {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final String age;
  final String address;
  final String mobile;
  final String email;
  final String? condition;

  Patient(this.id, this.firstName, this.lastName, this.gender, this.age,
      this.address, this.mobile, this.email, this.condition); //, this.condition

//It includes a factory constructor that creates a Patient from JSON.
  // factory Patient.fromJson(Map<String, dynamic> json) {
  //   return Patient(
  //     id: json['_id'] as String,
  //     firstName: json['first_name'] as String,
  //     lastName: json['last_name'] as String,
  //     gender: json['gender'] as String,
  //     age: json['age'] as int,
  //     address: json['address'] as String,
  //     mobile: json['mobile'] as String,
  //     email: json['email'] as String,
  //     condition: json['condition'] as String?,
  //   );
// }

  // @override
  // String toString() {
  //   return '{id: $id, firstName: $firstName, lastName: $lastName, gender: $gender, age: $age, address: $address, mobile: $mobile, email: $email}';
  // }
}
