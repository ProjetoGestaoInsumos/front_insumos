import 'package:flutter/material.dart';
import 'package:front_insumos/components/custom_button.dart';
import 'package:front_insumos/components/custom_search_field.dart';
import 'package:front_insumos/screens/recipe/recipe_form_page.dart';
import 'package:front_insumos/utils/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:front_insumos/api/api_service.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  List<dynamic> recipes = [];
  List<dynamic> filteredRecipes = [];
  bool isLoading = true;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchRecipes() async {
    setState(() => isLoading = true);
    try {
      final data = await apiService.fetchRecipes();
      setState(() {
        data.sort((a, b) => a['id'].compareTo(b['id']));
recipes = data;

        _filterRecipes();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar receitas: $e')),
      );
    }
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text;
      _filterRecipes();
    });
  }

  void _filterRecipes() {
    if (searchQuery.isEmpty) {
      filteredRecipes = List.from(recipes);
    } else {
      filteredRecipes = recipes
          .where((recipe) => recipe['name']
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  void _updateRecipe(Map<String, dynamic> updatedRecipe) {
    setState(() {
      int index = recipes.indexWhere((r) => r['id'] == updatedRecipe['id']);
      if (index != -1) {
        recipes[index] = updatedRecipe;
        _filterRecipes();
      }
    });
  }

  Future<void> _openRecipeForm(Map<String, dynamic> recipe) async {
    var recipeForEditing = Map<String, dynamic>.from(recipe);

    // Ajustar ingredientes
    if (recipeForEditing['ingredients'] != null) {
      recipeForEditing['ingredients'] =
          (recipeForEditing['ingredients'] as List).map((ing) {
        return {
          'item_id': ing['item_id'] ?? 0,
          'quantity': ing['quantity'] ?? 0,
        };
      }).toList();
    } else {
      recipeForEditing['ingredients'] = [];
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeFormPage(
          recipe: recipeForEditing,
onRecipeCreated: (updatedRecipe) {
  _updateRecipe(updatedRecipe.toJson());
},

        ),
      ),
    );

    _fetchRecipes(); // Atualiza após edição
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Receitas',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(thickness: 1, color: Colors.grey),
          const SizedBox(height: 8),
          Row(
            children: [
              CustomSearchField(
                width: 250,
                onChanged: (value) {
                  _searchController.text = value;
                  _onSearchChanged();
                },
              ),
              const Spacer(),
              CustomButton(
                text: "Adicionar Nova Receita",
                buttonColor: CustomColors.blue,
                borderRadius: 10,
                fontSize: 16,
                iconData: Icons.add,
                onPressed: () async {
                  await context.push('/receitas/novo');
                  _fetchRecipes();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredRecipes.isEmpty
                    ? Center(
                        child: Text(
                          searchQuery.isEmpty
                              ? 'Nenhuma receita cadastrada.'
                              : 'Nenhuma receita encontrada para "$searchQuery".',
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: filteredRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = filteredRecipes[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                            child: InkWell(
                              onTap: () => _openRecipeForm(recipe),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(10)),
                                      child: recipe['imageUrl'] != null &&
                                              recipe['imageUrl'].isNotEmpty
                                          ? Image.network(
                                              recipe['imageUrl'],
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  Image.asset(
                                                'assets/images/placeholder.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Image.asset(
                                              'assets/images/placeholder.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            recipe['name'] ?? 'Receita sem nome',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: CustomColors.blue,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            recipe['description'] ??
                                                'Sem descrição.',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const Spacer(),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: CustomButton(
                                              text: "Ver",
                                              buttonColor: CustomColors.blue,
                                              borderRadius: 8,
                                              fontSize: 14,
                                              onPressed: () =>
                                                  _openRecipeForm(recipe),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
