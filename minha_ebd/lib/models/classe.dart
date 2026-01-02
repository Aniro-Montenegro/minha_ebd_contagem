import 'package:hive_ce/hive.dart';

part 'classe.g.dart';

@HiveType(typeId: 3)
class Classe {
  @HiveField(0)
  final String nome;

  @HiveField(1)
  final String faixaEtaria;

  @HiveField(2)
  final String tipo;

  @HiveField(3)
  final bool ativa;

  Classe({
    required this.nome,
    required this.faixaEtaria,
    required this.tipo,
    required this.ativa,
  });

  //empty

  Classe.empty() : nome = '', faixaEtaria = '', tipo = '', ativa = true;
}
