import 'package:minha_ebd/bd/database_helper.dart';
import 'package:minha_ebd/model/professor_model.dart';
import 'package:signals/signals.dart';

class ProfessorRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  final professores = signal<List<ProfessorModel>>([]);

  Future<void> loadProfessores() async {
    final db = await _dbHelper.database;
    final result = await db.query('professor');
    professores.value =
        result.map((map) => ProfessorModel.fromJson(map)).toList();
  }

  Future<void> addProfessor(ProfessorModel professor) async {
    final db = await _dbHelper.database;
    await db.insert('professor', professor.toJson());
    await loadProfessores();
  }

  Future<void> updateProfessor(ProfessorModel professor) async {
    final db = await _dbHelper.database;
    await db.update(
      'professor',
      professor.toJson(),
      where: 'id = ?',
      whereArgs: [professor.id],
    );
    await loadProfessores();
  }

  Future<void> deleteProfessor(String id) async {
    final db = await _dbHelper.database;
    await db.delete('professor', where: 'id = ?', whereArgs: [id]);
    await loadProfessores();
  }
}
