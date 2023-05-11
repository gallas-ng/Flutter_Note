import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late double _grade;

  void _submitNote() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        var headers = {"Content-Type": "application/json"};
        var body = jsonEncode({'title': _title, 'content': _grade});

        var response = await http.post(
          Uri.parse('http://192.168.43.23:3000/notes/add'),
          headers: headers,
          body: body,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Note ajoutée')),
          );

          Navigator.pop(context);
          _fetchNotes();
          Navigator.pushReplacementNamed(context, '/');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  void _fetchNotes() async {
    final response =
        await http.get(Uri.parse('http://192.168.43.23:3000/notes'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        var notesList = jsonData;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une note'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Matière',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une matière';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Note (sur 20)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une note';
                  }
                  var grade = double.tryParse(value);
                  if (grade == null || grade < 0 || grade > 20) {
                    return 'Veuillez entrer une note valide (entre 0 et 20)';
                  }
                  return null;
                },
                onSaved: (value) {
                  _grade = double.parse(value!);
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitNote,
                child: Text('Ajouter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  textStyle: TextStyle(fontSize: 20),
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
