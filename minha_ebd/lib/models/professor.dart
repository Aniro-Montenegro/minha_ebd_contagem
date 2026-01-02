import 'package:hive_ce/hive.dart';

part 'professor.g.dart';

@HiveType(typeId: 2)
class Professor {
  @HiveField(0)
  final String nome;

  @HiveField(1)
  final String sexo;

  @HiveField(2)
  final String telefone;

  @HiveField(3)
  final bool ativo;

  Professor({
    required this.nome,
    required this.sexo,
    required this.telefone,
    required this.ativo,
  });

  //empry

  Professor.empty()
    : nome = '',
      sexo = 'Masculino',
      telefone = '',
      ativo = true;
}
