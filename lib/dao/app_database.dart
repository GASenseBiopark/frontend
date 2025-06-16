import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() {
    return _instance;
  }

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'gasense_local.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            email TEXT UNIQUE,
            senha_hash TEXT,
            data_cadastro TEXT,
            admin INTEGER DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE dispositivos (
            id_dispositivo TEXT PRIMARY KEY,
            nome TEXT,
            chave TEXT UNIQUE,
            localizacao TEXT,
            data_cadastro TEXT,
            id_usuario TEXT
          )
        ''');
      },
    );
  }
}
