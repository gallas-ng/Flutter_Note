import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:notes_app/interfaces/firebase/add_note.dart';
import 'package:notes_app/interfaces/firebase/list_note.dart';
import 'package:notes_app/interfaces/server/sr_addnote.dart' as ServerAddNote;
import 'package:notes_app/interfaces/server/sr_listenote.dart' as ServerListNote;

enum Environment { firebase, server }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Environment _currentEnvironment = Environment.firebase;

  void _switchEnvironment() {
    setState(() {
      _currentEnvironment = _currentEnvironment == Environment.firebase ? Environment.server : Environment.firebase;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainScreen;
    if (_currentEnvironment == Environment.firebase) {
      mainScreen = NoteListScreen();
    } else {
      mainScreen = ServerListNote.NotesListScreen();
    }

    return MaterialApp(
      title: 'Notes App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Notes App (Env = ${_currentEnvironment.name})'),
          actions: [
            IconButton(
              icon: Icon(Icons.swap_horizontal_circle_outlined, size: 40,),
              onPressed: _switchEnvironment,
            ),
          ],
        ),
        body: mainScreen,
      ),
    );
  }
}