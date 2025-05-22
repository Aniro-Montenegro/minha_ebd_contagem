import 'package:minha_ebd/model/classe_model.dart';

class ContagemModel {
  String? id;
  String? dataAula;
  int? numeroAlunos;
  ClasseModel? classe;
  String? aulaId;

  ContagemModel({this.id, this.dataAula, this.numeroAlunos, this.classe});
  ContagemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dataAula = json['dataAula'];
    numeroAlunos = json['numeroAlunos'];
    classe =
        json['classe'] != null ? ClasseModel.fromJson(json['classe']) : null;
    aulaId = json['aula_id'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dataAula'] = dataAula;
    data['numeroAlunos'] = numeroAlunos;
    if (classe != null) {
      data['classe'] = classe!.toJson();
    }
    data['aula_id'] = aulaId;
    return data;
  }
}
