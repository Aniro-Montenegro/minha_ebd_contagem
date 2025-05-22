import 'package:minha_ebd/model/classe_model.dart';

class AulaModel {
  String? id;
  String? dataAula;
  String? condicaoTempo;
  List<ClasseModel>? classes;

  AulaModel({this.id, this.dataAula, this.condicaoTempo, this.classes});

  AulaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dataAula = json['dataAula'];
    condicaoTempo = json['condicaoTempo'];
    if (json['classes'] != null) {
      classes = <ClasseModel>[];
      json['classes'].forEach((v) {
        classes!.add(ClasseModel.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dataAula'] = dataAula;
    data['condicaoTempo'] = condicaoTempo;
    if (classes != null) {
      data['classes'] = classes!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'AulaModel{id: $id, dataAula: $dataAula, condicaoTempo: $condicaoTempo, classes: $classes}';
  }
}
