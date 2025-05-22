class SuperintendenteModel {
  String? id;
  String? nome;
  String? cpf;
  String? email;
  String? telefone;

  SuperintendenteModel({
    this.id,
    this.nome,
    this.cpf,
    this.email,
    this.telefone,
  });
  SuperintendenteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    cpf = json['cpf'];
    email = json['email'];
    telefone = json['telefone'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['cpf'] = cpf;
    data['email'] = email;
    data['telefone'] = telefone;
    return data;
  }

  @override
  String toString() {
    return 'SuperintendenteModel{id: $id, nome: $nome, cpf: $cpf, email: $email, telefone: $telefone}';
  }
}
