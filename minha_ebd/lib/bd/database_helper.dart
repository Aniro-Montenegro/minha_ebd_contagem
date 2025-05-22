import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('escola_dominical.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Tabela Igreja
    await db.execute('''
      CREATE TABLE igreja (
        id TEXT PRIMARY KEY,
        nome TEXT
      )
    ''');

    // Tabela Superintendente
    await db.execute('''
      CREATE TABLE superintendente (
        id TEXT PRIMARY KEY,
        nome TEXT,
        cpf TEXT,
        email TEXT,
        telefone TEXT
      )
    ''');

    // Tabela Professor
    await db.execute('''
      CREATE TABLE professor (
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        phone TEXT
      )
    ''');

    // Tabela Classe
    await db.execute('''
      CREATE TABLE classe (
        id TEXT PRIMARY KEY,
        nome TEXT,
        descricao TEXT,
        dataCriacao TEXT,
        ativo INTEGER,
        faixaEtaria TEXT,
        tipoClasse TEXT

      )
    ''');

    // Tabela de relação Classe-Professor (N:N)
    await db.execute('''
      CREATE TABLE classe_professor (
        classe_id TEXT,
        professor_id TEXT,
        PRIMARY KEY (classe_id, professor_id),
        FOREIGN KEY (classe_id) REFERENCES classe (id) ON DELETE CASCADE,
        FOREIGN KEY (professor_id) REFERENCES professor (id) ON DELETE CASCADE
      )
    ''');

    // Tabela Aula
    await db.execute('''
      CREATE TABLE aula (
        id TEXT PRIMARY KEY,
        dataAula TEXT,
        condicaoTempo TEXT
      )
    ''');

    // Tabela de relação Aula-Classe (1:N)
    await db.execute('''
      CREATE TABLE aula_classe (
        aula_id TEXT,
        classe_id TEXT,
        PRIMARY KEY (aula_id, classe_id),
        FOREIGN KEY (aula_id) REFERENCES aula (id) ON DELETE CASCADE,
        FOREIGN KEY (classe_id) REFERENCES classe (id) ON DELETE CASCADE
      )
    ''');

    // Tabela Contagem
    await db.execute('''
      CREATE TABLE contagem (
        id TEXT PRIMARY KEY,
        dataAula TEXT,
        numeroAlunos INTEGER,
        classe_id TEXT,
        aula_id TEXT,
        FOREIGN KEY (classe_id) REFERENCES classe (id) ON DELETE CASCADE,
        FOREIGN KEY (aula_id) REFERENCES aula (id) ON DELETE CASCADE
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
