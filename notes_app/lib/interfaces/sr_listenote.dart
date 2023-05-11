import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotesListScreen extends StatefulWidget {
  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  late List<dynamic> _notesList = [];

  void _fetchNotes() async {
    final response = await http.get(Uri.parse('http://192.168.43.23:3000/notes'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        _notesList = jsonData;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${response.statusCode}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des notes'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _notesList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  height: 0,
                ),
                itemCount: _notesList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      height: 80,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _notesList[index]['title'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Note: ${_notesList[index]['content']}/20',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: Icon(Icons.auto_mode_rounded),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
