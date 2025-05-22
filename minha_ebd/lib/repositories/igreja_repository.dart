import 'package:minha_ebd/bd/database_helper.dart';
import 'package:minha_ebd/model/igreja_model.dart';
import 'package:signals/signals_flutter.dart';

class IgrejaRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  final igreja = signal<IgrejaModel?>(null);
  final isLoading = signal(false);

  Future<void> loadIgreja() async {
    isLoading.value = true;
    final db = await _dbHelper.database;
    final result = await db.query('igreja', limit: 1);
    igreja.value = result.isEmpty ? null : IgrejaModel.fromJson(result.first);
    isLoading.value = false;
  }

  Future<void> saveIgreja(IgrejaModel igreja) async {
    final db = await _dbHelper.database;
    await db.delete('igreja'); // Remove qualquer igreja existente
    await db.insert('igreja', igreja.toJson());
    await loadIgreja();
  }

  Future<void> deleteIgreja() async {
    final db = await _dbHelper.database;
    await db.delete('igreja');
    igreja.value = null;
  }
}

final igrejaRepo = IgrejaRepository();
