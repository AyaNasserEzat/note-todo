import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models.dart';

class Sqflite {
  Database? database;
  Future getDatabase() async {
    if (database != null) return database;
    database = await initDB();
    return database;
  }

  initDB() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'aya.db');
    Database mydb = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        Batch batch = db.batch();
        batch.execute('''
CREATE TABLE notes
 (id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT,content TEXT)
''');
       
        batch.execute('''
CREATE TABLE todo(
  id INTEGER PRIMARY KEY,
  title TEXT,
 value INTEGER
)
''');
 print("create database and table ");
      batch.commit();
    });
   
    print("open database");
    return mydb;
  }

  Future insertnote(Note note) async {
    Database mydb = await getDatabase();
    Batch batch = mydb.batch();
    batch.insert("notes", note.tomap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    batch.commit();
  }

  Future<List<Map>> getFromNote() async {
    Database mydb = await getDatabase();
    List<Map> mp = await mydb.query("notes");
   // mp.map((e) => Note.fromJson(e).tomap());
    return List.generate(mp.length, (index) {
      return Note(
              content: mp[index]['content'],
              id: mp[index]['id'],
              title: mp[index]['title'])
          .tomap();
    });
  }

  Future UpdateFromNote(Note note) async {
    Database mydb = await getDatabase();
    await mydb
        .update('notes', note.tomap(), where: "id=?", whereArgs: [note.id]);
  }

  Future deletnote(int id) async {
    Database mydb = await getDatabase();
    await mydb.delete("notes", where: "id=?", whereArgs: [id]);
  }
 ////////////////////////////////////////////////////////////
   Future insertToDo(ToDo todo) async {
    Database mydb = await getDatabase();
    Batch batch = mydb.batch();
    batch.insert("todo", todo.tomap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    batch.commit();
  }

  Future<List<Map>> getFromToDo() async {
    Database mydb = await getDatabase();
    List<Map> mp = await mydb.query("todo");
  //  mp.map((e) => Note.fromJson(e).tomap());
  //   return List.generate(mp.length, (index) {
  //     return Note(
  //             content: mp[index]['content'],
  //             id: mp[index]['id'],
  //             title: mp[index]['title'])
  //         .tomap();
  //   });
     return mp;
  }

 Future updatcheckBox(int id, int curvalue) async {
    Database db = await getDatabase();
    Map<String, dynamic> values = {"value": curvalue == 0 ? 1 : 0};
    await db.update('todo', values, where: "id=?", whereArgs: [id]);
  }

  Future deletToDo(int id) async {
    Database mydb = await getDatabase();
    await mydb.delete("todo", where: "id=?", whereArgs: [id]);
  }

}
