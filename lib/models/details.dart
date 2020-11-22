import 'package:flutter/material.dart';

enum Gender { male, female }

///Class containing details about the patient
class UserDetails with ChangeNotifier {
  DateTime dob;
  int age;
  Gender gender;
  String name;

  UserDetails({this.dob, this.age, this.gender, this.name});
}
