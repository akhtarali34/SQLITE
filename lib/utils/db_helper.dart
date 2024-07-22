import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqfilte_notes_app/models/notes_model.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  Future<Database> initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "notes.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL, date TEXT NOT NULL)");
    print("Table created");
  }

  // Function to insert the Notes
  Future<Notes> insert(Notes notes) async {
    var dbClient = await db;
    print("Inserting notes: ${notes.toMap()}");
    await dbClient!.insert("notes", notes.toMap());
    return notes;
  }

  // Function to retrieve the data from the db
  Future<List<Notes>> getNotesList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query("notes");
    return queryResult.map((e) => Notes.fromMap(e)).toList();
  }


  // deleet

Future<int> deleteNote (int id) async{
    var dbClient = await db;
    return await dbClient!.delete(
      "notes",
      where: " id = ?",
      whereArgs: [id]
    );
}
}
