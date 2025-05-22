import 'package:minha_ebd/bd/database_helper.dart';
import 'package:minha_ebd/model/classe_model.dart';
import 'package:minha_ebd/model/professor_model.dart';
import 'package:signals/signals.dart';

class ClasseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  final classes = signal<List<ClasseModel>>([]);

  Future<void> loadClasses() async {
    final db = await _dbHelper.database;
    final classesList = await db.query('classe');
    final result = await Future.wait(
      classesList.map((classeMap) async {
        // final professores = await getProfessoresDaClasse(
        //   classeMap['id'] as String,
        // );
        return ClasseModel(
          id: classeMap['id'] as String?,
          nome: classeMap['nome'] as String?,
          descricao: classeMap['descricao'] as String?,
          dataCriacao: classeMap['dataCriacao'] as String?,
          ativo: (classeMap['ativo'] as int) == 1,
          faixaEtaria: classeMap['faixaEtaria'] as String?,
        );
      }),
    );
    classes.value = result;
  }

  Future<List<ProfessorModel>> getProfessoresDaClasse(String classeId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      '''
      SELECT p.* FROM professor p
      INNER JOIN classe_professor cp ON p.id = cp.professor_id
      WHERE cp.classe_id = ?
    ''',
      [classeId],
    );
    return result.map((map) => ProfessorModel.fromJson(map)).toList();
  }

  Future<void> addClasse(
    ClasseModel classe,
    List<String> professoresIds,
  ) async {
    final db = await _dbHelper.database;
    await db.insert('classe', classe.toJson());

    for (var professorId in professoresIds) {
      await db.insert('classe_professor', {
        'classe_id': classe.id,
        'professor_id': professorId,
      });
    }
    await loadClasses();
  }

  Future<void> updateClasse(
    ClasseModel classe,
    List<String> professoresIds,
  ) async {
    final db = await _dbHelper.database;
    await db.update(
      'classe',
      classe.toJson(),
      where: 'id = ?',
      whereArgs: [classe.id],
    );

    // Atualizar relação com professores
    await db.delete(
      'classe_professor',
      where: 'classe_id = ?',
      whereArgs: [classe.id],
    );

    for (var professorId in professoresIds) {
      await db.insert('classe_professor', {
        'classe_id': classe.id,
        'professor_id': professorId,
      });
    }
    await loadClasses();
  }

  Future<void> deleteClasse(String id) async {
    final db = await _dbHelper.database;
    await db.delete('classe', where: 'id = ?', whereArgs: [id]);
    await loadClasses();
  }
}
