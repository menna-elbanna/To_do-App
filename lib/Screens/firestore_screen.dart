import 'package:flutter/material.dart';
import 'package:todo_app/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {

  TextEditingController nameController = TextEditingController(),
      ageController = TextEditingController();
  FirestoreServices service = FirestoreServices();

  @override

  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              label: Text('Name'),
              border: OutlineInputBorder()
            ),
          ),
          TextFormField(
            controller: ageController,
            decoration: const InputDecoration(
                label: Text('Age'),
                border: OutlineInputBorder()
            ),
          ),
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton(onPressed: (){
                service.addUser(
                  {
                    'name': nameController.text,
                    'age': int.parse(ageController.text)
                  }
                );
              }, child: Text("Add User")
              ),
              ElevatedButton(onPressed: (){
                service.setUser('menna_ID', {
                  'name': nameController.text,
                  'age': int.parse(ageController.text)
                });
              }, child: Text("Set User")
              ),

              ElevatedButton(onPressed: (){
                service.updatePartial('menna_ID', {'name': nameController.text},);
              }, child: Text('Update Partial')),

              ElevatedButton(
                onPressed: (){
                  service.deleteUser('menna_ID');
                },
                child: Text("Delete User"),
              ),
                              ],
          ),
                        Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: service.streamUsers(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return CircularProgressIndicator();

                        final docs = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(docs[index]['name']),
                              subtitle: Text('age: ${docs[index]['age']}'),
                            );
                          },
                        );
                      },
                    ),
                  )
        ],
      ),
    );
  }
}