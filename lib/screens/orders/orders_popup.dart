import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_insumos/api/api_service.dart';
import 'package:front_insumos/components/custom_popup.dart';
import 'package:front_insumos/models/pop.dart';
import 'package:front_insumos/models/recipe.dart';
import 'package:front_insumos/screens/orders/orders_bloc/order_bloc.dart';
import 'package:front_insumos/screens/orders/orders_bloc/order_event.dart';
import 'package:front_insumos/utils/colors.dart';
import 'package:front_insumos/components/custom_button.dart';

void showOrderPopup(BuildContext context) {
  CustomPopup.show(
    context: context,
    title: "POP",
    showFooter: true,
    primaryButtonLabel: "Enviar",
    secondaryButtonLabel: "Cancelar",
    primaryButtonOnPressed: () async {
      Navigator.of(context, rootNavigator: true).pop();
    },
    secondaryButtonOnPressed: () async {
      Navigator.of(context, rootNavigator: true).pop();
    },
    content: const OrderPopupContent(),
  );
}

void showAddItemPopup(BuildContext context) {
  String? selectedIngredient;
  final TextEditingController unitController = TextEditingController();

  CustomPopup.show(
    context: context,
    title: "Adicionar item extra",
    showFooter: true,
    primaryButtonLabel: "Sim",
    secondaryButtonLabel: "Não",
    primaryButtonOnPressed: () async {
      if (selectedIngredient == null || unitController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha todos os campos')),
        );
        return;
      }
      // ✅ Aqui você pode processar os dados capturados
      // print('Ingrediente: $selectedIngredient');
      // print('Unidade: ${unitController.text}');

      Navigator.of(context, rootNavigator: true).pop();
      return;
    },
    secondaryButtonOnPressed: () async {
      Navigator.of(context, rootNavigator: true).pop();
      return;
    },
    content: StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Ingrediente',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(),
                      ),
                      value: selectedIngredient,
                      hint: const Text('Selecione', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      onChanged: (value) {
                        setState(() {
                          selectedIngredient = value;
                        });
                      },
                      items: ['Leite', 'Farinha', 'Ovo', 'Carne']
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: unitController,
                      decoration: const InputDecoration(
                        labelText: 'Unidade',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(),
                        hintText: 'Ex: 300 ml',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}


class OrderPopupContent extends StatefulWidget {
  const OrderPopupContent({super.key});

  @override
  _OrderPopupContentState createState() => _OrderPopupContentState();
}

class _OrderPopupContentState extends State<OrderPopupContent> {
  final TextEditingController cursoController = TextEditingController();
  final TextEditingController docenteController = TextEditingController();
  final TextEditingController disciplinaController = TextEditingController();
  final TextEditingController alunosController = TextEditingController();
  final TextEditingController gruposController = TextEditingController();
  final TextEditingController objectiveController = TextEditingController();

  String? selectedTurno;
  String? selectedProtocolo;
  String? selectedReceita;
  StatusEnum? selectedStatus;

  late List<Recipe> recipes;  // Lista de receitas

  @override
  void initState() {
    super.initState();
    // Carregar as receitas da API
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    try {
      final recipes = await ApiService().fetchRecipes();
      setState(() {
        this.recipes = recipes;
      });
    } catch (e) {
      print("Erro ao carregar receitas: $e");
    }
  }

  void _submit() {
    if (cursoController.text.isEmpty ||
        docenteController.text.isEmpty ||
        disciplinaController.text.isEmpty ||
        alunosController.text.isEmpty ||
        gruposController.text.isEmpty ||
        objectiveController.text.isEmpty ||
        selectedTurno == null ||
        selectedProtocolo == null ||
        selectedReceita == null ||
        selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    final newPop = POP(
      recipeId: recipes.firstWhere((r) => r.name == selectedReceita).id,
      docenteId: 1,  // Ajustar conforme necessário
      docenteNome: docenteController.text,
      recipeName: selectedReceita!,
      curso: cursoController.text,
      disciplina: disciplinaController.text,
      protocolo: selectedProtocolo!,
      turno: TurnoEnum.values.firstWhere((e) => e.toString() == 'TurnoEnum.$selectedTurno'),
      date: DateTime.now(),
      nStudents: int.parse(alunosController.text),
      nGroups: int.parse(gruposController.text),
      objective: objectiveController.text.isEmpty ? null : objectiveController.text,
      items: [], // Adicione itens conforme necessário
      status: selectedStatus!,
    );

    // Envia o evento para o BLoC criar o POP
    context.read<POPBloc>().add(CreatePOP(newPop));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildTextField("Curso", controller: cursoController)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField("Docente", controller: docenteController)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildTextField("Disciplina", controller: disciplinaController)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField("Alunos", controller: alunosController)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField("Grupos", controller: gruposController)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildDropdown("Turno", ["Manhã", "Tarde", "Noite"], (value) {
                setState(() {
                  selectedTurno = value;
                });
              })),
              const SizedBox(width: 16),
              Expanded(child: _buildDropdown("Protocolo", ["Padrão", "Outro"], (value) {
                setState(() {
                  selectedProtocolo = value;
                });
              })),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildDropdown("Receita", recipes.map((r) => r.name).toList(), (value) {
                setState(() {
                  selectedReceita = value;
                });
              })),
            ],
          ),
          const SizedBox(height: 14),
          _buildTextField("Objetivo", controller: objectiveController, height: 80, maxLines: 3),
          const SizedBox(height: 20),
          CustomButton(
            onPressed: _submit,
            iconData: Icons.send,
            text: "Enviar",
            buttonColor: CustomColors.blue,
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }

  static Widget _buildTextField(String label, {TextEditingController? controller, double height = 40, int maxLines = 1}) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  static Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged) {
    String? selectedItem;

    return StatefulBuilder(
      builder: (context, setState) {
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontSize: 14),
            isDense: true,
            border: const OutlineInputBorder(),
          ),
          value: selectedItem,
          onChanged: (value) {
            setState(() {
              selectedItem = value;
            });
            onChanged(value);
          },
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
