import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // add
  Future<DocumentReference> addUser(Map<String, dynamic> data) async {
    return await _db.collection('users').add(data); // auto id
  }

  Future<void> setUser(String id, Map<String, dynamic> data) async {
    await _db.collection('users').doc(id).set(data); // custom id
  }

  Future<void> updatePartial(String id, Map<String, dynamic> data) async {
    // Changed .set(data) to .update(data) to ensure it's a partial update
    await _db.collection('users').doc(id).set(data, SetOptions(merge:true));
  }

  Future<void> UpdateUser(String id, Map <String,dynamic> data) async{
    await _db.collection('users').doc(id).update(data);
  }

  Future<void> deleteUser(String id) async {
    await _db.collection('users').doc(id).delete();
  }

  Future<List<QueryDocumentSnapshot>> getUsers() async {
    final snapShot = await _db.collection('users').get();
    return snapShot.docs;
  }
  Future<DocumentSnapshot> getUser(String id) async {
    return await _db.collection('users').doc(id).get();
  }

  Stream<QuerySnapshot> streamUsers() {
    return _db.collection('users').snapshots();
  }

  // filter
  Future<List<QueryDocumentSnapshot>> queryUsers() async {
    final snapShot = await _db
        .collection('users')
        .where('age', isGreaterThan: 18)
        .get();
    return snapShot.docs;
  }
}