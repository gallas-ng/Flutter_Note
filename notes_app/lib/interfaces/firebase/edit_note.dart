import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/interfaces/firebase/list_note.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  const EditNoteScreen({required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final CollectionReference _notesRef =
      FirebaseFirestore.instance.collection('notes');
  TextEditingController _gradeController = TextEditingController();

  String _selectedTitle = '';

  @override
  void initState() {
    super.initState();
    _selectedTitle = widget.note.title;
    _gradeController.text = widget.note.grade.toString();
  }

  @override
  void dispose() {
    _gradeController.dispose();
    super.dispose();
  }

  void _updateNote() {
    String id = widget.note.id;
    double grade = double.parse(_gradeController.text);

    _notesRef.doc(id).update({
      'title': _selectedTitle,
      'grade': grade,
    }).then((value) {
      Navigator.pop(context);
    }).catchError((error) {
      print("Failed to update note: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier la note'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sélectionnez le titre :',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              value: _selectedTitle,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTitle = newValue!;
                });
              },
              items: ['Java', 'C++','Mojo','C#','Flutter','Php']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            Text(
              'Grade :',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: _gradeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _updateNote,
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
