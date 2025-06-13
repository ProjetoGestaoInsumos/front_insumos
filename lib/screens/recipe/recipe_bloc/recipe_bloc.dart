import 'package:flutter_bloc/flutter_bloc.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';
import 'package:front_insumos/api/api_service.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final ApiService apiService;

  List<dynamic> _allRecipes = [];

  RecipeBloc({required this.apiService}) : super(RecipeInitial()) {
    on<FetchRecipes>(_onFetchRecipes);
    on<SearchRecipes>(_onSearchRecipes);
  }

  Future<void> _onFetchRecipes(FetchRecipes event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());
    try {
      final data = await apiService.fetchRecipes();
      _allRecipes = data;
      emit(RecipeLoaded(_allRecipes));
    } catch (e) {
      emit(RecipeError('Erro ao carregar receitas: $e'));
    }
  }

  void _onSearchRecipes(SearchRecipes event, Emitter<RecipeState> emit) {
    final filtered = _allRecipes
        .where((r) => r['name'].toLowerCase().contains(event.query.toLowerCase()))
        .toList();
    emit(RecipeLoaded(filtered, query: event.query));
  }
}
