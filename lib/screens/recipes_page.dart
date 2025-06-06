import 'package:flutter/material.dart';
import 'package:front_insumos/components/custom_button.dart';
import 'package:front_insumos/screens/recipe_form_page.dart';
import 'package:front_insumos/utils/colors.dart';

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
  final TextEditingController _searchController =
      TextEditingController(); // Adicionado para controlar o texto da pesquisa

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
    _searchController.addListener(
      _onSearchChanged,
    ); // Adiciona listener para a barra de pesquisa
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged); // Remove listener
    _searchController.dispose(); // Descarta o controller
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text;
      _filterRecipes();
    });
  }

  Future<void> _fetchRecipes() async {
    setState(() {
      isLoading = true;
    });
    try {
      // final data = await apiService.fetchRecipes();
      setState(() {
        // recipes = data;
        _filterRecipes();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar receitas: $e')));
    }
  }

  void _filterRecipes() {
    if (searchQuery.isEmpty) {
      filteredRecipes = recipes;
    } else {
      filteredRecipes = recipes
          .where(
            (recipe) => recipe['name'].toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título "Receitas"
          Center(
            child: const Text(
              'Receitas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Barra de Pesquisa
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar receitas...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: CustomColors.blue,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none, // Remove a borda padrão
                    ),
                    filled: true,
                    fillColor:
                        CustomColors.grey, // Cor de fundo conforme a imagem
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onChanged: (value) {
                    // O _onSearchChanged já cuida disso via listener no controller
                  },
                ),
              ),
              const SizedBox(width: 20),
              // Botão "Adicionar Nova Receita"
              CustomButton(
                text: "Adicionar Nova Receita",
                buttonColor: CustomColors.blue,
                borderRadius: 10,
                fontSize: 16,
                iconData: Icons.add, // Adiciona o ícone de adição
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecipeFormPage(),
                    ),
                  );
                  _fetchRecipes(); // Recarrega a lista após adicionar
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
                          crossAxisCount: 3, // 3 itens por linha
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio:
                              0.8, // Ajuste para o aspecto visual das receitas
                        ),
                        itemCount: filteredRecipes.length,
                        itemBuilder: (context, index) {
                          var recipe = filteredRecipes[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4, // Adiciona sombra para um efeito 3D
                            child: InkWell(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecipeFormPage(
                                      recipe:
                                          recipe, // Passa a receita para edição
                                    ),
                                  ),
                                );
                                _fetchRecipes(); // Recarrega a lista após editar
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Imagem da Receita
                                  Expanded(
                                    flex: 3,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(10),
                                      ),
                                      child: recipe['imageUrl'] != null &&
                                              recipe['imageUrl'].isNotEmpty
                                          ? Image.network(
                                              recipe['imageUrl'],
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) =>
                                                  Center(
                                                child: Image.asset(
                                                  'assets/images/placeholder.png',
                                                  fit: BoxFit.cover,
                                                ),
                                              ), // Imagem de placeholder
                                            )
                                          : Image.asset(
                                              'assets/images/placeholder.png',
                                              fit: BoxFit.cover,
                                            ), // Imagem de placeholder
                                    ),
                                  ),
                                  // Detalhes da Receita
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            recipe['name'] ??
                                                'Receita sem nome',
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
                                          const Spacer(), // Ocupa espaço para empurrar o botão para baixo
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: CustomButton(
                                              text: "Ver",
                                              buttonColor: CustomColors.blue,
                                              borderRadius: 8,
                                              fontSize: 14,
                                              onPressed: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RecipeFormPage(
                                                      recipe: recipe,
                                                    ),
                                                  ),
                                                );
                                                _fetchRecipes();
                                              },
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
