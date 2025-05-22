import 'package:minha_ebd/bd/database_helper.dart';
import 'package:minha_ebd/model/aula_model.dart';
import 'package:minha_ebd/model/classe_model.dart';
import 'package:signals/signals.dart';

class AulaRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  final aulas = signal<List<AulaModel>>([]);

  Future<void> loadAulas() async {
    final db = await _dbHelper.database;
    final aulasList = await db.query('aula');
    final result = await Future.wait(
      aulasList.map((aulaMap) async {
        final classes = await getClassesDaAula(aulaMap['id'] as String);
        return AulaModel(
          id: aulaMap['id'] as String?,
          dataAula: aulaMap['dataAula'] as String?,
          condicaoTempo: aulaMap['condicaoTempo'] as String?,
          classes: classes,
        );
      }),
    );
    aulas.value = result;
  }

  Future<List<ClasseModel>> getClassesDaAula(String aulaId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      '''
      SELECT c.* FROM classe c
      INNER JOIN aula_classe ac ON c.id = ac.classe_id
      WHERE ac.aula_id = ?
    ''',
      [aulaId],
    );
    return result.map((map) => ClasseModel.fromJson(map)).toList();
  }

  Future<void> addAula(AulaModel aula, List<String> classesIds) async {
    final db = await _dbHelper.database;
    await db.insert('aula', aula.toJson());

    for (var classeId in classesIds) {
      await db.insert('aula_classe', {
        'aula_id': aula.id,
        'classe_id': classeId,
      });
    }
    await loadAulas();
  }

  Future<void> updateAula(AulaModel aula, List<String> classesIds) async {
    final db = await _dbHelper.database;
    await db.update(
      'aula',
      aula.toJson(),
      where: 'id = ?',
      whereArgs: [aula.id],
    );

    // Atualizar relação com classes
    await db.delete('aula_classe', where: 'aula_id = ?', whereArgs: [aula.id]);

    for (var classeId in classesIds) {
      await db.insert('aula_classe', {
        'aula_id': aula.id,
        'classe_id': classeId,
      });
    }
    await loadAulas();
  }

  Future<void> deleteAula(String id) async {
    final db = await _dbHelper.database;
    await db.delete('aula', where: 'id = ?', whereArgs: [id]);
    await loadAulas();
  }
}
