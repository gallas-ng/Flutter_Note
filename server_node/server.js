const express = require('express');
const mysql = require('mysql');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();

// Configuration de la connexion à la base de données
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'tp_flutter',
});

// Test de la connexion à la base de données
connection.connect((err) => {
  if (err) throw err;
  console.log('Connecté à la base de données MySQL');
});

// Utilisation de CORS pour permettre l'accès depuis n'importe quelle origine
app.use(cors());

// Utilisation de body-parser pour récupérer les données envoyées par POST
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Route pour obtenir la liste des notes
app.get('/notes', (req, res) => {
  const sql = 'SELECT * FROM notes';
  connection.query(sql, (err, result) => {
    if (err) throw err;
    console.log('Liste des notes chargée');
    res.send(result);
  });
});

// Route pour ajouter une note
app.post('/notes/add', (req, res) => {
  const { title, content } = req.body;
  const sql = 'INSERT INTO notes (title, content) VALUES (?, ?)';
  connection.query(sql, [title, content], (err, result) => {
    if (err) throw err;
    console.log(`Note ajoutée avec l'id ${result.insertId}`);
    res.send('Note ajoutée');
  });
});

// Lancement du serveur sur le port 3000
app.listen(3000, '192.168.43.23', () => {
  console.log('Serveur démarré sur le port 3000');
});
