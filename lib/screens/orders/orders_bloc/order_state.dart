import '/models/order_model.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}

class OrderLoaded extends OrderState {
  final List<OrderModel> allOrders;
  final List<OrderModel> filteredOrders;
  final int currentPage;
  final int rowsPerPage;

  OrderLoaded({
    required this.allOrders,
    List<OrderModel>? filteredOrders,
    this.currentPage = 0,
    this.rowsPerPage = 10,
  }) : filteredOrders = filteredOrders ?? allOrders;

  OrderLoaded copyWith({
    List<OrderModel>? allOrders,
    List<OrderModel>? filteredOrders,
    int? currentPage,
    int? rowsPerPage,
  }) {
    return OrderLoaded(
      allOrders: allOrders ?? this.allOrders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      currentPage: currentPage ?? this.currentPage,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
    );
  }

  int get totalPages => (filteredOrders.length / rowsPerPage).ceil();

  List<OrderModel> get paginatedOrders {
    final start = currentPage * rowsPerPage;
    return filteredOrders.skip(start).take(rowsPerPage).toList();
  }
}