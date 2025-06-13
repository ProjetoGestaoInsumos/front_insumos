import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_event.dart';
import 'order_state.dart';
import '/models/order_model.dart';
import '/api/api_service.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final ApiService apiService;

  OrderBloc(this.apiService) : super(OrderInitial()) {
    on<LoadOrders>((event, emit) async {
      emit(OrderLoading());
      try {
        final response = await apiService.fetchPOP();
        final orders = response.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();
        emit(OrderLoaded(allOrders: orders));
      } catch (_) {
        emit(OrderError("Erro ao carregar pedidos."));
      }
    });

    on<SearchOrders>((event, emit) {
      final currentState = state;
      if (currentState is OrderLoaded) {
        final query = event.query.toLowerCase();
        final filtered = currentState.allOrders.where((order) {
          return order.docenteNome.toLowerCase().contains(query) ||
              order.recipeName.toLowerCase().contains(query) ||
              order.date.toLowerCase().contains(query);
        }).toList();

        emit(currentState.copyWith(filteredOrders: filtered, currentPage: 0));
      }
    });

    on<ChangePage>((event, emit) {
      final currentState = state;
      if (currentState is OrderLoaded) {
        if (event.page >= 0 && event.page < currentState.totalPages) {
          emit(currentState.copyWith(currentPage: event.page));
        }
      }
    });
  }
}