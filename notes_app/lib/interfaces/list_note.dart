import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/interfaces/add_note.dart';

class Note {
  // Attribut 
  final String id;
  final String title;
  final double grade;

  Note({required this.id, required this.title, required this.grade});

  // recuperer les attributs
  Map<String, dynamic> toMap() {
    return {'title': title, 'grade': grade.toDouble()};
  }
}

// Interface de la liste des notes
class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

//Implementation de l'etat
class _NoteListScreenState extends State<NoteListScreen> {
  // Instaciation d'une table 'notes' dans firestore 
  final CollectionReference _notesRef =
      FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toutes les notes'),
        backgroundColor: Colors.amber,
        centerTitle: true,
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
            );
          }).toList();

          return notes.length == 0
              ? Center(child: Text('Aucune note trouvée'))
              : ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(
                          notes[index].title,
                          style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          'Note: ${notes[index].grade}/20',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
        },
        child: Icon(Icons.auto_mode_rounded),
        backgroundColor: Colors.amber,
        hoverColor: Colors.black54,
      ),
    );
  }
}
