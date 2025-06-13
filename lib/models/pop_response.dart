

// Modelo ExtraItem
class ExtraItem {
  final int itemId;
  final double quantity;

  ExtraItem({
    required this.itemId,
    required this.quantity,
  });

  factory ExtraItem.fromJson(Map<String, dynamic> json) {
    return ExtraItem(
      itemId: json['item_id'],
      quantity: json['quantity'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'quantity': quantity,
    };
  }
}

// Modelo POPResponse
class POPResponse {
  final int id;
  final int recipeId;
  final int docenteId;
  final String docenteNome;
  final String recipeName;
  final String curso;
  final String disciplina;
  final String protocolo;
  final String turno;
  final DateTime date;
  final int nStudents;
  final int nGroups;
  final String? objective;
  final List<ExtraItem>? extraItems;
  final String status;

  POPResponse({
    required this.id,
    required this.recipeId,
    required this.docenteId,
    required this.docenteNome,
    required this.recipeName,
    required this.curso,
    required this.disciplina,
    required this.protocolo,
    required this.turno,
    required this.date,
    required this.nStudents,
    required this.nGroups,
    this.objective,
    this.extraItems,
    required this.status,
  });

  factory POPResponse.fromJson(Map<String, dynamic> json) {
    return POPResponse(
      id: json['id'],
      recipeId: json['recipe_id'],
      docenteId: json['docente_id'],
      docenteNome: json['docente_nome'],
      recipeName: json['recipe_name'],
      curso: json['curso'],
      disciplina: json['disciplina'],
      protocolo: json['protocolo'],
      turno: json['turno'],
      date: DateTime.parse(json['date']),
      nStudents: json['n_students'],
      nGroups: json['n_groups'],
      objective: json['objective'],
      extraItems: json['extra_items'] != null
          ? List<ExtraItem>.from(
              json['extra_items'].map((x) => ExtraItem.fromJson(x)))
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipe_id': recipeId,
      'docente_id': docenteId,
      'docente_nome': docenteNome,
      'recipe_name': recipeName,
      'curso': curso,
      'disciplina': disciplina,
      'protocolo': protocolo,
      'turno': turno,
      'date': date.toIso8601String(),
      'n_students': nStudents,
      'n_groups': nGroups,
      'objective': objective,
      'extra_items': extraItems != null
          ? List<dynamic>.from(extraItems!.map((x) => x.toJson()))
          : null,
      'status': status,
    };
  }
}