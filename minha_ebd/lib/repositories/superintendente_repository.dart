import 'package:minha_ebd/bd/database_helper.dart';
import 'package:minha_ebd/model/superintendente_model.dart';
import 'package:signals/signals.dart';

class SuperintendenteRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  final superintendentes = signal<List<SuperintendenteModel>>([]);

  Future<void> loadSuperintendentes() async {
    final db = await _dbHelper.database;
    final result = await db.query('superintendente');
    superintendentes.value =
        result.map((map) => SuperintendenteModel.fromJson(map)).toList();
  }

  Future<void> addSuperintendente(SuperintendenteModel superintendente) async {
    final db = await _dbHelper.database;
    await db.insert('superintendente', superintendente.toJson());
    await loadSuperintendentes();
  }

  Future<void> updateSuperintendente(
    SuperintendenteModel superintendente,
  ) async {
    final db = await _dbHelper.database;
    await db.update(
      'superintendente',
      superintendente.toJson(),
      where: 'id = ?',
      whereArgs: [superintendente.id],
    );
    await loadSuperintendentes();
  }

  Future<void> deleteSuperintendente(String id) async {
    final db = await _dbHelper.database;
    await db.delete('superintendente', where: 'id = ?', whereArgs: [id]);
    await loadSuperintendentes();
  }
}
