import 'package:hive_ce/hive.dart';

part 'igreja.g.dart';

@HiveType(typeId: 0)
class Igreja {
  @HiveField(0)
  final String nome;

  Igreja({required this.nome});
}
