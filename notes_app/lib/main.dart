import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/interfaces/add_note.dart';
import 'package:notes_app/interfaces/list_note.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  // 
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      initialRoute: '/',
      routes: {
        '/': (context) => NoteListScreen(),
        '/add': (context) => AddNoteScreen(),
        //'/detail': (context) => NoteDetailScreen(),
      },
    );
  }
}
