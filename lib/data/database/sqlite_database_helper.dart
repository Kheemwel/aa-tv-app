import 'package:flutter_android_tv_box/data/database/database_tables.dart';
import 'package:flutter_android_tv_box/data/models/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteDatabaseHelper {
  // Singleton Instance
  static final SQLiteDatabaseHelper _instance =
      SQLiteDatabaseHelper._internal();
  factory SQLiteDatabaseHelper() => _instance;

  Database? _database;

  SQLiteDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database == null) {
      await initDatabase();
    }
    return _database!;
  }

  /// Initialize database
  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'aa_tv.db'),
      version: 1,
      onCreate: (db, version) async {
        // Initial table creation
        for (String table in tables) {
          await db.execute(table);
        }
      },
    );
  }

  Future<void> execute(String sql, [List<Object?>? arguments]) async {
    final db = await database;
    await db.execute(sql, arguments);
  }

  Future<List<Map<String, dynamic>>> getAll(String table,
      {String? where, List<Object?>? whereArgs}) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> batchInsert(String table, List<Model> dataList) async {
    final db = await database;

    final Batch batch = db.batch();
    for (Model data in dataList) {
      batch.insert(
        table,
        data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<int> update(String table, Map<String, dynamic> values, String where,
      List<Object?> whereArgs) async {
    final db = await database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
      String table, String where, List<Object?> whereArgs) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<void> clear(String table) async {
    final db = await database;
    db.delete(table);
  }
}
