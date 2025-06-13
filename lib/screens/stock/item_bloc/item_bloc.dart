import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_insumos/api/api_service.dart';
import 'item_event.dart';
import 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ApiService apiService;

  ItemBloc({required this.apiService}) : super(ItemInitial()) {
    on<LoadItemEvent>(_onLoad);
    on<AddItemEvent>(_onAdd);
    on<DeleteItemEvent>(_onDelete);
  }

  Future<void> _onLoad(LoadItemEvent event, Emitter<ItemState> emit) async {
    emit(ItemLoading());
    try {
      final items = await apiService.fetchItems();
      emit(ItemLoaded(items));
    } catch (e) {
      emit(ItemError('Erro ao carregar ingredientes'));
    }
  }

  Future<void> _onAdd(AddItemEvent event, Emitter<ItemState> emit) async {
    try {
      final result = await apiService.createItem(event.item);
      if (result != null) {
        add(LoadItemEvent());
      } else {
        emit(ItemError('Erro ao adicionar ingrediente'));
      }
    } catch (e) {
      emit(ItemError('Erro ao adicionar ingrediente: $e'));
    }
  }

  Future<void> _onDelete(DeleteItemEvent event, Emitter<ItemState> emit) async {
    try {
      final success = await apiService.deleteItem(event.itemId);
      if (success) {
        add(LoadItemEvent());
      } else {
        emit(ItemError('Erro ao excluir ingrediente'));
      }
    } catch (e) {
      emit(ItemError('Erro ao excluir ingrediente: $e'));
    }
  }
}
