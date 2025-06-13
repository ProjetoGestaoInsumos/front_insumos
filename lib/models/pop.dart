enum TurnoEnum {
  manha,
  tarde,
  noite,
}

enum StatusEnum {
  pendente,
  aprovado,
  cancelado,
}

// Model para POP
class POP {
  final int? id;
  final int recipeId;
  final int docenteId;
  final String docenteNome;  // Nome do Docente
  final String recipeName;   // Nome da Receita
  final String curso;
  final String disciplina;
  final String protocolo;
  final TurnoEnum turno;
  final DateTime date;
  final int nStudents;
  final int nGroups;
  final String? objective;
  final List<ExtraItem>? items; // Itens extras com categorias e unidades
  final StatusEnum status;

  POP({
    this.id,
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
    this.items,
    this.status = StatusEnum.pendente,
  });

  factory POP.fromJson(Map<String, dynamic> json) {
    return POP(
      id: json['id'],
      recipeId: json['recipe_id'],
      docenteId: json['docente_id'],
      docenteNome: json['docente_nome'] ?? 'Desconhecido',  // Se o nome do docente não for fornecido
      recipeName: json['recipe_name'] ?? 'Desconhecido',    // Se o nome da receita não for fornecido
      curso: json['curso'],
      disciplina: json['disciplina'],
      protocolo: json['protocolo'],
      turno: TurnoEnum.values.firstWhere((e) => e.toString() == 'TurnoEnum.${json['turno']}'),
      date: DateTime.parse(json['date']),
      nStudents: json['n_students'],
      nGroups: json['n_groups'],
      objective: json['objective'],
      items: json['extra_items'] != null
          ? List<ExtraItem>.from(json['extra_items'].map((x) => ExtraItem.fromJson(x)))
          : [],  // Lida com o caso de extra_items ser nulo ou vazio
      status: StatusEnum.values.firstWhere((e) => e.toString() == 'StatusEnum.${json['status']}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'recipe_id': recipeId,
      'docente_id': docenteId,
      'docente_nome': docenteNome,  // Incluindo nome do docente no envio
      'recipe_name': recipeName,    // Incluindo nome da receita no envio
      'curso': curso,
      'disciplina': disciplina,
      'protocolo': protocolo,
      'turno': turno.toString().split('.').last, 
      'date': date.toIso8601String(),
      'n_students': nStudents,
      'n_groups': nGroups,
      'objective': objective,
      'extra_items': items != null
          ? List<dynamic>.from(items!.map((x) => x.toJson()))
          : [],
      'status': status.toString().split('.').last,  // Converte o valor do enum para string
    };
  }
}
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