import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_insumos/screens/orders/orders_bloc/order_event.dart';
import 'package:front_insumos/screens/orders/orders_bloc/order_state.dart';
import '/api/api_service.dart';
import 'package:intl/intl.dart';

class POPBloc extends Bloc<POPEvent, POPState> {
  final ApiService apiService;

  POPBloc({required this.apiService}) : super(POPInitial()) {
    on<LoadPOPs>(_onLoadPOPs);
    on<SearchPOPs>(_onSearchPOPs);
    on<ChangePage>(_onChangePage);
    on<CreatePOP>(_onCreatePOP);
  }

  // Função para carregar os POPs
  Future<void> _onLoadPOPs(LoadPOPs event, Emitter<POPState> emit) async {
    emit(POPLoading());
    try {
      final response = await apiService.fetchPopResponses();
      final pops = response; // Assumindo que a resposta é uma lista de POPs
      emit(POPLoaded(allPOPs: pops));
    } catch (_) {
      emit(POPError("Erro ao carregar POPs."));
    }
  }

  // Função para buscar os POPs
  void _onSearchPOPs(SearchPOPs event, Emitter<POPState> emit) {
    final currentState = state;
    if (currentState is POPLoaded) {
      final query = event.query.toLowerCase();
      final filtered = currentState.allPOPs.where((pop) {
        final dateFormatted = DateFormat('dd/MM/yyyy').format(pop.date);
        return pop.id.toString().contains(query) ||
            pop.docenteNome.toLowerCase().contains(query) ||
            pop.recipeName.toLowerCase().contains(query) ||
            dateFormatted.toLowerCase().contains(query);
      }).toList();

      emit(currentState.copyWith(filteredPOPs: filtered, currentPage: 0));
    }
  }

  // Função para trocar a página
  void _onChangePage(ChangePage event, Emitter<POPState> emit) {
    final currentState = state;
    if (currentState is POPLoaded) {
      final totalPages = currentState.totalPages;
      if (event.page >= 0 && event.page < totalPages) {
        emit(currentState.copyWith(currentPage: event.page));
      }
    }
  }

  Future<void> _onCreatePOP(CreatePOP event, Emitter<POPState> emit) async {
    emit(POPLoading()); // Mostra o carregando até a resposta

    try {
      final response =
          await apiService.createPop(event.pop); // Chama a API para criar o POP
      emit(OrderCreated(response)); // Emite o estado com o POP criado
    } catch (e) {
      emit(POPError("Erro ao criar o POP: $e"));
    }
  }
}
