import 'package:hive_ce/hive.dart';

part 'aula.g.dart';

@HiveType(typeId: 4)
class Aula {
  @HiveField(0)
  final DateTime data;

  @HiveField(1)
  final int professorKey;

  @HiveField(2)
  final int classeKey;

  @HiveField(3)
  final int presentes;

  @HiveField(4)
  final double ofertas;

  Aula({
    required this.data,
    required this.professorKey,
    required this.classeKey,
    required this.presentes,
    this.ofertas = 0.0,
  });
}
