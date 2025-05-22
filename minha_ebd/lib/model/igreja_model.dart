class IgrejaModel {
  String? id;
  String? nome;

  IgrejaModel({this.id, this.nome});
  IgrejaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    return data;
  }

  @override
  String toString() {
    return 'IgrejaModel{id: $id, nome: $nome}';
  }
}
