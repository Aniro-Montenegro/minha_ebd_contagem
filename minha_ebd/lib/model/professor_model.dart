class ProfessorModel {
  String? id;
  String? name;
  String? email;
  String? phone;

  ProfessorModel({this.id, this.name, this.email, this.phone});

  ProfessorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }

  @override
  String toString() {
    return 'ProfessorModel{id: $id, name: $name, email: $email, phone: $phone}';
  }
}
