class ClasseModel {
  String? id;
  String? nome;
  String? descricao;
  String? dataCriacao;
  bool? ativo;
  String? faixaEtaria;
  String? tipoClasse;

  ClasseModel({
    this.id,
    this.nome,
    this.descricao,
    this.dataCriacao,
    this.ativo,
    this.faixaEtaria,
    this.tipoClasse,
  });
  ClasseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
    dataCriacao = json['dataCriacao'];
    ativo = json['ativo'];
    faixaEtaria = json['faixaEtaria'];
    tipoClasse = json['tipoClasse'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['descricao'] = descricao;
    data['dataCriacao'] = dataCriacao;
    data['ativo'] = ativo;
    data['faixaEtaria'] = faixaEtaria;
    data['tipoClasse'] = tipoClasse;
    return data;
  }

  @override
  String toString() {
    return 'ClasseModel{id: $id, nome: $nome, descricao: $descricao, dataCriacao: $dataCriacao, ativo: $ativo, faixaEtaria: $faixaEtaria, tipoClasse: $tipoClasse}';
  }
}
