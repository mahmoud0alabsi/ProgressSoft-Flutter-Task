import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  String uid;
  String fullName;
  String mobileNumber;
  int age;
  String gender;
  String password;

  CustomUser.emptyObject({
    this.uid = '',
    this.fullName = '',
    this.mobileNumber = '',
    this.age = 0,
    this.gender = '',
    this.password = '',
  });

  CustomUser({
    required this.uid,
    required this.fullName,
    required this.mobileNumber,
    required this.age,
    required this.gender,
    required this.password,
  });

  static CustomUser fromDocument(DocumentSnapshot document, String uid) {
    return CustomUser(
      uid: uid,
      fullName: document.get('fullName'),
      mobileNumber: document.get('mobileNumber'),
      age: document.get('age'),
      gender: document.get('gender'),
      password: document.get('password'),
    );
  }
}
