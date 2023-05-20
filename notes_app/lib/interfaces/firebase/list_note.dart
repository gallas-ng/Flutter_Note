import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MY_NOTE_Grp3/interfaces/firebase/add_note.dart';
import 'package:MY_NOTE_Grp3/interfaces/firebase/edit_note.dart';

import '../Note.dart';
import 'list_note_pub.dart';
class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}



class _NoteListScreenState extends State<NoteListScreen> {
  final CollectionReference _notesRef = FirebaseFirestore.instance.collection('notes2');
  String _userID = "";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    if(FirebaseAuth.instance.currentUser != null)
      _userID = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      extendBodyBehindAppBar: true,
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
      body: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage("images/cr.jpeg"),
          //   fit: BoxFit.cover,
          // ),
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
              isPublic: data['isPublic'],
              userID: data['userID'],
            );
          })
          .where((note) => note.isPublic == 'non' && note.userID == _userID)
          .toList();

          notes.forEach((song) {                
          print(song.userID );                 // This will not have an error, however it's verbose
          print(song.isPublic);                 // This will not have an error, however it's verbose
});

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
