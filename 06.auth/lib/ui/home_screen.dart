import 'package:auth/ui/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              GoogleSignIn().signOut();
              FirebaseAuth.instance
                  .signOut()
                  .then((value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                      (route) => false));
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('tasks').orderBy('timestamp').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                final titleEdc =
                    TextEditingController(text: data['title'].toString());
                final noteEdc =
                    TextEditingController(text: data['note'].toString());
                return SizedBox(
                  height: 170.0,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(data['title'],
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.0)),
                              ),
                              GestureDetector(
                                  onTap: () {},
                                  child: PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextFormField(
                                                        controller: titleEdc,
                                                      ),
                                                      const SizedBox(
                                                          height: 10.0),
                                                      SizedBox(
                                                          height: 300,
                                                          child: TextFormField(
                                                            controller: noteEdc,
                                                            maxLines:
                                                                null, // Set this
                                                            expands:
                                                                true, // and this
                                                            keyboardType:
                                                                TextInputType
                                                                    .multiline,
                                                          )),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              if (_formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                try {
                                                                  await _firestore
                                                                      .collection(
                                                                          'tasks')
                                                                      .doc(document
                                                                          .id)
                                                                      .update({
                                                                    'title':
                                                                        titleEdc
                                                                            .text,
                                                                    'note':
                                                                        noteEdc
                                                                            .text,
                                                                    'timestamp':
                                                                        FieldValue
                                                                            .serverTimestamp(),
                                                                  });
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text('Note berhasil diperbarui')),
                                                                  );
                                                                  Navigator.pop(
                                                                      context);
                                                                } catch (e) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text('$e')),
                                                                  );
                                                                }
                                                              }
                                                            },
                                                            child: const Text(
                                                                'Save'),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      } else if (value == 'delete') {
                                        String documentId = document.id;
                                        _firestore
                                            .collection('tasks')
                                            .doc(documentId)
                                            .delete();
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      const PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Text('Hapus'),
                                      ),
                                    ],
                                    child: Icon(Icons.more_vert_outlined),
                                  ))
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Text(data['note'],
                              textAlign: TextAlign.justify,
                              maxLines: 5,
                              style: const TextStyle(fontSize: 17.0)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                            controller: titleController,
                            decoration:
                                const InputDecoration(hintText: 'Title')),
                        const SizedBox(height: 10.0),
                        SizedBox(
                            height: 300,
                            child: TextFormField(
                                controller: noteController,
                                maxLines: null, // Set this
                                expands: true, // and this
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                    hintText: 'Write a note', filled: true))),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    DocumentReference docRef = await _firestore
                                        .collection('tasks')
                                        .add({
                                      'title': titleController.text,
                                      'note': noteController.text,
                                      'timestamp': FieldValue.serverTimestamp(),
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Note ditambahkan')),
                                    );
                                    Navigator.pop(context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('$e')),
                                    );
                                  }
                                }
                              },
                              child: const Text('Save'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
