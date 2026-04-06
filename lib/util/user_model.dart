import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String name;
  final int age;

  UserModel({
    this.id,
    required this.name,
    required this.age
  });

  // from firestore

  factory UserModel.fromFireStore(DocumentSnapshot<Map<String,dynamic>> doc){
    final data = doc.data()!;
    return UserModel(name: data['name'], age: data['age']);
  }

  Map<String,dynamic> toFireStore(){
    return {
      'name': name,
      'age' : age
    };
  }

}
