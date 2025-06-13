import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_order_event.dart';
import 'create_order_state.dart';
import '/models/pop_create.dart';
import '/api/api_service.dart';

class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  final ApiService apiService;

  CreateOrderBloc(this.apiService) : super(CreateOrderInitial()) {
    on<CreateOrder>((event, emit) async {
      emit(CreateOrderLoading());
      try {
        final result = await apiService.createPop(event.popData);
        emit(CreateOrderSuccess(result));
      } catch (e) {
        emit(CreateOrderError("Erro ao criar POP"));
      }
    });
  }
}
