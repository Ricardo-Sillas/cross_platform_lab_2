import 'notes_model.dart';
import 'package:sqflite/sqflite.dart';
import 'notes_model.dart';

abstract class NotesDBWorker {

  static final NotesDBWorker db = _SqfliteNotesDBWorker._();

  /// Create and add the given note in this database.
  Future<int> create(Note note);

  /// Update the given note of this database.
  Future<void> update(Note note);

  /// Delete the specified note.
  Future<void> delete(int id);

  /// Return the specified note, or null.
  Future<Note> get(int id);

  /// Return all the notes of this database.
  Future<List<Note>> getAll();
}

class _MemoryNotesDBWorker implements NotesDBWorker {
  static const _TEST = true;

  var _notes = [];
  var _nextId = 1;

  _MemoryNotesDBWorker._() {
    if (_TEST && _notes.isEmpty) {
      var note = Note()
        ..title = 'Exercise: P2.3 Persistence'
        ..content = 'Code database.'
        ..color = 'blue';
      create(note);
    }
  }

  @override
  Future<void> delete(int id) async {
    _notes.removeWhere((n) => n.id == id);
  }

  @override
  Future<Note> get(int id) async {
    return _clone(_notes.firstWhere(
            (n) => n.id == id, orElse: () => null));
  }

  @override
  Future<List<Note>> getAll() async {
    return List.unmodifiable(_notes);
  }

  static Note _clone(Note note) {
    if (note != null) {
      return Note()
        ..id = note.id
        ..title = note.title
        ..content = note.content
        ..color = note.color;
    }
    return null;
  }

  @override
  Future<int> create(Note note) async {
    note = _clone(note)..id = _nextId++;
    _notes.add(note);
    print("Added: $note");
    return note.id;
  }

  @override
  Future<void> update(Note note) async {
    var old = await get(note.id);
    if (old != null) {
      old..title = note.title
        ..content = note.content
        ..color = note.color;
      print("Updated: $note");
    }
  }
}






class _SqfliteNotesDBWorker implements NotesDBWorker {

  static const String DB_NAME = 'notes.db';
  static const String TBL_NAME = 'notes';
  static const String KEY_ID = '_id';
  static const String KEY_TITLE = 'title';
  static const String KEY_CONTENT = 'content';
  static const String KEY_COLOR = 'color';

  Database _db;

  _SqfliteNotesDBWorker._();

  Future<Database> get database async => _db ??= await _init();

  @override
  Future<int> create(Note note) async {
    Database db = await database;
    int id = await db.rawInsert(
        "INSERT INTO $TBL_NAME ($KEY_TITLE, $KEY_CONTENT, $KEY_COLOR) "
            "VALUES (?, ?, ?)",
        [note.title, note.content, note.color]
    );
    return id;
  }

  @override
  Future<void> delete(int id) async {
    Database db = await database;
    await db.delete(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
  }

  @override
  Future<void> update(Note note) async {
    Database db = await database;
    await db.update(TBL_NAME, _noteToMap(note),
        where: "$KEY_ID = ?", whereArgs: [note.id]);
  }

  @override
  Future<Note> get(int id) async {
    Database db = await database;
    var values = await db.query(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
    return values.isEmpty ? null : _noteFromMap(values.first);
  }

  @override
  Future<List<Note>> getAll() async {
    Database db = await database;
    var values = await db.query(TBL_NAME);
    return values.isNotEmpty ? values.map((m) => _noteFromMap(m)).toList() : [];
  }

  Note _noteFromMap(Map map) {
    return Note()
      ..id = map[KEY_ID]
      ..title = map[KEY_TITLE]
      ..content = map[KEY_CONTENT]
      ..color = map[KEY_COLOR];
  }

  Map<String, dynamic> _noteToMap(Note note) {
    return Map<String, dynamic>()
      ..[KEY_ID] = note.id
      ..[KEY_TITLE] = note.title
      ..[KEY_CONTENT] = note.content
      ..[KEY_COLOR] = note.color;
  }

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
                  "$KEY_COLOR TEXT"
                  ")"
          );
        }
    );
  }
}
