abstract class RecipeEvent {}

class FetchRecipes extends RecipeEvent {}

class SearchRecipes extends RecipeEvent {
  final String query;
  SearchRecipes(this.query);
}
