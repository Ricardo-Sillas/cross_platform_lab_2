import 'package:sqflite/sqflite.dart';
import 'finales_model.dart';

abstract class FinalesDBWorker {
  static final _SqfLiteFinalesDBWorker db = _SqfLiteFinalesDBWorker._();
  /// Create and add the given task in this database
  Future<int> create(Finale finale);

  /// Update the given task of this database.
  Future<void> update(Finale finale);

  /// Delete the specified task.
  Future<void> delete(int id);

  /// Return the specified task, or null.
  Future<Finale> get(int id);

  /// Return all the tasks of this database.
  Future<List<Finale>> getAll();
}

class _SqfLiteFinalesDBWorker implements FinalesDBWorker {

  static const String DB_NAME = 'finales.db';
  static const String TBL_NAME = 'finales';
  static const String KEY_ID = 'id';
  static const String KEY_TITLE = 'title';
  static const String KEY_CONTENT = 'content';
  Database _db;
  //…
  _SqfLiteFinalesDBWorker._();

  Future<Database> get database async => _db ??= await _init();

  Future<Database> _init() async {
    return await openDatabase(DB_NAME,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE IF NOT EXISTS $TBL_NAME ("
                  "$KEY_ID INTEGER PRIMARY KEY,"
                  "$KEY_TITLE TEXT,"
                  "$KEY_CONTENT TEXT,"
                  ")"
          );
        }
    );
  }

  @override
  Future<int> create(Finale finale) async {
    Database db = await database;
    int id = await db.rawInsert(
        "INSERT INTO $TBL_NAME ($KEY_TITLE, $KEY_CONTENT) "
            "VALUES (?,?,)",
        [finale.title, finale.content]
    );
    return id;
  }

  @override
  Future<void> delete(int id) async {
    Database db = await database;
    await db.delete(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
  }

  @override
  Future<Finale> get(int id) async {
    Database db = await database;
    var values = await db.query(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
    return _finalesFromMap(values.first);
  }

  @override
  Future<List<Finale>> getAll() async {
    Database db = await database;
    var values = await db.query(TBL_NAME);
    List<Finale> tasks = values.isNotEmpty ? values.map((m) => _finalesFromMap(m)).toList() : [];
    return tasks;
  }

  @override
  Future<void> update(Finale finale) async {
    Database db = await database;
    await db.update(TBL_NAME, _finalesToMap(finale),
        where: "$KEY_ID = ?", whereArgs: [finale.id]
    );
  }

  Finale _finalesFromMap(Map map) {
    return Finale()
      ..id = map[KEY_ID]
      ..title = map[KEY_TITLE]
      ..content = map[KEY_CONTENT];
  }

  Map<String, dynamic> _finalesToMap(Finale finale) {
    return Map<String, dynamic>()
      ..[KEY_ID] = finale.id
      ..[KEY_TITLE] = finale.title
      ..[KEY_CONTENT] = finale.content;
  }
}
