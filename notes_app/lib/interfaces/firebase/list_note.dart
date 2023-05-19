import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MY_NOTE_Grp3/interfaces/firebase/add_note.dart';
import 'package:MY_NOTE_Grp3/interfaces/firebase/edit_note.dart';

class Note {
  final String id;
  final String title;
  final double grade;

  Note({required this.id, required this.title, required this.grade});

  Map<String, dynamic> toMap() {
    return {'title': title, 'grade': grade.toDouble()};
  }

  String getAppreciation() {
    if (grade <= 5) {
      return 'MEDRIOCRE';
    } else if (grade <= 9) {
      return 'FAIBLE';
    } else if (grade <= 11) {
      return 'MOYEN';
    } else if (grade <= 14) {
      return 'PaASSABLE';
    } else if (grade <= 16) {
      return 'BIEN';
    } else if (grade <= 19) {
      return 'TRES BIEN';
    } else {
      return 'EXCELLENT';
    }
  }
}

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final CollectionReference _notesRef =
      FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Toutes les notes'),
        backgroundColor: Colors.amber,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/cr.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _notesRef.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        color: Colors.lightBlue,
                        child: ListTile(
                          title: Text(
                            notes[index].title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 23,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Note: ${notes[index].grade}/20',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              Divider(
                                // Ajout de la ligne horizontale
                                color: Colors.white,
                                thickness: 1.5,
                                height: 20,
                                indent: 0,
                                endIndent: 0,
                              ),
                              Text(
                                'appréciation: ${notes[index].getAppreciation()}',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  // decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              size: 25,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              // Supprimer la note
                              _notesRef.doc(notes[index].id).delete();
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditNoteScreen(note: notes[index]),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
        },
        child: Icon(Icons.auto_mode_rounded),
        backgroundColor: Colors.indigo,
        hoverColor: Colors.black54,
      ),
    );
  }
}
