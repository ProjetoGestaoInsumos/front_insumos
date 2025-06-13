abstract class OrderEvent {}

class LoadOrders extends OrderEvent {}

class SearchOrders extends OrderEvent {
  final String query;
  SearchOrders(this.query);
}

class ChangePage extends OrderEvent {
  final int page;
  ChangePage(this.page);
}
