import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'storage.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'storage.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE storage(
          label TEXT PRIMARY KEY,
          url TEXT
      )
      ''');
  }

  Future<int> add(Storage s) async {
    Database db = await instance.database;
    return await db.insert('storage', s.toMap());
  }

  Future<int> remove(String label) async {
    Database db = await instance.database;
    return await db.delete('storage', where: 'label = ?', whereArgs: [label]);
  }

  Future<List<Storage>> datas() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM storage');
    return List.generate(maps.length, (i) {
      return Storage(
        text: maps[i]['label'],
        url: maps[i]['url'],
      );
    });
  }
}
