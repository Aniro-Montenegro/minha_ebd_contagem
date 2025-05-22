import 'package:minha_ebd/bd/database_helper.dart';
import 'package:minha_ebd/model/contagem_model.dart';
import 'package:minha_ebd/model/classe_model.dart';
import 'package:signals/signals.dart';

class ContagemRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  final contagens = signal<List<ContagemModel>>([]);

  Future<void> loadContagens() async {
    final db = await _dbHelper.database;
    final contagensList = await db.query('contagem');
    final result = await Future.wait(
      contagensList.map((contagemMap) async {
        final classe = await getClasse(contagemMap['classe_id'] as String);
        return ContagemModel(
          id: contagemMap['id'] as String?,
          dataAula: contagemMap['dataAula'] as String?,
          numeroAlunos: contagemMap['numeroAlunos'] as int?,
          classe: classe,
        );
      }),
    );
    contagens.value = result;
  }

  Future<ClasseModel?> getClasse(String classeId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'classe',
      where: 'id = ?',
      whereArgs: [classeId],
    );
    if (result.isNotEmpty) {
      return ClasseModel.fromJson(result.first);
    }
    return null;
  }

  Future<void> addContagem(ContagemModel contagem) async {
    final db = await _dbHelper.database;
    await db.insert('contagem', {
      'id': contagem.id,
      'dataAula': contagem.dataAula,
      'numeroAlunos': contagem.numeroAlunos,
      'classe_id': contagem.classe?.id,
      'aula_id': contagem.aulaId,
    });
    await loadContagens();
  }

  Future<void> updateContagem(ContagemModel contagem) async {
    final db = await _dbHelper.database;
    await db.update(
      'contagem',
      {
        'dataAula': contagem.dataAula,
        'numeroAlunos': contagem.numeroAlunos,
        'classe_id': contagem.classe?.id,
        'aula_id': contagem.aulaId,
      },
      where: 'id = ?',
      whereArgs: [contagem.id],
    );
    await loadContagens();
  }

  Future<void> deleteContagem(String id) async {
    final db = await _dbHelper.database;
    await db.delete('contagem', where: 'id = ?', whereArgs: [id]);
    await loadContagens();
  }

  Future<List<ContagemModel>> getContagensPorAula(String aulaId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'contagem',
      where: 'aula_id = ?',
      whereArgs: [aulaId],
    );
    return await Future.wait(
      result.map((contagemMap) async {
        final classe = await getClasse(contagemMap['classe_id'] as String);
        return ContagemModel(
          id: contagemMap['id'] as String?,
          dataAula: contagemMap['dataAula'] as String?,
          numeroAlunos: contagemMap['numeroAlunos'] as int?,
          classe: classe,
        );
      }),
    );
  }
}
