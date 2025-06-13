import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_event.dart';
import 'order_state.dart';
import '/api/api_service.dart';
import 'package:intl/intl.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final ApiService apiService;
  final String baseUrl = const String.fromEnvironment('BACKEND_URL');
  
  OrderBloc(this.apiService) : super(OrderInitial()) {
    on<LoadOrders>((event, emit) async {
      emit(OrderLoading());
      try {
        final response = await apiService.fetchPopResponses(baseUrl);
        final orders = response;
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
      final dateFormatted = DateFormat('dd/MM/yyyy').format(order.date);
      return order.id.toString().contains(query) ||
             order.docenteNome.toLowerCase().contains(query) ||
             order.recipeName.toLowerCase().contains(query) ||
             dateFormatted.toLowerCase().contains(query);
    }).toList();

    emit(currentState.copyWith(filteredOrders: filtered, currentPage: 0));
  }
});

    on<ChangePage>((event, emit) {
      final currentState = state;
      if (currentState is OrderLoaded) {
        final totalPages = currentState.totalPages;
        if (event.page >= 0 && event.page < totalPages) {
          emit(currentState.copyWith(currentPage: event.page));
        }
      }
    });
  }
}
