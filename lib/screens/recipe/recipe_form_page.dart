import 'package:flutter/material.dart';
import 'package:front_insumos/components/custom_button.dart';
import 'package:front_insumos/components/custom_popup.dart';
import 'package:front_insumos/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:front_insumos/models/recipe.dart';
import 'package:front_insumos/models/item.dart';
import 'dart:io';
import 'package:front_insumos/api/api_service.dart';

class RecipeFormPage extends StatefulWidget {
  final Map<String, dynamic>? recipe;
  final Function(Recipe)? onRecipeCreated;
  const RecipeFormPage({super.key, this.recipe, this.onRecipeCreated});

  @override
  _RecipeFormPageState createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientQuantityController =
      TextEditingController();

  List<dynamic> _ingredients = [];
  List<dynamic> _availableItems = [];
  Map<String, dynamic>? _selectedIngredientItem;

  bool _isLoadingItems = false;
  bool _isSaving = false;
  File? _selectedImage;

  final ApiService apiService = ApiService();

  Map<String, dynamic>? _findItemById(int? id) {
    if (id == null) return null;
    try {
      return _availableItems.firstWhere((item) => item['id'] == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> _fetchAvailableItems() async {
    setState(() {
      _isLoadingItems = true;
    });
    try {
      List<Item> items = await apiService.fetchItems();
      _availableItems = items.map((item) => item.toJson()).toList();
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

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.recipe?['name'] ?? '';
    _descriptionController.text = widget.recipe?['description'] ?? '';

    // Initialize _ingredients to an empty list if creating a new recipe
    _ingredients = widget.recipe != null ? [] : [];

    _loadItemsAndMapIngredients();

    if (widget.recipe?['imageUrl'] != null &&
        widget.recipe!['imageUrl'].isNotEmpty) {
      if (!widget.recipe!['imageUrl'].startsWith('http')) {
        _selectedImage = File(widget.recipe!['imageUrl']);
      }
    }
  }

  Future<void> _loadItemsAndMapIngredients() async {
    await _fetchAvailableItems();

    if (widget.recipe != null) {
      var rawIngredients = widget.recipe!['ingredients'] ?? [];
      setState(() {
        _ingredients = rawIngredients.map((ing) {
          // Ensure that item_id is present and valid
          return {
            'item':
                _findItemById(ing['item_id']), // Use item_id to find the item
            'quantity':
                ing['quantity'] ?? 0, // Default to 0 if quantity is null
            'item_id': ing['item_id'] ?? 0, // Store item_id for later use
          };
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _ingredientQuantityController.dispose();
    super.dispose();
  }

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

    double newQuantity = double.parse(_ingredientQuantityController.text);
    int selectedItemId = _selectedIngredientItem!['id'];

    // Check if the ingredient already exists
    int existingIndex = _ingredients
        .indexWhere((ingredient) => ingredient['item_id'] == selectedItemId);

    if (existingIndex != -1) {
      // If it exists, update the quantity
      setState(() {
        _ingredients[existingIndex]['quantity'] =
            newQuantity; // Update the quantity
      });
    } else {
      // If it doesn't exist, add it as a new ingredient
      setState(() {
        _ingredients.add({
          'item': _selectedIngredientItem,
          'item_id': selectedItemId,
          'quantity': newQuantity,
        });
      });
    }

    // Clear the selection and input field
    _selectedIngredientItem = null;
    _ingredientQuantityController.clear();
    Navigator.of(context, rootNavigator: true).pop();
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

    // Check if editing and ensure at least one ingredient is present
    if (widget.recipe != null && _ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('É necessário adicionar pelo menos um ingrediente.')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    List<RecipeIngredient> ingredients = _ingredients.map((ing) {
      return RecipeIngredient(
        itemId: ing['item_id'],
        quantity: ing['quantity'],
      );
    }).toList();

    Recipe recipe = Recipe(
      id: widget.recipe != null ? widget.recipe!['id'] as int? : null,
      name: _nameController.text,
      description: _descriptionController.text,
      ingredients: ingredients,
    );

    try {
      if (widget.recipe == null) {
        await apiService.createRecipe(recipe);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Receita criada com sucesso!')));
      } else {
        await apiService.updateRecipe(recipe);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Receita atualizada com sucesso!')));
      }
      Navigator.of(context).pop();
      if (widget.onRecipeCreated != null) {
        widget.onRecipeCreated!(recipe);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao salvar receita: $e')));
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
                          color: Colors.grey,
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
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
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
                            _selectedIngredientItem = null;
                            _ingredientQuantityController.clear();
                            CustomPopup.show(
                              context: context,
                              title: "Adicionar Ingrediente",
                              content: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setStatePopup) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (_isLoadingItems)
                                        const CircularProgressIndicator()
                                      else
                                        DropdownButtonFormField<
                                            Map<String, dynamic>>(
                                          decoration: const InputDecoration(
                                            labelText: 'Selecionar Ingrediente',
                                            border: OutlineInputBorder(),
                                          ),
                                          value: _selectedIngredientItem,
                                          items: _availableItems.map<
                                                  DropdownMenuItem<
                                                      Map<String, dynamic>>>(
                                              (item) {
                                            return DropdownMenuItem<
                                                Map<String, dynamic>>(
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
                                              "Selecione um ingrediente"),
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
                                                  ? _selectedIngredientItem![
                                                          'unit'] ??
                                                      ''
                                                  : '',
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              onClose: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                              showFooter: true,
                              primaryButtonLabel: "Adicionar",
                              primaryButtonOnPressed: () async {
                                _addIngredient();
                              },
                              secondaryButtonLabel: "Cancelar",
                              secondaryButtonOnPressed: () async {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: _ingredients.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text("Nenhum ingrediente adicionado ainda."),
                          )
                        : Table(
                            columnWidths: const {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(1),
                              3: FlexColumnWidth(0.5), // For the remove button
                            },
                            border: TableBorder.symmetric(
                              inside: BorderSide(
                                width: 0.5,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            children: [
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
                                      )),
                                  Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Quantidade',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Unidade',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Ação',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )), // Header for action
                                ],
                              ),
                              ..._ingredients.asMap().entries.map((entry) {
                                int index = entry.key;
                                var ingredient = entry.value;
                                int itemId = ingredient[
                                    'item_id']; // Use the stored item_id

                                var item = _findItemById(itemId);

                                return TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(item != null
                                          ? (item['name'] ??
                                              'Nome não disponível')
                                          : 'Item não encontrado'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          ingredient['quantity'].toString()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(item != null
                                          ? (item['unit'] ??
                                              'Unidade não disponível')
                                          : ''),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          _removeIngredient(
                                              index); // Call the remove function
                                        },
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
