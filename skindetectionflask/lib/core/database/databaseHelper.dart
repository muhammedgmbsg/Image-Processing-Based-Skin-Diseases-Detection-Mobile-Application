import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skindetectionflask/main.dart';
import 'package:skindetectionflask/models/skinModel.dart';
import 'package:sqflite/sqflite.dart';

/// DATABASE HELPER
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  DatabaseHelper._();

  Database? _db;
  Future<Database> get db async => _db!;

  Future<void> initDB() async {
    final docs = await getApplicationDocumentsDirectory();
    final path = join(docs.path, 'results.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, v) {
      return db.execute('''
        CREATE TABLE results(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          imagePath TEXT,
          label TEXT,
          confidence REAL,
          timestamp TEXT
        )
      ''');
    });
  }

  Future<int> insertResult(SkinResult res) async {
    return (await db).insert('results', res.toMap());
  }

  Future<List<SkinResult>> getAllResults() async {
    final data = await (await db).query('results', orderBy: 'id DESC');
    return data.map((e) => SkinResult.fromMap(e)).toList();
  }
}