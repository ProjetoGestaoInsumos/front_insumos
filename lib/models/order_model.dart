// models/order_model.dart
class OrderModel {
  final int id;
  final String docenteNome;
  final String recipeName;
  final String curso;
  final String disciplina;
  final String protocolo;
  final String turno;
  final String date;
  final int nStudents;
  final int nGroups;
  final String objective;
  final String status;

  OrderModel({
    required this.id,
    required this.docenteNome,
    required this.recipeName,
    required this.curso,
    required this.disciplina,
    required this.protocolo,
    required this.turno,
    required this.date,
    required this.nStudents,
    required this.nGroups,
    required this.objective,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      docenteNome: json['docente_nome'],
      recipeName: json['recipe_name'],
      curso: json['curso'],
      disciplina: json['disciplina'],
      protocolo: json['protocolo'],
      turno: json['turno'],
      date: json['date'],
      nStudents: json['n_students'],
      nGroups: json['n_groups'],
      objective: json['objective'],
      status: json['status'],
    );
  }
}
