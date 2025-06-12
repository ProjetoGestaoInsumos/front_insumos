import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_insumos/api/api_service.dart';
import 'stock_event.dart';
import 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final ApiService apiService;

  StockBloc({required this.apiService}) : super(StockInitial()) {
    on<LoadStockEvent>(_onLoad);
    on<AddStockEvent>(_onAdd);
    on<UpdateStockEvent>(_onUpdate);
    on<DeleteStockEvent>(_onDelete);
  }

  Future<void> _onLoad(LoadStockEvent event, Emitter<StockState> emit) async {
    emit(StockLoading());
    try {
      final stocks = await apiService.fetchStocks();
      emit(StockLoaded(stocks));
    } catch (e) {
      emit(StockError('Erro ao carregar estoque'));
    }
  }

  Future<void> _onAdd(AddStockEvent event, Emitter<StockState> emit) async {
    try {
      final created = await apiService.createStock(event.stock);
      if (created != null) {
        add(LoadStockEvent());
      } else {
        emit(StockError('Erro ao adicionar lote'));
      }
    } catch (e) {
      emit(StockError('Erro ao adicionar lote: $e'));
    }
  }

  Future<void> _onUpdate(UpdateStockEvent event, Emitter<StockState> emit) async {
    try {
      final updated = await apiService.updateStock(event.stock);
      if (updated != null) {
        add(LoadStockEvent());
      } else {
        emit(StockError('Erro ao atualizar lote'));
      }
    } catch (e) {
      emit(StockError('Erro ao atualizar lote: $e'));
    }
  }

  Future<void> _onDelete(DeleteStockEvent event, Emitter<StockState> emit) async {
    try {
      final success = await apiService.deleteStock(event.stockId);
      if (success) {
        add(LoadStockEvent());
      } else {
        emit(StockError('Erro ao excluir lote'));
      }
    } catch (e) {
      emit(StockError('Erro ao excluir lote: $e'));
    }
  }
}
