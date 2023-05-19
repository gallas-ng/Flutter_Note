import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:notes_app/interfaces/firebase/add_note.dart';
import 'package:notes_app/interfaces/firebase/list_note.dart';
import 'package:notes_app/interfaces/server/sr_addnote.dart' as ServerAddNote;
import 'package:notes_app/interfaces/server/sr_listenote.dart'
    as ServerListNote;

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

bool _iconBool = false;
//variables : _iconBool, de type booléen

IconData _iconLight = Icons.wb_sunny;
IconData _iconDark = Icons.nights_stay;
// _iconLight et _iconDark, de type IconData
/*
 * La variable _iconLight est initialisée avec l'icône "wb_sunny" qui représente un soleil (utilisé généralement pour indiquer une interface claire ou un mode lumineux), 
 * tandis que _iconDark est initialisée avec l'icône "nights_stay" qui représente une nuit étoilée (utilisée généralement pour indiquer une interface sombre ou un mode nuit).
 * Ces variables peuvent être utilisées pour sélectionner l'icône appropriée à afficher en fonction de la valeur de _iconBool. Par exemple, si _iconBool est true, on pourrait 
 * afficher _iconLight, sinon on pourrait afficher _iconDark.
 * Ces variables peuvent être utilisées pour sélectionner l'icône appropriée à afficher en fonction de la valeur de _iconBool. 
 * Par exemple, si _iconBool est true, on pourrait afficher _iconLight, sinon on pourrait afficher _iconDark.
 */

ThemeData _lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
);
/*
  *Ce code définit une variable _lightTheme de type ThemeData qui représente un thème clair dans le framework Flutter.
  *Le thème clair est défini en utilisant la classe ThemeData avec les paramètres suivants :
  *primarySwatch: Colors.blue : Cela définit la couleur principale du thème en utilisant la palette de couleurs "blue" de Flutter. 
  *La couleur principale est utilisée pour les éléments tels que la barre d'applications, les boutons, etc.
  *brightness: Brightness.light : Cela définit la luminosité du thème comme étant "light" (clair). 
  *Cela signifie que le thème est conçu pour être utilisé dans des environnements lumineux, où les éléments de l'interface utilisateur seront affichés avec des couleurs claires et un contraste élevé.
 */

ThemeData _darkTheme = ThemeData(
  //primarySwatch: Colors.red,
  brightness: Brightness.dark,
);

class _MyAppState extends State<MyApp> {
  Environment _currentEnvironment = Environment.firebase;

  void _switchEnvironment() {
    setState(() {
      _currentEnvironment = _currentEnvironment == Environment.firebase
          ? Environment.server
          : Environment.firebase;
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
      theme: _iconBool ? _darkTheme : _lightTheme,

      /*
      *Si _iconBool est true, cela signifie que l'icône est active, alors _darkTheme est utilisé comme thème. 
      *Sinon, si _iconBool est false, cela signifie que l'icône est désactivée, alors _lightTheme est utilisé comme thème.
       */

      darkTheme: ThemeData(brightness: Brightness.dark),
      /*
      *Ce code définit un thème sombre (darkTheme) en utilisant la classe ThemeData du framework Flutter.

Le thème sombre est défini avec le paramètre brightness ayant la valeur Brightness.dark
      */
      title: 'Notes App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Notes App (Env = ${_currentEnvironment.name})'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.swap_horizontal_circle_outlined,
                size: 40,
              ),
              onPressed: _switchEnvironment,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _iconBool = !_iconBool;
                });
                /**
                 * 
                 * IconButton) qui réagit au clic de l'utilisateur et modifie la valeur de la variable _iconBool lorsqu'il est pressé. Il affiche également une icône dynamique en fonction de la valeur de _iconBool.
                 * Lorsque l'utilisateur appuie sur le bouton, la fonction onPressed est déclenchée. À l'intérieur de cette fonction, setState est utilisé pour notifier Flutter que l'état de la widget doit être mis à jour. À chaque clic, _iconBool est inversé en utilisant l'opérateur !. Si _iconBool est true, il sera inversé en false, et vice versa.
                 * L'icône affichée dans le bouton est déterminée par la valeur de _iconBool. Si _iconBool est true, alors l'icône _iconDark sera utilisée, sinon si _iconBool est false, l'icône _iconLight sera utilisée. Cela permet de changer dynamiquement l'icône affichée en fonction de l'état de _iconBool.*
                 */
              },
              icon: Icon(_iconBool ? _iconDark : _iconLight),
            ),
          ],
        ),
        body: mainScreen,
      ),
    );
  }
}
