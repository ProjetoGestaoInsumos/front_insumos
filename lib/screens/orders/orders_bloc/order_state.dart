import 'package:front_insumos/models/pop.dart';

abstract class POPState {}

class POPInitial extends POPState {}

class POPLoading extends POPState {}

class POPError extends POPState {
  final String message;
  POPError(this.message);
}

class OrderCreated extends POPState {
  final POP pop;
  OrderCreated(this.pop);
}

class POPLoaded extends POPState {
  final List<POP> allPOPs;
  final List<POP> filteredPOPs;
  final int currentPage;
  final int rowsPerPage;

  POPLoaded({
    required this.allPOPs,
    List<POP>? filteredPOPs,
    this.currentPage = 0,
    this.rowsPerPage = 10,
  }) : filteredPOPs = filteredPOPs ?? allPOPs;

  POPLoaded copyWith({
    List<POP>? allPOPs,
    List<POP>? filteredPOPs,
    int? currentPage,
    int? rowsPerPage,
  }) {
    return POPLoaded(
      allPOPs: allPOPs ?? this.allPOPs,
      filteredPOPs: filteredPOPs ?? this.filteredPOPs,
      currentPage: currentPage ?? this.currentPage,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
    );
  }

  int get totalPages =>
      (filteredPOPs.length / rowsPerPage).ceil();

  List<POP> get paginatedPOPs {
    final start = currentPage * rowsPerPage;
    return filteredPOPs.skip(start).take(rowsPerPage).toList();
  }
}
