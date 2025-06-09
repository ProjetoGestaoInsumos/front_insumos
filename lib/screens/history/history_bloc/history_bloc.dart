import 'package:flutter_bloc/flutter_bloc.dart';
import 'history_event.dart';
import 'history_state.dart';
import 'package:front_insumos/api/api_service.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final ApiService apiService;

  HistoryBloc({required this.apiService}) : super(HistoryInitial()) {
    on<FetchMovements>((event, emit) async {
      emit(HistoryLoading());
      try {
        final movements = await apiService.fetchMovements();
        emit(HistoryLoaded(movements));
      } catch (e) {
        emit(HistoryError("Erro ao carregar movimentos"));
      }
    });
  }
}
