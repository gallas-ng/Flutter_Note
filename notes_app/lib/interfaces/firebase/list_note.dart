import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/interfaces/firebase/add_note.dart';
import 'package:notes_app/interfaces/firebase/edit_note.dart';
import '../Note.dart';
import 'list_note_pub.dart';
class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final CollectionReference _notesRef = FirebaseFirestore.instance.collection('notes2');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes notes'),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            tooltip: "Notes publiques",
            onPressed: () {
              // Redirection vers une autre page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotesListPub()),
              );
            },
          ),
          IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            _showModalDialog(context); // Afficher le dialogue modal
          },),
        ],
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
          .where((note) => note.isPublic == 'non')
          .toList();

          return notes.length == 0
              ? Center(child: Text('Aucune note trouvée'))
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
                        subtitle: Text(
                          'Note: ${notes[index].grade}/20',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                            fontSize: 18,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
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

  
  void _showModalDialog(BuildContext context) async {
    int _nbDonneesPub = await getTotalCountFilteredByValue("notes2", "isPublic", "non");
    int _nbDonneesPriv = await getTotalCountFilteredByValue("notes2", "isPublic", "oui");
    double moyennePub = (_nbDonneesPub  / (_nbDonneesPub + _nbDonneesPriv)) * 100;
    double moyennePriv = (_nbDonneesPriv  / (_nbDonneesPub + _nbDonneesPriv)) * 100;
    List<String> moyennes = ['Nombre de données publiques', 'Nombre de données privées', 'Moyenne publique', 'Moyenne privée'];
    List<dynamic> valeurs = [_nbDonneesPub, _nbDonneesPriv, moyennePub, moyennePriv];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Statistiques'),
          content: SizedBox(
          width: double.maxFinite, // Ajuster la largeur du contenu
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                moyennes[index],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Valeur: ${valeurs[index]}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
              );
              },
          ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer le dialogue
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  Future<int> getTotalCountFilteredByValue(String collectionName, String fieldName, dynamic filterValue) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(collectionName).where(fieldName, isEqualTo: filterValue).get();
    int totalCount = snapshot.docs.length;
    return totalCount;
  }
}
