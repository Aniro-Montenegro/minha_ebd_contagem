import 'package:hive_ce/hive.dart';

part 'superintendente.g.dart';

@HiveType(typeId: 1)
class Superintendente {
  @HiveField(0)
  final String nome;

  Superintendente({required this.nome});
}
