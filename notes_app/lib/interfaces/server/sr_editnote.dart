import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditNoteScreen extends StatefulWidget {
  final dynamic note;
  final Function onUpdate;

  const EditNoteScreen({required this.note, required this.onUpdate});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _contentController;
  String _selectedTitle = '';
  double _content = 0.0;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.note['content'].toString());
    _selectedTitle = widget.note['title'].toString();
    _content = double.tryParse(widget.note['content'].toString()) ?? 0.0;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _updateNote() async {
    final Map<String, dynamic> updatedNote = {
      'title': _selectedTitle,
      'content': _content,
    };

    final response = await http.put(
      Uri.parse('http://192.168.43.23:3000/notes/${widget.note['id']}'),
      body: json.encode(updatedNote),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note mise à jour avec succès')),
      );
      widget.onUpdate();
      Navigator.pop(context);
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
        title: Text('Modifier la note'),
        backgroundColor: Colors.amber,
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
              items: ['C++', 'Java', 'flutter', 'C#','Mojo','Php', 'Go']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            Text(
              'Contenu :',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: _contentController,
              keyboardType: TextInputType.numberWithOptions(decimal: true), // Set a decimal keyboard type
              onChanged: (value) {
                setState(() {
                  _content = double.tryParse(value) ?? 0.0;
                });
              },
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
