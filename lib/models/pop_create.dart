class POPCreate {
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
  final List<Map<String, dynamic>>? extraItems;

  POPCreate({
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
  });

  Map<String, dynamic> toJson() {
    return {
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
      'extra_items': extraItems,
    };
  }
}
