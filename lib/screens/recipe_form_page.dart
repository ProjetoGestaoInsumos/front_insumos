import 'package:flutter/material.dart';
import 'package:front_insumos/components/custom_button.dart';
import 'package:front_insumos/components/custom_popup.dart';
import 'package:front_insumos/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart'; // Importação necessária
import 'dart:io'; // Importação necessária para File

class RecipeFormPage extends StatefulWidget {
  final Map<String, dynamic>? recipe; // Nulo para criação, não nulo para edição

  const RecipeFormPage({super.key, this.recipe});

  @override
  _RecipeFormPageState createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientQuantityController =
      TextEditingController();

  List<dynamic> _ingredients = []; // Ingredientes da receita atual
  List<dynamic> _availableItems = []; // Todos os itens disponíveis do backend
  dynamic _selectedIngredientItem; // Item selecionado no popup de ingrediente

  bool _isLoadingItems = false;
  bool _isSaving = false;

  File?
      _selectedImage; // Adicione esta linha para armazenar a imagem selecionada

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _nameController.text = widget.recipe!['name'] ?? '';
      _descriptionController.text = widget.recipe!['description'] ?? '';
      _ingredients = List.from(widget.recipe!['ingredients'] ?? []);
      if (widget.recipe!['imageUrl'] != null &&
          widget.recipe!['imageUrl'].isNotEmpty) {
        if (!widget.recipe!['imageUrl'].startsWith('http')) {
          _selectedImage = File(widget.recipe!['imageUrl']);
        }
      }
    }
    _fetchAvailableItems();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _ingredientQuantityController.dispose();
    super.dispose();
  }

  Future<void> _fetchAvailableItems() async {
    setState(() {
      _isLoadingItems = true;
    });
    try {
      // COMENTE OU REMOVA A LINHA ABAIXO PARA USAR OS INGREDIENTES HARDCODED
      // _availableItems = await apiService.fetchProdutos(); // Busca os itens disponíveis

      // ADICIONE ESTAS OPÇÕES DE INGREDIENTES PARA TESTE
      _availableItems = [
        {'id': 'ing_1', 'name': 'Farinha de Trigo', 'unit': 'g'},
        {'id': 'ing_2', 'name': 'Açúcar', 'unit': 'g'},
        {'id': 'ing_3', 'name': 'Ovos', 'unit': 'unidade(s)'},
        {'id': 'ing_4', 'name': 'Leite', 'unit': 'ml'},
        {'id': 'ing_5', 'name': 'Manteiga', 'unit': 'g'},
        {'id': 'ing_6', 'name': 'Sal', 'unit': 'g'},
        {'id': 'ing_7', 'name': 'Pimenta do Reino', 'unit': 'g'},
        {'id': 'ing_8', 'name': 'Cebola', 'unit': 'unidade(s)'},
        {'id': 'ing_9', 'name': 'Alho', 'unit': 'dente(s)'},
        {'id': 'ing_10', 'name': 'Tomate', 'unit': 'unidade(s)'},
        {'id': 'ing_11', 'name': 'Frango', 'unit': 'g'},
        {'id': 'ing_12', 'name': 'Carne Bovina', 'unit': 'g'},
        {'id': 'ing_13', 'name': 'Macarrão', 'unit': 'g'},
        {'id': 'ing_14', 'name': 'Queijo Parmesão', 'unit': 'g'},
        {'id': 'ing_15', 'name': 'Azeite', 'unit': 'ml'},
      ];

      debugPrint('Available items fetched (hardcoded): $_availableItems');
    } catch (e) {
      debugPrint('Erro ao buscar itens disponíveis: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar itens disponíveis: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoadingItems = false;
      });
    }
  }

  // Função para selecionar a imagem
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _addIngredient() {
    if (_selectedIngredientItem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um ingrediente.')),
      );
      return;
    }
    if (_ingredientQuantityController.text.isEmpty ||
        double.tryParse(_ingredientQuantityController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe uma quantidade válida.')),
      );
      return;
    }

    setState(() {
      _ingredients.add({
        'item': _selectedIngredientItem,
        'quantity': double.parse(_ingredientQuantityController.text),
      });
      _selectedIngredientItem = null;
      _ingredientQuantityController.clear();
    });
    Navigator.of(context, rootNavigator: true).pop(); // Fecha o popup
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final recipeData = {
      'name': _nameController.text,
      'description': _descriptionController.text,
      'ingredients': _ingredients
          .map(
            (ing) => {
              'item_id': ing['item']['id'],
              'quantity': ing['quantity'],
            },
          )
          .toList(),
      'imageUrl':
          _selectedImage?.path ?? '', // Adicione o caminho da imagem aqui
    };

    try {
      if (widget.recipe == null) {
        // await apiService.createRecipe(recipeData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receita criada com sucesso!')),
        );
      } else {
        // await apiService.updateRecipe(widget.recipe!['id'], recipeData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receita atualizada com sucesso!')),
        );
      }
      Navigator.of(context).pop(); // Voltar para a lista de receitas
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar receita: $e')));
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.white,
        title: Text(widget.recipe == null ? "Nova Receita" : "Editar Receita"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                      : (widget.recipe?['imageUrl'] != null &&
                              widget.recipe!['imageUrl'].startsWith('http')
                          ? Image.network(
                              widget.recipe!['imageUrl'],
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.broken_image,
                                size: 100,
                                color: CustomColors.grey,
                              ),
                            )
                          : Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: CustomColors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: CustomColors.grey),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 50,
                                    color: CustomColors.grey,
                                  ),
                                  Text(
                                    "Nenhuma imagem selecionada",
                                    style: TextStyle(
                                      color: CustomColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                ),
                const SizedBox(height: 8),
                Center(
                  child: IntrinsicWidth(
                    // <-- Alteração aplicada aqui
                    child: CustomButton(
                      text: "Selecionar Imagem",
                      buttonColor: CustomColors.blue,
                      onPressed: _pickImage,
                      borderRadius: 10,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome da Receita',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey, // borda padrão
                          width: 1.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O nome da receita é obrigatório.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Descrição da Receita',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey, // borda padrão
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // --- AQUI É ONDE A MUDANÇA SERÁ APLICADA ---
                Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 700,
                    ), // Adjust maxWidth as needed
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Ingredientes",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CustomButton(
                          text: "Adicionar Ingrediente",
                          buttonColor: CustomColors.blue,
                          onPressed: () async {
                            _selectedIngredientItem = null; // Reseta a seleção
                            _ingredientQuantityController
                                .clear(); // Limpa a quantidade
                            CustomPopup.show(
                              context: context,
                              title: "Adicionar Ingrediente",
                              content: StatefulBuilder(
                                builder: (
                                  BuildContext context,
                                  StateSetter setStatePopup,
                                ) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (_isLoadingItems)
                                        const CircularProgressIndicator()
                                      else
                                        DropdownButtonFormField<dynamic>(
                                          decoration: const InputDecoration(
                                            labelText: 'Selecionar Ingrediente',
                                            border: OutlineInputBorder(),
                                          ),
                                          value: _selectedIngredientItem,
                                          items: _availableItems.map((item) {
                                            return DropdownMenuItem<dynamic>(
                                              value: item,
                                              child: Text(item['name']),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setStatePopup(() {
                                              _selectedIngredientItem =
                                                  newValue;
                                            });
                                          },
                                          hint: const Text(
                                            "Selecione um ingrediente",
                                          ),
                                        ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller:
                                            _ingredientQuantityController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Quantidade',
                                          border: const OutlineInputBorder(),
                                          suffixText:
                                              _selectedIngredientItem != null
                                                  ? _selectedIngredientItem[
                                                          'unit'] ??
                                                      ''
                                                  : '',
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              onClose: () => Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pop(),
                              showFooter: true,
                              primaryButtonLabel: "Adicionar",
                              primaryButtonOnPressed: () async {
                                _addIngredient();
                              },
                              secondaryButtonLabel: "Cancelar",
                              secondaryButtonOnPressed: () async {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // --- FIM DA MUDANÇA ---
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: _ingredients.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Nenhum ingrediente adicionado ainda.",
                            ),
                          )
                        : Table(
                            columnWidths: const {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(1),
                            },
                            border: TableBorder.symmetric(
                              inside: BorderSide(
                                width: 0.5,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            children: [
                              // Cabeçalho
                              const TableRow(
                                decoration: BoxDecoration(
                                  color: Color(0xFFEFEFEF),
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Ingredientes',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Quantidade',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Unidade',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Linhas dinâmicas com dados
                              ..._ingredients.map((ingredient) {
                                return TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(ingredient['item']['name']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        ingredient['quantity'].toString(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        ingredient['item']['unit'] ?? '',
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: IntrinsicWidth(
                    child: CustomButton(
                      text: _isSaving
                          ? "Salvando..."
                          : (widget.recipe == null
                              ? "Salvar Receita"
                              : "Atualizar Receita"),
                      buttonColor: CustomColors.blue,
                      onPressed: _isSaving ? null : _saveRecipe,
                      borderRadius: 10,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
