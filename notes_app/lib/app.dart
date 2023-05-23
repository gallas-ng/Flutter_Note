import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:MY_NOTE_Grp3/firebase_options.dart';
import 'auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({super.key});
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     theme: ThemeData(
       primarySwatch: Colors.amber,
     ),
     home: const AuthGate(),
   );
 }
}