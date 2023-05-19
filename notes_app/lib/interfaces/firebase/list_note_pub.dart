import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Note.dart';
import 'list_note.dart';

class NotesListPub extends StatefulWidget {
  const NotesListPub({super.key});

  @override
  State<NotesListPub> createState() => _NotesListPubState();
}

class _NotesListPubState extends State<NotesListPub> {
  final CollectionReference _notesRef = FirebaseFirestore.instance.collection('notes2');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes publiques'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _notesRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<Note> notes = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Note(
              id: doc.id,
              title: data['title'],
              grade: data['grade'],
              isPublic: data['isPublic'],
              userID: data['userID'],
            );
          })
          .where((note) => note.isPublic == 'oui')
          .toList();

          return notes.length == 0
          ? Center(child: Text('Aucune note trouvée !'))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      notes[index].title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Note: ${notes[index].grade}/20',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                            fontSize: 18,
                          ),
                        ),
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(notes[index].userID)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) 
                              return CircularProgressIndicator();
                            if (snapshot.hasError) 
                              return Text('Erreur de chargement des données');
                            if (!snapshot.hasData) 
                              return Text('Utilisateur non trouvé');
                            
                            String userName =
                                snapshot.data!.get('prenom') + " " + snapshot.data!.get('nom') as String? ?? '';

                            return Text(
                              'Utilisateur: $userName',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
        },
      ),
    );
  }
}

        