import 'package:flutter/material.dart';
import 'package:MY_NOTE_Grp3/interfaces/server/sr_addnote.dart';
import 'package:MY_NOTE_Grp3/interfaces/server/sr_listenote.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      initialRoute: '/',
      routes: {
        '/': (context) => NotesListScreen(),
        '/add': (context) => AddNoteScreen(),
      },
    );
  }
}
