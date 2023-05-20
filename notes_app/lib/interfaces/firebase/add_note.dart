import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late int _grade;
  List<String> _titleOptions = ['C++', 'Java', 'Flutter', 'C#','Mojo','Php'];
  bool _checkBoxValue = false;
  String _radioValue = "oui";
  String _userID = "";
  void _submitNote() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if(FirebaseAuth.instance.currentUser != null)
        _userID = FirebaseAuth.instance.currentUser!.uid;
    
      try {
        await FirebaseFirestore.instance.collection('notes2').add({
          'title': _title,
          'grade': _grade,
          'isPublic': _radioValue,
          'userID': _userID
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Note ajoutée')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Ajouter une note'),
        backgroundColor: Colors.amber,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 19.0),
              Text(
                'Titre de la note',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 9.0),
              DropdownButtonFormField<String>(
                items: _titleOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner un titre';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _title = value!;
                  });
                },
              ),
              SizedBox(height: 19.0),
              Text(
                'Note',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 9.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Entrez la note (0-20)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une note';
                  }
                  final n = int.tryParse(value);
                  if (n == null || n < 0 || n > 20) {
                    return 'Veuillez entrer une note valide entre 0 et 20';
                  }
                  return null;
                },
                onSaved: (value) {
                  _grade = int.parse(value!);
                },
              ),
              SizedBox(height: 27.0),
               RadioListTile<String>(
                title: Text('Public'),
                value: 'oui',
                groupValue: _radioValue,
                onChanged: (String? value) {
                  setState(() {
                    _radioValue = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('Privé'),
                value: 'non',
                groupValue: _radioValue,
                onChanged: (String? value) {
                  setState(() {
                    _radioValue = value!;
                  });
                },
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _submitNote,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 20),
                    backgroundColor: Colors.amber,
                  ),
                  child: Text('Ajouter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
