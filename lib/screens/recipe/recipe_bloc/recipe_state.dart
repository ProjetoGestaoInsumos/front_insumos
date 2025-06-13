abstract class RecipeState {}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<dynamic> recipes;
  final String query;

  RecipeLoaded(this.recipes, {this.query = ''});
}

class RecipeError extends RecipeState {
  final String message;
  RecipeError(this.message);
}
