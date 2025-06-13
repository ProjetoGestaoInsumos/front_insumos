import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_insumos/api/api_service.dart';
import 'package:front_insumos/components/custom_popup.dart';
import 'package:front_insumos/models/pop.dart';
import 'package:front_insumos/models/recipe.dart';
import 'package:front_insumos/screens/orders/orders_bloc/order_bloc.dart';
import 'package:front_insumos/screens/orders/orders_bloc/order_event.dart';
import 'package:front_insumos/screens/recipe/recipe_bloc/recipe_bloc.dart';
import 'package:front_insumos/screens/recipe/recipe_bloc/recipe_state.dart';
import 'package:front_insumos/screens/stock/item_bloc/item_bloc.dart';
import 'package:front_insumos/screens/stock/item_bloc/item_event.dart';
import 'package:front_insumos/screens/stock/item_bloc/item_state.dart';
import 'package:front_insumos/utils/colors.dart';
import 'package:front_insumos/components/custom_button.dart';

void showOrderPopup(BuildContext context) {
  final GlobalKey<_OrderPopupContentState> popupKey = GlobalKey();
  CustomPopup.show(
    context: context,
    title: "POP",
    showFooter: true,
    primaryButtonLabel: "Enviar",
    secondaryButtonLabel: "Cancelar",
    primaryButtonOnPressed: () async {
      await popupKey.currentState?.submit();

      // Navigator.of(context, rootNavigator: true).pop();
    },
    secondaryButtonOnPressed: () async {
      Navigator.of(context, rootNavigator: true).pop();
    },
    content: OrderPopupContent(key: popupKey), 
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
  final TextEditingController protocoloController = TextEditingController();

  String? selectedTurno;
  String? selectedReceita;

  RecipeIngredient?
      selectedIngredient; // Ingrediente selecionado para item extra
  double ingredientQuantity = 0; // Quantidade do item extra

  List<Recipe> recipes = []; // Lista de receitas carregadas
  List<ExtraItem> extraItems = []; // Lista de itens extras

  @override
  void initState() {
    super.initState(); // Carregar as receitas da API
  }

Future<void> submit() async {
  // Lista para armazenar os nomes dos campos não preenchidos
  List<String> missingFields = [];

  if (cursoController.text.isEmpty) missingFields.add("Curso");
  if (docenteController.text.isEmpty) missingFields.add("Docente");
  if (disciplinaController.text.isEmpty) missingFields.add("Disciplina");
  if (alunosController.text.isEmpty) missingFields.add("Alunos");
  if (gruposController.text.isEmpty) missingFields.add("Grupos");
  if (objectiveController.text.isEmpty) missingFields.add("Objetivo");
  if (selectedTurno == null) missingFields.add("Turno");
  if (protocoloController.text.isEmpty) missingFields.add("Protocolo");
  if (selectedReceita == null) missingFields.add("Receita");

  if (missingFields.isNotEmpty) {
    // Imprime os campos ausentes no console para debug
    print("Campos não preenchidos: ${missingFields.join(', ')}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Preencha os campos: ${missingFields.join(', ')}"),
      ),
    );
    return;
  }

    final newPop = POP(
      recipeId: recipes.firstWhere((r) => r.name == selectedReceita).id!,
      docenteId: 1, // Ajustar conforme necessário
      docenteNome: docenteController.text,
      recipeName: selectedReceita!,
      curso: cursoController.text,
      disciplina: disciplinaController.text,
      protocolo: protocoloController.text,
      turno: TurnoEnum.values
          .firstWhere((e) => e.toString() == 'TurnoEnum.$selectedTurno'),
      date: DateTime.now(),
      nStudents: int.parse(alunosController.text),
      nGroups: int.parse(gruposController.text),
      objective:
          objectiveController.text.isEmpty ? null : objectiveController.text,
      items: extraItems,
    );

    // Envia o evento para o BLoC criar o POP
    context.read<POPBloc>().add(CreatePOP(newPop));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('POP criado com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: _buildTextField("Curso", controller: cursoController)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildTextField("Docente",
                      controller: docenteController)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                flex: 19,
                child: _buildTextField("Disciplina",
                    controller: disciplinaController),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 9,
                child: _buildTextField("Alunos", controller: alunosController),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 9,
                child: _buildTextField("Grupos", controller: gruposController),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildDateField(context)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildDropdown("Turno", ["Manhã", "Tarde", "Noite"],
                      (value) {
                setState(() {
                  selectedTurno = value;
                });
              })),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: _buildTextField("Protocolo",
                      controller: protocoloController)),
              const SizedBox(width: 16),
              Expanded(
                child: BlocBuilder<RecipeBloc, RecipeState>(
                  builder: (context, state) {
                    if (state is RecipeLoading) {
                      return const CircularProgressIndicator();
                    }
                    if (state is RecipeLoaded) {
                      final recipeNames = state.recipes
                          .map((r) => r['name'])
                          .toList()
                          .cast<String>();

                      return _buildDropdown("Receita", recipeNames, (value) {
                        setState(() {
                          selectedReceita = value;
                        });
                      });
                    }
                    return const SizedBox(); // Default if no state
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildTextField("Objetivo", controller: objectiveController, height: 80, maxLines: 3, expand: true),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                onPressed: () async {
                  showAddItemPopup(context);
                  return;
                },
                iconData: Icons.add,
                text: "Adicionar Item Extra",
                buttonColor: CustomColors.white,
                iconColor: Colors.black,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildSummaryTable(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ===============================
  // Widgets Auxiliares
  // ===============================

  static Widget _buildTextField(String label,
      {TextEditingController? controller,
      double height = 40,
      int maxLines = 1,
      bool expand = false}) {
    return SizedBox(
      height: height,
      width: expand ? double.infinity : 230,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: CustomColors.blue),
          ),
        ),
      ),
    );
  }

  static Widget _buildDateField(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: "Data",
          suffixIcon: Icon(Icons.calendar_today, size: 20),
          labelStyle: TextStyle(fontSize: 14),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColors.blue),
          ),
        ),
        readOnly: true,
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            initialDate: DateTime.now(),
          );

          if (pickedDate != null) {
            controller.text =
                "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
          }
        },
      ),
    );
  }

  static Widget _buildDropdown(
      String label, List<String> items, Function(String?) onChanged) {
    String? selectedItem;

    return StatefulBuilder(
      builder: (context, setState) {
        return DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontSize: 14),
            isDense: true,
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: CustomColors.blue),
            ),
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

  // Este método exibe a tabela com os ingredientes da receita selecionada
  Widget _buildSummaryTable() {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (selectedReceita == null) {
          return _emptyTable();
        }

        if (state is RecipeLoaded) {
          final recipesJson = state.recipes;
          final recipeJson = recipesJson.firstWhere(
            (r) => r['name'] == selectedReceita,
          );

          if (recipeJson == null) return _emptyTable();

          final recipe = Recipe.fromJson(recipeJson);

          return SizedBox(
            height: 100,
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder.all(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black26,
                ),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                  3: FlexColumnWidth(),
                },
                children: [
                  _buildTableHeader(),
                  ..._buildTableRows(recipe),
                  ..._buildExtraItemsRows(),
                ],
              ),
            ),
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }

  Widget _emptyTable() {
    return Table(
      border: TableBorder.all(
          borderRadius: BorderRadius.circular(10), color: Colors.black26),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
      },
      children: [_buildTableHeader()],
    );
  }

  int parseInt(String value) {
    try {
      return int.parse(value);
    } catch (e) {
      print("Invalid number: $value");
      return 0; // Return a default value in case of error
    }
  }

  // Este método gera as linhas da tabela com base nos ingredientes da receita selecionada
  List<TableRow> _buildTableRows(Recipe recipe) {
    final int numGroups = parseInt(gruposController.text);

    return recipe.ingredients.map<TableRow>((ingredient) {
      final necessaryQuantity = ingredient.quantity * numGroups;
      final unit = _getItemUnit(ingredient.itemId);
      final name = _getItemName(ingredient.itemId);
      return _buildTableRow(
        name,
        "$necessaryQuantity $unit", // Show quantity with unit
        "", // Leave empty for 'Em estoque'
        "", // Leave empty for 'Faltando'
      );
    }).toList();
  }

  // Este método constrói a linha da tabela
  TableRow _buildTableRow(
      String ingrediente, String necessario, String estoque, String faltando) {
    return TableRow(
      children: [
        _tableCell(ingrediente),
        _tableCell(necessario),
        _tableCell(estoque),
        _tableCell(faltando),
      ],
    );
  }

  String _getItemName(int itemId) {
    final itemBloc = BlocProvider.of<ItemBloc>(context);
    if (itemBloc.state is ItemLoaded) {
      final items = (itemBloc.state as ItemLoaded).items;
      final item = items.firstWhere(
        (item) => item.id == itemId,
      );
      return item.name;
    }
    return 'Unknown Item';
  }

  String _getItemUnit(int itemId) {
    final itemBloc = BlocProvider.of<ItemBloc>(context);
    if (itemBloc.state is ItemLoaded) {
      final items = (itemBloc.state as ItemLoaded).items;
      final item = items.firstWhere(
        (item) => item.id == itemId,
      );
      return item.unit.toString().split('.').last;
    }
    return '';
  }

  List<TableRow> _buildExtraItemsRows() {
    return extraItems.map<TableRow>((extraItem) {
      final unit = _getItemUnit(extraItem.itemId);
      final name = _getItemName(extraItem.itemId);
      return TableRow(
        children: [
          _tableCell("$name [Extra]"),
          _tableCell("${extraItem.quantity} $unit"),
          _tableCell(""), // Em estoque, leave empty
          _tableCell(""), // Faltando, leave empty
        ],
      );
    }).toList();
  }

  // Este método constrói cada célula da tabela
  static Widget _tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }

  // Este método cria o cabeçalho da tabela
  static TableRow _buildTableHeader() {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
      children: [
        _tableCell("Ingredientes", isHeader: true),
        _tableCell("Necessário", isHeader: true),
        _tableCell("Em estoque", isHeader: true),
        _tableCell("Faltando", isHeader: true),
      ],
    );
  }

  void showAddItemPopup(BuildContext context) {
    String? selectedIngredient;
    final TextEditingController unitController = TextEditingController();

    // Fetch all items from the ItemBloc
    final itemBloc = BlocProvider.of<ItemBloc>(context);
    itemBloc.add(LoadItemEvent());

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
        // Create the extra item with selected ingredient and quantity
        final selectedItem = (itemBloc.state is ItemLoaded)
            ? (itemBloc.state as ItemLoaded).items.firstWhere(
                  (item) => item.name == selectedIngredient,
                )
            : null;

        if (selectedItem != null) {
          final extraItem = ExtraItem(
            itemId: selectedItem.id!,
            quantity: double.tryParse(unitController.text) ?? 0,
          );

          // Add the extra item to the list
          setState(() {
            extraItems.add(extraItem);
          });
        }

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
                      child: BlocBuilder<ItemBloc, ItemState>(
                        builder: (context, state) {
                          if (state is ItemLoading) {
                            return const CircularProgressIndicator();
                          }

                          if (state is ItemLoaded) {
                            final itemNames =
                                state.items.map((e) => e.name).toList();
                            return DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Ingrediente',
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                border: OutlineInputBorder(),
                              ),
                              value: selectedIngredient,
                              hint: const Text('Selecione',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey)),
                              onChanged: (value) {
                                setState(() {
                                  selectedIngredient = value;
                                });
                              },
                              items: itemNames
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    ),
                                  )
                                  .toList(),
                            );
                          }

                          return const SizedBox(); // Default if no state
                        },
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
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(),
                          hintText: 'Ex: 300 ml',
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey),
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
}
